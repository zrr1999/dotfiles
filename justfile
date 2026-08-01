set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

nixfiles_dir := justfile_directory() / ".config/nixfiles"

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

# 仅求值统一的用户 CLI flake
nix-check:
    nix flake check --all-systems --no-build --no-update-lock-file {{ quote("path:" + nixfiles_dir) }}

# 构建当前平台的用户 CLI profile，不创建 result 或切换配置
nix-build:
    nix build --no-link --no-update-lock-file {{ quote("path:" + nixfiles_dir + "#dotfiles-cli") }}

# 完整验证：全平台求值 + 当前平台 CLI 构建
nix-verify:
    nix flake check --all-systems --no-build --no-update-lock-file {{ quote("path:" + nixfiles_dir) }}
    nix build --no-link --no-update-lock-file {{ quote("path:" + nixfiles_dir + "#dotfiles-cli") }}
