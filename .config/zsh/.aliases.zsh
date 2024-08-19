# add some basic aliases
alias sudo='sudo -E '
alias sizeof="du -h --max-depth=0"
alias python='python3'
alias pip='pip3'
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
alias pd='pueued -d'
alias prun='pueue add -g parallel'
alias qrun='pueue add -g queue'

# add some modern software aliases
alias j='z'
alias grep='rg'
alias ls='lsd'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias curl='curl --keepalive-time 60'
alias conda='micromamba'
alias top='btm'
alias du='dust'
alias df='duf'

# add some complex aliases
tree () {
    local depth=3
    (($+2)) && depth=$2
    ls --tree --depth $depth $1
}

# add some file aliases
alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s bz2='tar -xjvf'
alias -s xz='tar -xf'
alias -s zip='unzip'
alias -s rar='unrar x'

# some git aliases
alias gsquash='git reset --soft HEAD~1 && git commit --amend'
