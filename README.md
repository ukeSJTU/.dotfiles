# my Dotfiles

[English](#english) | [中文](#中文)

<a name="english"></a>

## English

### Overview

This repository contains my personal dotfiles for configuring various tools and applications on macOS. It includes configuration for:

-   **zsh**: Shell configuration with zplug plugin manager
-   **starship**: Cross-shell prompt customization
-   **wezterm**: GPU-accelerated terminal emulator
-   **yazi**: Terminal file manager
-   **tmux**: Terminal multiplexer (configuration referenced in zsh setup)

### Installation

1. **Clone the repository:**

    ```bash
    git clone https://github.com/ukeSJTU/.dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    ```

2. **Run the installation script:**

    ```bash
    bash install.sh
    ```

    The installation script now supports several command line options:

    - **`-h` or `--help`**: Display a help message with usage instructions.
    - **`-f` or `--force`**: Automatically overwrite any conflicting files without prompting.
    - **`-d` or `--dry-run`**: Preview the actions without making any changes.

    For example, to force overwriting of conflicting files, run:

    ```bash
    bash install.sh --force
    ```

    Or to perform a dry run:

    ```bash
    bash install.sh --dry-run
    ```

### What's Included

#### Shell Environment (zsh)

-   Custom prompt using Starship
-   zplug for plugin management
-   Useful aliases and functions
-   Integration with tools like fzf, tmux, and yazi

#### Terminal (wezterm)

-   Custom theme and appearance
-   Background image support
-   Optimized font rendering
-   Hyperlink detection

#### File Management (yazi)

-   Custom theme (OneDark)
-   Optimized layout and keybindings

#### Prompt (starship)

-   Custom prompt format
-   Language-specific indicators
-   Git status integration

### Customization

To tailor the dotfiles for your own use:

1. Edit the configuration files in their respective directories.
2. Modify `symlinks.conf` to add, remove, or change the symbolic link mappings.

---

<a name="中文"></a>

## 中文

### 概述

这个仓库包含我个人在 macOS 上配置各种工具和应用程序的 dotfiles。它包括以下配置：

-   **zsh**: 使用 zplug 插件管理器的 shell 配置
-   **starship**: 跨 shell 的提示符自定义
-   **wezterm**: GPU 加速的终端模拟器
-   **yazi**: 终端文件管理器
-   **tmux**: 终端复用器（在 zsh 设置中引用）

### 安装

1. **克隆仓库：**

    ```bash
    git clone https://github.com/ukeSJTU/.dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    ```

2. **运行安装脚本：**

    ```bash
    bash install.sh
    ```

    安装脚本现在支持以下命令行选项：

    - **`-h` 或 `--help`**: 显示包含使用说明的帮助信息。
    - **`-f` 或 `--force`**: 自动覆盖任何冲突文件，无需提示。
    - **`-d` 或 `--dry-run`**: 预览操作而不进行任何更改。

    例如，要强制覆盖冲突文件，运行：

    ```bash
    bash install.sh --force
    ```

    或者执行预览运行：

    ```bash
    bash install.sh --dry-run
    ```

### 包含内容

#### Shell 环境 (zsh)

-   使用 Starship 的自定义提示符
-   使用 zplug 进行插件管理
-   有用的别名和函数
-   与 fzf、tmux 和 yazi 等工具的集成

#### 终端 (wezterm)

-   自定义主题和外观
-   背景图片支持
-   优化的字体渲染
-   超链接检测

#### 文件管理 (yazi)

-   自定义主题（OneDark）
-   优化的布局和键绑定

#### 提示符 (starship)

-   自定义提示符格式
-   特定语言的指示器
-   Git 状态集成

### 自定义

要为自己的使用定制这些 dotfiles：

1. 编辑各自目录中的配置文件。
2. 修改 `symlinks.conf` 以添加、删除或更改符号链接映射。

### Q&A

#### 1

symlinks.conf 中的 tmux 前两个看起来是重复的，这是因为 tmux 不同版本读区配置文件不同。3.1 版本之前的版本是读取~/.tmux.conf，3.1 版本之后的版本是读取~/.config/tmux/tmux.conf。为了兼容性，所以两个都写上了。
