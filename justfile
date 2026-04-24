set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# 列出所有命令
default:
    @just --list

# 运行 yadm bootstrap 完成安装与配置
install:
    yadm bootstrap

# 拉取最新配置并重新应用
update:
    yadm pull --rebase
    yadm bootstrap

# 仅拉取最新 dotfiles
pull:
    yadm pull --rebase

# 运行仓库校验
verify:
    uvx prek run -a
