#!/usr/bin/env python3
import json
import re
import subprocess
import sys


GIT_COMMIT_RE = re.compile(
    r"(^|[\s;&|])git(?:\s+-[^\s;&|]+)*\s+commit(?:\s|$)"
)
ANTHROPIC_AUTHOR_RE = re.compile(
    r"^\s*Co-Authored-By:.*<[^>\r\n]+@anthropic\.com>\s*$", re.IGNORECASE
)
SESSION_LINK_RE = re.compile(r"https?://claude\.ai/code/session[^\s<]*")


def is_git_commit(command: str) -> bool:
    return bool(GIT_COMMIT_RE.search(command))


def strip_metadata(message: str) -> str:
    first_line = message.splitlines(keepends=True)[:1]
    return "".join(
        line
        for line in first_line
        if not ANTHROPIC_AUTHOR_RE.search(line) and not SESSION_LINK_RE.search(line)
    )


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, OSError):
        return 0

    command = payload.get("tool_input", {}).get("command", "")
    if payload.get("tool_name") != "Bash" or not is_git_commit(command):
        return 0

    try:
        result = subprocess.run(
            ["git", "log", "-1", "--format=%B"],
            capture_output=True,
            check=True,
            text=True,
        )
    except (OSError, subprocess.CalledProcessError):
        return 0

    cleaned = strip_metadata(result.stdout)
    if cleaned == result.stdout:
        return 0

    subprocess.run(
        ["git", "commit", "--amend", "--no-verify", "-F", "-"],
        input=cleaned,
        check=False,
        text=True,
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
