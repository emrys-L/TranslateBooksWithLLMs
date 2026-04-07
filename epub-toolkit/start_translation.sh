#!/bin/bash
# EPUB 翻译启动脚本

set -e

# 配置
BOOK_EPUB="${1:-book.epub}"
TRANSLATION_ID="${2:-}"
TIMEOUT=600

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   EPUB 翻译工具包 - 启动翻译${NC}"
echo -e "${GREEN}========================================${NC}"

# 检查文件
if [ ! -f "$BOOK_EPUB" ]; then
    echo -e "${RED}错误：文件不存在 $BOOK_EPUB${NC}"
    exit 1
fi

# 获取文件大小
FILE_SIZE=$(ls -lh "$BOOK_EPUB" | awk '{print $5}')
echo -e "${YELLOW}📚 翻译文件${NC}: $BOOK_EPUB ($FILE_SIZE)"

# 生成或使用指定的 translation_id
if [ -z "$TRANSLATION_ID" ]; then
    TRANSLATION_ID="cli_$(openssl rand -hex 4)"
    echo -e "${YELLOW}🆔 新建翻译会话${NC}: $TRANSLATION_ID"
else
    echo -e "${YELLOW}🔄 恢复翻译会话${NC}: $TRANSLATION_ID"
fi

echo -e "${YELLOW}⏱️  超时设置${NC}: ${TIMEOUT}秒"
echo ""

# 启动翻译
cd /home/syrme/TranslateBooksWithLLMs

echo -e "${GREEN}🚀 启动翻译进程...${NC}"

export REQUEST_TIMEOUT=$TIMEOUT

if [ -n "$TRANSLATION_ID" ]; then
    nohup python3 translate.py \
        -i "$BOOK_EPUB" \
        --translation-id "$TRANSLATION_ID" \
        -sl English -tl Chinese \
        -m qwen35-397b-a17b \
        --provider openai \
        --openai_api_key sSMCVe7TBAJPx0d0Ff4cB3569f7a41B7980bFd02888fA7A8 \
        --api_endpoint http://192.168.80.121:32788/v1/chat/completions \
        >> translation.log 2>&1 &
else
    nohup python3 translate.py \
        -i "$BOOK_EPUB" \
        -sl English -tl Chinese \
        -m qwen35-397b-a17b \
        --provider openai \
        --openai_api_key sSMCVe7TBAJPx0d0Ff4cB3569f7a41B7980bFd02888fA7A8 \
        --api_endpoint http://192.168.80.121:32788/v1/chat/completions \
        >> translation.log 2>&1 &
fi

PID=$!
echo $PID > translation.pid

echo ""
echo -e "${GREEN}✅ 翻译进程已启动${NC}"
echo -e "${YELLOW}📊 进程 ID${NC}: $PID"
echo -e "${YELLOW}📝 日志文件${NC}: translation.log"
echo -e "${YELLOW}📁 输出目录${NC}: data/uploads/$TRANSLATION_ID/"
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   监控命令${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "# 查看实时进度"
echo "tail -f translation.log"
echo ""
echo "# 查看已完成章节数"
echo "ls data/uploads/$TRANSLATION_ID/translated_files/text/ | wc -l"
echo ""
echo "# 检查进程状态"
echo "ps aux | grep translate.py | grep -v grep"
echo ""
echo "# 停止翻译"
echo "kill $PID"
echo ""
