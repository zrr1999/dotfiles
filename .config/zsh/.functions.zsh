function system-clean() {
    echo "🧹 开始系统清理..."

    # Homebrew 清理
    if command -v brew >/dev/null 2>&1; then
        echo "清理 Homebrew 缓存..."
        brew autoremove
        brew cleanup --prune=7 -s
    fi

    # Cargo 清理
    if command -v cargo >/dev/null 2>&1; then
        echo "清理 Cargo 缓存..."
        cargo cache -a 2>/dev/null || echo "cargo-cache 未安装，跳过"
    fi

    # Python pip 清理
    if command -v pip3 >/dev/null 2>&1; then
        echo "清理 pip 缓存..."
        pip3 cache purge
    fi

    # prek 清理（如果可用）
    if command -v prek >/dev/null 2>&1; then
        echo "清理 prek 缓存..."
        # Command not implemented yet
        # prek gc
    fi

    echo "✅ 系统清理完成！"
}
