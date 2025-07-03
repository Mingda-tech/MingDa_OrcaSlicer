# 应用程序启动时配置加载顺序分析

## 1. 启动流程概览

应用程序启动时的配置加载按以下顺序执行：

### 1.1 主要入口点
- `main()` → `CLI::run()` → `GUI_Run()` → `GUI_App::OnInit()` → `GUI_App::on_init_inner()`

### 1.2 关键配置加载步骤

## 2. 详细加载顺序

### 2.1 系统预设加载 (在GUI初始化早期)
**位置**: `GUI_App::on_init_inner()` 第2345-2346行
```cpp
BOOST_LOG_TRIVIAL(info) << "loading systen presets...";
preset_bundle = new PresetBundle();
```

### 2.2 预设包初始化
**位置**: `GUI_App::on_init_inner()` 第2499行
```cpp
init_params->preset_substitutions = preset_bundle->load_presets(*app_config, ForwardCompatibilitySubstitutionRule::EnableSystemSilent);
```
- 这里加载系统预设和用户保存的预设
- 使用app_config中保存的用户配置

### 2.3 当前预设加载
**位置**: `GUI_App::on_init_inner()` 第2541行
```cpp
load_current_presets();
```
- 这会调用每个Tab的`load_current_preset()`方法
- 对于打印机Tab，会调用`on_preset_loaded()`

### 2.4 AD-F4特殊处理执行时机
**位置**: `TabPrinter::on_preset_loaded()` 第4393-4419行
- 在打印机预设加载后立即执行
- 检查打印机名称是否包含"MINGDA AD-F4"
- 如果是AD-F4且启用了SEMM，强制设置4个耗材

## 3. 配置覆盖问题分析

### 3.1 可能的问题原因
1. **用户配置延迟加载**: 虽然AD-F4的特殊处理在`on_preset_loaded()`中执行，但可能存在其他地方会覆盖这个设置
2. **配置保存/恢复机制**: app_config可能保存了之前的耗材数量，并在某个时机恢复
3. **异步加载**: 可能存在异步的配置加载机制

### 3.2 关键观察点
- `on_preset_loaded()`在`load_current_preset()`中被调用（第4692行）
- 这发生在主窗口显示之前（mainframe->Show()在第2552行）
- 但在`post_init()`中可能还有额外的配置加载

## 4. 建议的调试步骤

1. **添加日志**: 在以下位置添加详细日志：
   - `PresetBundle::load_presets()`
   - `PresetBundle::set_num_filaments()`
   - `Plater::on_filaments_change()`
   - 任何可能修改耗材数量的地方

2. **检查post_init**: 查看`GUI_App::post_init()`是否有额外的配置加载

3. **监控配置变化**: 追踪`extruder_colour`配置项的所有修改点

4. **检查配置保存**: 确认AD-F4的4耗材设置是否正确保存到配置文件

## 5. 结论

AD-F4的特殊处理代码在正确的时机执行（预设加载后立即执行），但可能存在以下问题：
1. 后续的配置加载/恢复覆盖了设置
2. 配置没有正确保存
3. 存在其他代码路径修改了耗材数量

需要进一步调试以确定具体的覆盖点。