function system-clean(){
    brew autoremove
    brew cleanup --prune=7 -s
    cargo cache -a
    pip3 cache purge
    pre-commit gc
}
