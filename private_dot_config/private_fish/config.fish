set -x BUN_INSTALL "$HOME/.bun"
set -x GOPATH "$HOME/go"
set -gx FLYCTL_INSTALL "$HOME/.fly"
fish_add_path "$BUN_INSTALL/bin"
fish_add_path "$GOPATH/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/bin"
fish_add_path "/usr/share/bcc/tools"
fish_add_path "$HOME/.ghcup/bin"
fish_add_path "$HOME/.yarn/bin"
fish_add_path "$HOME/.wasmtime/bin"
fish_add_path "$HOME/.local/share/nvim/mason/bin"
fish_add_path "$HOME/.nimble/bin"
fish_add_path "$HOME/x-tools/m68k-unknown-linux-gnu/bin/"
fish_add_path "$HOME/x-tools/x86_64-unknown-linux-musl/bin/"
# fish_add_path "$HOME/android-ndk-r27c/toolchains/llvm/prebuilt/linux-x86_64/bin"
fish_add_path "$HOME/.luarocks/bin"
fish_add_path "$FLYCTL_INSTALL/bin"

alias lynx "lynx -vikeys"

alias typos "typos --config ~/.config/typos/typos.toml"

fish_vi_key_bindings

alias vi nvim
alias vim nvim
alias open xdg-open
alias airplane-mode "rfkill toggle all"
alias cha "cha -T text/html -I utf8"
alias man mancha

set -x GPG_TTY (tty)
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER bat
set -gx MANPAGER bat
set -gx MONOREPO $HOME/monorepo
set -gx MOZ_ENABLE_WAYLAND 1
set -gx MOZ_DISABLE_RDD_SANDBOX 1
set -gx CARGO_INCREMENTAL 1
set -gx BROWSER firefox
set -gx WASMTIME_HOME "$HOME/.wasmtime"
set -gx MISE_PIN 1

alias ls "ls -a --color=auto"
alias grep "grep --color=auto"
alias vimdiff "vim -d"
alias pip3 "python3 -m pip"
alias python "python3"
alias git "hub"
alias more "bat"
alias less "bat"
alias cat "bat"
alias copy "xclip -selection clipboard"

# BasicTex Support
# eval /usr/libexec/path_helper

alias musl-gcc "musl-gcc -static"

set FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --no-ignore-vcs'

source ~/.config/fish/functions/custom.fish

set -g -x fish_greeting ''
# set -gx OPENAI_API_KEY (pass openai-api-key) set -gx GEMINI_API_KEY (pass gemini-api-key)

source /home/takashi/.config/fish/kraft_completion.fish;

~/.local/bin/mise activate fish | source

test -r '/home/takashi/.opam/opam-init/init.fish' && source '/home/takashi/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
