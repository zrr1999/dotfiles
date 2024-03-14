# global config
setopt no_nomatch
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

SHELL=/bin/zsh
ZSH_THEME="robbyrussell"
ZSH_DISABLE_COMPFIX=true

ulimit -n 4096
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export GPG_TTY=$(tty)

fpath+=$HOME/.zfunc

zstyle ':completion:*' menu select
autoload -Uz compinit

# config local bin
export PATH=$PATH:$HOME/.local/bin

# config homebrew
if [[ -s $HOME/.brewconfig ]]; then
  source $HOME/.brewconfig
fi
if command -v brew >/dev/null 2>&1; then
  fpath+=$(brew --prefix)/share/zsh/site-functions
  export HOMEBREW_NO_AUTO_UPDATE=true
  export HOMEBREW_NO_INSTALL_FROM_API=1
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
fi

source $HOME/.config/zsh/.zi.zsh
source $HOME/.config/zsh/.aliases.zsh
source $HOME/.config/zsh/.functions.zsh

# config some tools in .dotconfig
for file in $HOME/.config/zsh/dotconfig/*; do
  if [ -f "$file" ]; then
    source "$file"
  fi
done

eval "$(atuin init zsh --disable-up-arrow)"
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

# config micromamba
if command -v micromamba >/dev/null 2>&1; then
  eval "$(micromamba shell hook --shell zsh)"
  export MAMBA_ROOT_PREFIX="$HOME/micromamba"
fi

# config pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# config cargo
export PATH=$HOME/.cargo/bin:$PATH

# config mojo
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.local/lib/mojo
export PATH=$PATH:$HOME/.modular/pkg/packages.modular.com_mojo/bin/

eval '$(auto-token shellenv)'
find ~/.ssh -name 'id_*' ! -name '*.pub' -exec ssh-add {} \;

