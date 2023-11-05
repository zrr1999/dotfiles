setopt no_nomatch
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

ZSH_THEME="robbyrussell"
ZSH_DISABLE_COMPFIX=true

fpath+=$HOME/.zfunc
if command -v brew >/dev/null 2>&1; then
  fpath+=$(brew --prefix)/share/zsh/site-functions
fi

zstyle ':completion:*' menu select
autoload -Uz compinit

eval "$(starship init zsh)"
source $HOME/.zi.zsh
source $HOME/.atuin.zsh
source $HOME/.aliases.zsh

# session-wise fix
ulimit -n 4096
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# config homebrew
if command -v brew >/dev/null 2>&1; then
  export HOMEBREW_NO_AUTO_UPDATE=true
  export HOMEBREW_NO_INSTALL_FROM_API=1
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
fi

# config micromamba
if command -v micromamba >/dev/null 2>&1; then
  eval "$(micromamba shell hook --shell zsh)"
  export MAMBA_ROOT_PREFIX="$HOME/micromamba"
fi

# config pnpm
export PATH="$PATH:$HOME/.local/bin"
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# config cargo
export PATH="$PATH:$HOME/.cargo/bin"

# config mojo
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/.local/lib/mojo
export PATH=$PATH:~/.modular/pkg/packages.modular.com_mojo/bin/
