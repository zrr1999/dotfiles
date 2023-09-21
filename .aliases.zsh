# add some basic aliases
alias sudo='sudo -E '
alias sizeof="du -h --max-depth=0"
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'

# add some modern software aliases
alias j='z'
alias grep='rg'
alias ls='lsd'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias wget='http --download'
alias conda='micromamba'
alias top='btm'

# add some complex aliases
tree () {
    local depth=3
    (($+1)) && {
        local depth=$1
    }
    ls --tree --depth $depth
}

# add some file aliases
alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s zip='unzip'
alias -s bz2='tar -xjvf'
