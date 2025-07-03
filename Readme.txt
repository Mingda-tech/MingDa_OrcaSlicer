加速编译的方法：

  1. 增量编译（最重要）

  # 不要每次都清理重建，直接在已有的 build 目录中编译
  cd build
  make -j$(nproc)  # Linux
  # 或者 Windows 在 VS 命令提示符中
  msbuild OrcaSlicer.sln -p:Configuration=Release -m

  2. 并行编译

  # Linux - 使用所有CPU核心
  make -j$(nproc)

  # Windows - 启用多进程编译
  build_release.bat slicer  # 已经启用了 /MP 选项

  3. 只编译必要部分

  # 如果已经编译过依赖，只编译 slicer 部分
  # Windows
  build_release.bat slicer

  # Linux
  ./BuildLinux.sh -si  # 跳过依赖编译

  4. 使用预编译头

  项目已经启用了预编译头，确保不要禁用它们。

  5. 调试模式vs发布模式

  # 调试模式编译更快（无优化）
  # Windows
  build_release.bat debug

  # Linux
  ./BuildLinux.sh -dsib

  6. 避免重复清理

  不要每次都运行：
  # 避免这样做
  rm -rf build deps/build

  7. 针对性编译

  如果只修改了特定模块，可以只编译那个目标：
  # 在 build 目录中
  make slic3r_app_gui -j$(nproc)

  最佳实践：修改代码后直接在 build 目录中运行增量编译，这样通常只需要几分钟而不是重新编译整个项目。