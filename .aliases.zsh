# add some alias
alias j='z'
alias grep='rg'
alias ls='lsd'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias wget='http --download'
tree () {
    local depth=3
    (($+1)) && {
        local depth=$1
    }
    ls --tree --depth $depth
}

alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s zip='unzip'
alias -s bz2='tar -xjvf'
