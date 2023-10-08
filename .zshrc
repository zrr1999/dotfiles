source /etc/profile
setopt no_nomatch
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

ZSH_THEME="robbyrussell"
ZSH_DISABLE_COMPFIX=true

fpath+=~/.zfunc
if command -v brew >/dev/null 2>&1; then
  fpath+=$(brew --prefix)/share/zsh/site-functions
fi

zstyle ':completion:*' menu select
autoload -Uz compinit

eval "$(starship init zsh)"
source ~/.zi.zsh
source ~/.atuin.zsh
source ~/.aliases.zsh

# session-wise fix
ulimit -n 4096
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# config homebrew
if command -v brew >/dev/null 2>&1; then
  export HOMEBREW_NO_AUTO_UPDATE=true
  export HOMEBREW_NO_INSTALL_FROM_API=1
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
fi

# config homebrew
if command -v micromamba >/dev/null 2>&1; then
  eval "$(micromamba shell hook --shell zsh)"
  export MAMBA_ROOT_PREFIX=/home/zrr/micromamba
fi
