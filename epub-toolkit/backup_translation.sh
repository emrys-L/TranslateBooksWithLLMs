#!/bin/bash
# 翻译进度备份脚本

set -e

# 配置
BACKUP_DIR="/mnt/data/workshop/translation/backups"
UPLOADS_DIR="/home/syrme/TranslateBooksWithLLMs/data/uploads"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 备份所有活跃的翻译会话
echo "📦 开始备份翻译进度..."

for session_dir in "$UPLOADS_DIR"/cli_*/; do
    if [ -d "$session_dir" ]; then
        session_name=$(basename "$session_dir")
        backup_path="$BACKUP_DIR/${session_name}_${TIMESTAMP}"
        
        echo "  备份：$session_name"
        cp -r "$session_dir" "$backup_path"
        
        # 压缩备份
        cd "$BACKUP_DIR"
        tar -czf "${session_name}_${TIMESTAMP}.tar.gz" "$session_name"
        rm -rf "$session_name"
        
        echo "  ✅ 完成：${session_name}_${TIMESTAMP}.tar.gz"
    fi
done

echo ""
echo "✅ 备份完成！"
echo "📁 备份位置：$BACKUP_DIR"
