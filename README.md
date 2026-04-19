# Dotfiles

使用 `yadm` 管理的个人 dotfiles，用来在 macOS、Arch Linux、Ubuntu 上快速恢复一致的 shell、Git 和开发环境。

## 快速开始

### 前置条件

- `curl`
- `git`
- 可联网环境

### 一键安装（推荐）

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/zrr1999/dotfiles/main/install.sh)
```

`install.sh` 会临时下载 `yadm`、clone 本仓库、执行 `yadm bootstrap`，最后清理临时文件。

### 手动使用 yadm

```bash
PATH="/usr/bin:/bin:$PATH" curl -fLo /tmp/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm \
&& chmod a+x /tmp/yadm \
&& /tmp/yadm clone https://github.com/zrr1999/dotfiles.git \
&& /tmp/yadm bootstrap \
&& rm /tmp/yadm
```

## Bootstrap 会做什么

1. 通过 `yadm clone` 拉下仓库，并自动执行 `post_clone` hook。
2. 在首次 clone 时收窄 sparse-checkout，只保留顶层入口文件。
3. 在非容器的 root 环境下，提示创建 `zrr` 用户并配置 sudo。
4. 按平台安装基础工具、`uv`、Node.js tooling、`nexttrace` 等。
5. 运行 `yadm alt` 应用模板和系统差异配置。

## Git 与 gix

- `git` 保持原生 Git，不做别名替换。
- `gix` 作为单独工具安装，需要时显式执行 `gix ...`。
- 不假设 `gix` 与 Git 完全兼容；涉及常见 Git 工作流时默认直接使用 `git`。

## 仓库内常用命令

clone 后进入仓库根目录：

- `just` / `just --list`：查看可用任务
- `just install`：重新执行 `yadm bootstrap`
- `just update`：拉取最新配置并重新应用
- `just pull`：只拉取，不执行 bootstrap
- `just verify`：运行脚本语法检查和 `prek`

## 平台说明

| 平台 | 安装方式 | 说明 |
| --- | --- | --- |
| macOS | `brew` | 安装主工具链，并额外装入部分 GUI / 系统工具 |
| Arch Linux | `pacman` + `uv tool` | 优先官方仓库，补充少量跨平台 CLI |
| Ubuntu | `apt` + `x-cmd` | `zsh` 走 `apt`，其余多数工具走 `x-cmd` |

## 关键文件

- `.config/yadm/bootstrap`：主安装逻辑
- `.config/yadm/hooks/post_clone`：首次 clone 后的收尾逻辑
- `.config/zsh/.aliases.zsh`：常用别名
- `.config/zsh/.functions.zsh`：常用 shell 函数
- `.gitconfig##template`：Git 模板配置
- `justfile`：仓库内维护命令
- `prek.toml`：仓库校验配置

## 验证与排障

```bash
just verify
```

如果安装阶段在 bootstrap 之前失败，优先确认 `curl` 和 `git` 已安装。

如果某个 `gix` 命令和预期不一致，优先直接回到 `git ...`，不要假设两者完全兼容。

## 许可证

本项目采用 MIT 许可证，详见 [LICENSE](LICENSE)。
