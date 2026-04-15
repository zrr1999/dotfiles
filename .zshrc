# global config
setopt no_nomatch
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

SHELL=/bin/zsh
ZSH_THEME="robbyrussell"
ZSH_DISABLE_COMPFIX=true

ulimit -n 4096
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
if [[ -o interactive ]]; then
  export GPG_TTY=$(tty)
fi

fpath+=$HOME/.zfunc

zstyle ':completion:*' menu select

# config local bin
export PATH=$PATH:$HOME/.local/bin

[ ! -s "$HOME/.brewconfig" ] || source "$HOME/.brewconfig"
[ ! -s "$HOME/.x-cmd.root/X" ] || source "$HOME/.x-cmd.root/X"

if command -v brew >/dev/null 2>&1; then
  fpath+=$(brew --prefix)/share/zsh/site-functions
  export HOMEBREW_NO_AUTO_UPDATE=true
  export HOMEBREW_NO_INSTALL_FROM_API=1
  export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
fi
if [[ -o interactive ]] && (( ${SHLVL:-1} == 1 )) && command -v fastfetch >/dev/null 2>&1 && [[ "${DOTFILES_FASTFETCH:-1}" == "1" ]]; then
  fastfetch
fi

source $HOME/.config/zsh/.zi.zsh
source $HOME/.config/zsh/.aliases.zsh
source $HOME/.config/zsh/.functions.zsh

# config some tools in .dotconfig
for file in $HOME/.config/zsh/dotconfig/.*; do
  if [ -f "$file" ]; then
    source "$file"
  fi
done

export STARSHIP_CONFIG="$HOME/.config/starship.toml"

# config fnm
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# config cargo
export PATH=$HOME/.cargo/bin:$PATH

# config mojo
export MODULAR_HOME="$HOME/.modular"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/.local/lib/arch-mojo
export PATH=$PATH:$HOME/.modular/pkg/packages.modular.com_max/bin/

# Vite+ (https://viteplus.dev)，若已安装则加载
[ -f "$HOME/.vite-plus/env" ] && . "$HOME/.vite-plus/env"

# zsh-defer eval "$(atuin init zsh --disable-up-arrow)"
if [[ -o interactive ]] && command -v ssh-add >/dev/null 2>&1 && [[ -n "${SSH_AUTH_SOCK:-}" ]]; then
  # Avoid recursively scanning ~/.ssh on every shell startup.
  zsh-defer '
    for key in "$HOME"/.ssh/id_*; do
      [[ -f "$key" ]] || continue
      [[ "$key" == *.pub ]] && continue
      ssh-add "$key" >/dev/null 2>&1
    done
  '
fi

# Initialize auto-token if available
command -v auto-token >/dev/null 2>&1 && eval $(auto-token shellenv)

