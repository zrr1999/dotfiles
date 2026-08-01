# nixfiles

这个 flake 只管理原来由 x-cmd 安装的用户 CLI 程序。

它不管理设备、系统设置、Home Manager、nix-darwin、NixOS 或其他 dotfiles；所有机器使用同一份程序清单，平台差异只由 Nix 的 `system` 选择处理。

## 验证

```bash
nix flake check --all-systems --no-build path:.
nix build --no-link path:.#dotfiles-cli
```

实际安装由父仓库的 yadm bootstrap 执行，生成一个名为 `dotfiles-cli` 的用户 profile。更新 nixpkgs 时运行：

```bash
nix flake update
```
