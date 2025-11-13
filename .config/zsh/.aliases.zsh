# 基本命令别名
alias sudo='sudo -E '  # 保持环境变量
alias sizeof="du -h --max-depth=0"  # 查看目录大小
alias python='python3'  # 默认使用 Python 3
alias pip='pip3'        # 默认使用 pip3

# URL 编解码工具
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'

# Pueue 任务管理
alias pd='pueued -d'              # 启动 pueue 守护进程
alias prun='pueue add -g parallel'  # 并行执行任务
alias qrun='pueue add -g queue'     # 队列执行任务

# 现代化工具别名
alias j='z'           # 目录跳转（z.lua）
alias grep='rg'       # 使用 ripgrep 替换 grep
alias ls='lsd'        # 使用 lsd 替换 ls
alias ll='ls -l'      # 详细列表
alias la='ls -a'      # 显示隐藏文件
alias lla='ls -la'    # 详细列表含隐藏文件
alias curl='curl --keepalive-time 60'  # 保持连接活跃
alias conda='micromamba'  # 使用 micromamba 替换 conda
alias top='btm'       # 使用 bottom 替换 top
alias du='dust'       # 使用 dust 替换 du
alias df='duf'        # 使用 duf 替换 df

# 性能优化别名
alias pre-commit='prek'  # 使用 prek 加速 pre-commit

# 复杂命令别名
# 树形显示目录结构（使用 lsd）
tree() {
    local depth=3
    # 如果提供了第二个参数，则使用它作为深度
    [[ -n "$2" ]] && depth="$2"
    ls --tree --depth "$depth" "${1:-.}"
}

# 文件类型别名（自动解压）
alias -s gz='tar -xzvf'   # .gz 文件自动解压
alias -s tgz='tar -xzvf'  # .tgz 文件自动解压
alias -s bz2='tar -xjvf'  # .bz2 文件自动解压
alias -s xz='tar -xf'     # .xz 文件自动解压
alias -s zip='unzip'      # .zip 文件自动解压
alias -s rar='unrar x'    # .rar 文件自动解压

# Git 命令别名
alias gsquash='git reset --soft HEAD~1 && git commit --amend'  # 合并最后一次提交
