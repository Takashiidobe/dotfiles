#!/usr/bin/env python3
"""PostToolUse hook (Edit|Write): silently deletes comment lines Claude just
added or modified, in C/C++/Rust/TS/JS/Python/Ruby files. Rewrites the file
directly -- no blocking, no round-trip through Claude."""
import json
import re
import sys

SLASH_EXTS = {
    "rs", "c", "h", "cc", "cpp", "cxx", "hh", "hpp", "hxx",
    "ts", "tsx", "js", "jsx", "mjs", "cjs",
}
HASH_EXTS = {"py", "rb"}

SLASH_LINE_RE = re.compile(r"^//.*$")
HASH_LINE_RE = re.compile(r"^#.*$")
TRIPLE_QUOTES = ('"""', "'''")

FILECHECK_DIRECTIVE_RE = re.compile(r"^//\s*[A-Z][A-Z0-9_]*(-[A-Z0-9_]+)*:")

SLATE_MARKER_RE = re.compile(r"^//\s*SLATE-")

MERGE_DIRECTIVE_RE = re.compile(r"^//\s*merge-")

DG_DIRECTIVE_RE = re.compile(r"\{\s*dg-")

DOC_COMMENT_RE = re.compile(r"^(///(?!/)|//!)")

SAFETY_RE = re.compile(r"^//\s*SAFETY:")

ANNOTATION_MARKER_RE = re.compile(
    r"^//\s*@(?:lowering|rewrite|check)(?:-not)?-(?:fn-)?(?:begin|end)\s*$"
)


def style_for(file_path: str):
    ext = file_path.rsplit(".", 1)[-1].lower() if "." in file_path else ""
    if ext in SLASH_EXTS:
        return "slash"
    if ext in HASH_EXTS:
        return "hash"
    return None


def strip_c_block_comments(text: str) -> str:
    """Remove /* ... */ spans (including multi-line), but only when the /*
    starts its line (preceded only by whitespace since the last newline).
    This mirrors the line-comment rule below and keeps a /*-looking
    substring inside a string/char literal mid-line from being treated as a
    real comment -- which previously deleted real code up to the next
    unrelated */. Keeps surrounding code on the same line intact and
    preserves newline count so line-based processing downstream still lines
    up."""
    out = []
    i = 0
    n = len(text)
    while i < n:
        if text.startswith("/*", i):
            line_start = text.rfind("\n", 0, i) + 1
            if text[line_start:i].strip() == "":
                end = text.find("*/", i + 2)
                if end == -1:
                    out.append(text[i:])
                    break
                if DG_DIRECTIVE_RE.search(text, i, end):
                    out.append(text[i : end + 2])
                    i = end + 2
                    continue
                out.append("\n" * text.count("\n", i, end + 2))
                i = end + 2
                continue
        out.append(text[i])
        i += 1
    return "".join(out)


def strip_comment_lines(text: str, style: str) -> str:
    original_lines = text.split("\n")

    if style == "slash":
        stripped_lines = strip_c_block_comments(text).split("\n")
    else:
        stripped_lines = original_lines

    out = []
    in_triple = None
    for i, (orig, line) in enumerate(zip(original_lines, stripped_lines)):
        if orig.strip() != "" and line.strip() == "":
            continue  # line was entirely a block comment

        if style == "hash":
            if in_triple:
                out.append(line)
                if line.count(in_triple) % 2 == 1:
                    in_triple = None
                continue
            opened = None
            for marker in TRIPLE_QUOTES:
                if line.count(marker) % 2 == 1:
                    opened = marker
                    break
            if opened:
                in_triple = opened
                out.append(line)
                continue
            if i == 0 and line.strip().startswith("#!"):
                out.append(line)
                continue
            if HASH_LINE_RE.match(line.strip()):
                continue
        elif style == "slash":
            stripped = line.strip()
            if (
                SLASH_LINE_RE.match(stripped)
                and not FILECHECK_DIRECTIVE_RE.match(stripped)
                and not SLATE_MARKER_RE.match(stripped)
                and not MERGE_DIRECTIVE_RE.match(stripped)
                and not DG_DIRECTIVE_RE.search(stripped)
                and not ANNOTATION_MARKER_RE.match(stripped)
                and not DOC_COMMENT_RE.match(stripped)
                and not SAFETY_RE.match(stripped)
            ):
                continue

        out.append(line)
    return "\n".join(out)


def main():
    raw = sys.stdin.read()
    if not raw:
        return 0
    data = json.loads(raw)

    tool_name = data.get("tool_name")
    tool_input = data.get("tool_input", {})
    file_path = tool_input.get("file_path")
    if not file_path or tool_name not in ("Edit", "Write"):
        return 0

    style = style_for(file_path)
    if style is None:
        return 0

    try:
        with open(file_path, "r") as f:
            current = f.read()
    except OSError:
        return 0

    if tool_name == "Write":
        content = tool_input.get("content", "")
        filtered = strip_comment_lines(content, style)
        if filtered != content:
            with open(file_path, "w") as f:
                f.write(filtered)
        return 0

    # Edit
    new_string = tool_input.get("new_string")
    if new_string is None:
        return 0
    filtered = strip_comment_lines(new_string, style)
    if filtered == new_string:
        return 0

    replace_all = tool_input.get("replace_all", False)
    if replace_all:
        updated = current.replace(new_string, filtered)
    else:
        updated = current.replace(new_string, filtered, 1)

    if updated != current:
        with open(file_path, "w") as f:
            f.write(updated)
    return 0


if __name__ == "__main__":
    sys.exit(main())
