# Dotfiles 任务（偏好：just 替代 Makefile）
# 需要先 clone 本仓库并进入目录后执行，例如: just install

[list]
description = "列出所有命令"

# 在已 clone 的 dotfiles 目录内：安装/更新环境（会调用 yadm bootstrap）
[install]
description = "运行 yadm bootstrap 完成安装与配置"
yadm bootstrap

# 拉取最新 dotfiles 并重新 bootstrap
[update]
description = "拉取最新配置并重新应用"
yadm pull --rebase
yadm bootstrap

# 仅拉取，不执行 bootstrap
[pull]
description = "仅拉取最新 dotfiles"
yadm pull --rebase
