# Dotfiles

[English](#english) | [中文](#中文)

<a name="english"></a>
## English

### Overview

This repository contains my personal dotfiles for configuring various tools and applications on macOS. It includes configuration for:

- **zsh**: Shell configuration with zplug plugin manager
- **starship**: Cross-shell prompt customization
- **wezterm**: GPU-accelerated terminal emulator
- **yazi**: Terminal file manager
- **tmux**: Terminal multiplexer (configuration referenced in zsh setup)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Run the installation script:
   ```bash
   bash install.sh
   ```

3. Follow the interactive menu to choose what to install:
   - Install prerequisites (Xcode CLI tools, Homebrew)
   - Install apps and tools (via Homebrew)
   - Set up dotfiles (create symbolic links)
   - Install everything

### What's Included

#### Shell Environment (zsh)
- Custom prompt using Starship
- zplug for plugin management
- Useful aliases and functions
- Integration with tools like fzf, tmux, and yazi

#### Terminal (wezterm)
- Custom theme and appearance
- Background image support
- Optimized font rendering
- Hyperlink detection

#### File Management (yazi)
- Custom theme (OneDark)
- Optimized layout and keybindings

#### Prompt (starship)
- Custom prompt format
- Language-specific indicators
- Git status integration

### Customization

To customize the dotfiles for your own use:

1. Edit the configuration files in their respective directories
2. Modify `symlinks.conf` to add or remove symlinks
3. Update `scripts/brew-install-custom.sh` to change which applications are offered for installation

### Troubleshooting

- **Wezterm configuration issues**: When modifying wezterm configuration files in the dotfiles repository, you may need to recreate the symlinks for the changes to take effect. This is due to how wezterm handles file monitoring. For more details, see [this issue](https://github.com/wezterm/wezterm/issues/1697).

---

<a name="中文"></a>
## 中文

### 概述

这个仓库包含我个人在 macOS 上配置各种工具和应用程序的 dotfiles。它包括以下配置：

- **zsh**: 使用 zplug 插件管理器的 shell 配置
- **starship**: 跨 shell 的提示符自定义
- **wezterm**: GPU 加速的终端模拟器
- **yazi**: 终端文件管理器
- **tmux**: 终端复用器（在 zsh 设置中引用）

### 安装

1. 克隆仓库：
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. 运行安装脚本：
   ```bash
   bash install.sh
   ```

3. 按照交互式菜单选择要安装的内容：
   - 安装先决条件（Xcode CLI 工具，Homebrew）
   - 安装应用程序和工具（通过 Homebrew）
   - 设置 dotfiles（创建符号链接）
   - 安装所有内容

### 包含内容

#### Shell 环境 (zsh)
- 使用 Starship 的自定义提示符
- 使用 zplug 进行插件管理
- 有用的别名和函数
- 与 fzf、tmux 和 yazi 等工具的集成

#### 终端 (wezterm)
- 自定义主题和外观
- 背景图片支持
- 优化的字体渲染
- 超链接检测

#### 文件管理 (yazi)
- 自定义主题（OneDark）
- 优化的布局和键绑定

#### 提示符 (starship)
- 自定义提示符格式
- 特定语言的指示器
- Git 状态集成

### 自定义

要为自己的使用自定义 dotfiles：

1. 编辑各自目录中的配置文件
2. 修改 `symlinks.conf` 以添加或删除符号链接
3. 更新 `scripts/brew-install-custom.sh` 以更改提供安装的应用程序

### 故障排除

- **Wezterm 配置问题**：在 dotfiles 仓库中修改 wezterm 配置文件时，您可能需要重新创建符号链接才能使更改生效。这是由于 wezterm 处理文件监控的方式。有关更多详细信息，请参阅[此问题](https://github.com/wezterm/wezterm/issues/1697)。
