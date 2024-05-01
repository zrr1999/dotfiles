if [[ ! -f $HOME/.zi/bin/zi.zsh ]]; then
  print -P "%F{33}▓▒░ %F{160}Installing (%F{33}z-shell/zi%F{160})…%f"
  command mkdir -p "$HOME/.zi" && command chmod go-rwX "$HOME/.zi"
  command git clone -q --depth=1 --branch "main" https://github.com/z-shell/zi "$HOME/.zi/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "$HOME/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

zi wait lucid light-mode for \
    zsh-users/zsh-syntax-highlighting \
    skywind3000/z.lua \

if [[ -n $(command -v docker) ]]; then
  zi wait lucid light-mode for \
    redxtech/zsh-containers
fi

zi lucid light-mode for \
    wintermi/zsh-starship \
    davidde/git \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    z-shell/brew-completions \
    zrr1999/zsh-ssh \
    Game4Move78/zsh-bitwarden \
    rapgenic/zsh-git-complete-urls \
    z-shell/zbrowse \
    romkatv/zsh-defer

zi snippet OMZL::clipboard.zsh
zi snippet OMZL::completion.zsh
zi snippet OMZL::directories.zsh
zi snippet OMZL::history.zsh
zi snippet OMZL::key-bindings.zsh
zi snippet OMZP::colored-man-pages

zicompinit
