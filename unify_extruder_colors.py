#!/usr/bin/env python3
import json
import os
import glob
from collections import defaultdict

# 定义每个机型系列的默认颜色
# 您可以根据需要修改这些颜色
DEFAULT_COLORS = {
    # 单挤出机使用一种颜色
    "single": ["#1E88E5"],  # 蓝色
    # 双挤出机使用两种颜色
    "dual": ["#1E88E5", "#E53935"],  # 蓝色和红色
    # 四材料SEMM使用四种颜色
    "quad": ["#1E88E5", "#E53935", "#43A047", "#FB8C00"]  # 蓝、红、绿、橙
}

def get_machine_info(filename):
    """从文件名提取机型信息"""
    base_name = os.path.basename(filename)
    # 移除文件扩展名
    base_name = base_name.replace('.json', '')
    
    # 提取机型名称（移除喷嘴信息）
    machine_name = base_name
    for nozzle_size in ['0.4 nozzle', '0.6 nozzle', '0.8 nozzle', 
                        '(0.4 nozzle)', '(0.6 nozzle)', '(0.8 nozzle)']:
        machine_name = machine_name.replace(nozzle_size, '').strip()
    
    return machine_name

def update_extruder_colors():
    machine_dir = "/mnt/e/MingDa_OrcaSlicer/resources/profiles/MingDa/machine"
    
    # 首先收集所有机型的信息
    machine_groups = defaultdict(list)
    
    # 获取所有JSON文件
    json_files = glob.glob(os.path.join(machine_dir, "*.json"))
    
    for file_path in json_files:
        # 跳过通用配置文件
        if 'common' in os.path.basename(file_path).lower():
            continue
            
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            # 只处理包含extruder_colour的文件
            if 'extruder_colour' in data:
                machine_name = get_machine_info(file_path)
                extruder_count = len(data['extruder_colour'])
                machine_groups[machine_name].append({
                    'path': file_path,
                    'data': data,
                    'extruder_count': extruder_count
                })
                
        except Exception as e:
            print(f"Error reading {file_path}: {e}")
    
    # 为每个机型组设置统一的颜色
    for machine_name, machines in machine_groups.items():
        # 确定该机型的挤出机数量（取最大值）
        max_extruders = max(m['extruder_count'] for m in machines)
        
        # 选择合适的颜色方案
        if max_extruders == 1:
            colors = DEFAULT_COLORS["single"]
        elif max_extruders == 2:
            colors = DEFAULT_COLORS["dual"]
        elif max_extruders >= 4:
            colors = DEFAULT_COLORS["quad"][:max_extruders]
        else:
            # 对于3个挤出机，使用前3个颜色
            colors = DEFAULT_COLORS["quad"][:max_extruders]
        
        print(f"\n机型: {machine_name} (挤出机数: {max_extruders})")
        print(f"  使用颜色: {colors}")
        
        # 更新该机型所有配置文件的颜色
        for machine in machines:
            file_path = machine['path']
            data = machine['data']
            
            # 根据该具体机器的挤出机数量设置颜色
            machine_extruder_count = machine['extruder_count']
            data['extruder_colour'] = colors[:machine_extruder_count]
            
            # 保存文件
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=4, ensure_ascii=False)
            
            print(f"  已更新: {os.path.basename(file_path)}")

def main():
    print("开始统一设置机型默认耗材颜色...")
    update_extruder_colors()
    print("\n完成！")

if __name__ == "__main__":
    main()