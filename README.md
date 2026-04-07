# My Dotfiles

一个现代化的 dotfiles 配置，支持多平台（macOS、Arch Linux、Ubuntu），提供完整的开发环境配置。

## ✨ 特性

- 🚀 **现代化工具链**: 使用 starship、zi、lsd、ripgrep 等现代化工具
- 🎯 **多平台支持**: 支持 macOS、Arch Linux、Ubuntu
- 🔧 **自动化安装**: 一键安装和配置所有工具
- 📦 **包管理器集成**: 支持 brew、pacman、apt 等包管理器
- 🐍 **Python 环境**: uv 为主（包/工具）
- 🔐 **安全配置**: GPG 签名、SSH 密钥管理

## 🚀 快速安装

### 前置条件
- Git
- Curl
- 网络连接

### 一键安装
```bash
# 方法1: 使用 yadm（推荐）
PATH=/tmp:$PATH curl -fLo /tmp/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm \
&& chmod a+x /tmp/yadm \
&& /tmp/yadm clone https://github.com/zrr1999/dotfiles.git \
&& /tmp/yadm bootstrap \
&& rm /tmp/yadm

# 方法2: 使用安装脚本（一键安装）
bash <(curl -fsSL https://raw.githubusercontent.com/zrr1999/dotfiles/main/install)
```

安装完成后，在 dotfiles 目录内可用 **just** 执行常用任务：
- `just install` — 运行 yadm bootstrap
- `just update` — 拉取最新配置并重新应用

### Arch Linux 镜像优化
```bash
echo "Setting up pacman mirrorlist"
sudo pacman -S --noconfirm --needed reflector
sudo reflector --save /etc/pacman.d/mirrorlist --country China --protocol https --latest 5
```

## 🔧 主要配置

### Zsh 配置
- **插件管理**: 使用 zi 管理 zsh 插件
- **主题**: Starship 现代化提示符
- **补全**: 智能命令补全和语法高亮
- **别名**: 现代化工具别名（ls→lsd, grep→rg 等）

### 开发工具
- **编辑器**: Helix
- **版本控制**: Git + Git LFS + GPG 签名
- **Python**: uv 包管理 + 全局工具（prek、ty、ruff 等）
- **Node.js**: fnm + Node.js LTS + pnpm + Bun
- **Rust**: Cargo 工具链
- **Vite+**: 若已安装（~/.vite-plus/env），会在 shell 中自动加载
- **任务脚本**: just（替代 Makefile）

### 系统工具
- **文件管理**: lsd, dust, duf
- **搜索工具**: ripgrep, fd
- **网络工具**: httpie, nexttrace
- **监控工具**: bottom, procs

## 🛠️ 自定义配置

安装完成后，你可以根据需要修改以下文件：

- `~/.config/zsh/.aliases.zsh` - 添加自定义别名
- `~/.config/zsh/.functions.zsh` - 添加自定义函数
- `~/.config/starship.toml` - 自定义提示符样式
- `~/.gitconfig` - 修改 Git 配置

## 🔐 安全说明

- Git 提交默认启用 GPG 签名
- SSH 密钥自动加载到 ssh-agent

## 📝 许可证
本项目采用 MIT 许可证，详见 [LICENSE](LICENSE) 文件。
