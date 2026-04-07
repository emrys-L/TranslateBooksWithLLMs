#!/bin/bash
# EPUB 翻译 - Precise 精确模式启动脚本

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   EPUB 翻译 - Precise 精确模式${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# 配置参数
BOOK_EPUB="${1:-book.epub}"
TRANSLATION_ID="${2:-}"

# Precise 模式专用配置
MAX_CHUNK_SIZE=1000      # 每 chunk 最大字符数（默认 4000，精确模式 1000）
REQUEST_TIMEOUT=900      # 超时 15 分钟（默认 600 秒）
MIN_CHUNK_SIZE=5         # 最小 chunk 大小
CONTEXT_WINDOW=8192      # 上下文窗口

echo -e "${BLUE}📚 翻译文件${NC}: $BOOK_EPUB"
echo -e "${BLUE}🎯 模式${NC}: Precise 精确模式"
echo ""
echo -e "${YELLOW}⚙️  精确模式配置${NC}:"
echo "  - Chunk 大小：${MAX_CHUNK_SIZE} 字符（标准模式 4000）"
echo "  - 超时时间：${REQUEST_TIMEOUT}秒（标准模式 600）"
echo "  - 上下文窗口：${CONTEXT_WINDOW} tokens"
echo "  - 最小 chunk: ${MIN_CHUNK_SIZE} 字符"
echo ""

# 检查文件
if [ ! -f "$BOOK_EPUB" ]; then
    echo -e "${RED}❌ 错误：文件不存在 $BOOK_EPUB${NC}"
    exit 1
fi

# 生成或使用指定的 translation_id
if [ -z "$TRANSLATION_ID" ]; then
    TRANSLATION_ID="precise_$(openssl rand -hex 4)"
    echo -e "${YELLOW}🆔 新建翻译会话${NC}: $TRANSLATION_ID"
else
    echo -e "${YELLOW}🔄 恢复翻译会话${NC}: $TRANSLATION_ID"
fi

echo ""
echo -e "${GREEN}🚀 启动翻译进程...${NC}"

cd /home/syrme/TranslateBooksWithLLMs

# 创建 precise 模式的配置文件
cat > .env.precise << EOF
# Precise 模式配置
MAX_TOKENS_PER_CHUNK=${MAX_CHUNK_SIZE}
REQUEST_TIMEOUT=${REQUEST_TIMEOUT}
CONTEXT_WINDOW=${CONTEXT_WINDOW}
MIN_CHUNK_SIZE=${MIN_CHUNK_SIZE}

# API 配置
OPENAI_API_ENDPOINT=http://192.168.80.121:32788/v1/chat/completions
OPENAI_API_KEY=sSMCVe7TBAJPx0d0Ff4cB3569f7a41B7980bFd02888fA7A8
LLM_PROVIDER=openai
OPENAI_MODEL=qwen35-397b-a17b
EOF

# 加载配置
export MAX_TOKENS_PER_CHUNK=$MAX_CHUNK_SIZE
export REQUEST_TIMEOUT=$REQUEST_TIMEOUT
export CONTEXT_WINDOW=$CONTEXT_WINDOW
export MIN_CHUNK_SIZE=$MIN_CHUNK_SIZE

# 启动翻译
if [ -n "$TRANSLATION_ID" ]; then
    nohup python3 translate.py \
        -i "$BOOK_EPUB" \
        --translation-id "$TRANSLATION_ID" \
        -sl English -tl Chinese \
        -m qwen35-397b-a17b \
        --provider openai \
        --openai_api_key sSMCVe7TBAJPx0d0Ff4cB3569f7a41B7980bFd02888fA7A8 \
        --api_endpoint http://192.168.80.121:32788/v1/chat/completions \
        --min-chunk-size $MIN_CHUNK_SIZE \
        >> translation_precise.log 2>&1 &
else
    nohup python3 translate.py \
        -i "$BOOK_EPUB" \
        -sl English -tl Chinese \
        -m qwen35-397b-a17b \
        --provider openai \
        --openai_api_key sSMCVe7TBAJPx0d0Ff4cB3569f7a41B7980bFd02888fA7A8 \
        --api_endpoint http://192.168.80.121:32788/v1/chat/completions \
        --min-chunk-size $MIN_CHUNK_SIZE \
        >> translation_precise.log 2>&1 &
fi

PID=$!
echo $PID > translation_precise.pid

echo ""
echo -e "${GREEN}✅ Precise 模式翻译进程已启动${NC}"
echo -e "${YELLOW}📊 进程 ID${NC}: $PID"
echo -e "${YELLOW}📝 日志文件${NC}: translation_precise.log"
echo -e "${YELLOW}📁 输出目录${NC}: data/uploads/$TRANSLATION_ID/"
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Precise 模式特点${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "✅ 更小的 chunk - 翻译更精确，上下文保留更好"
echo "✅ 更长的超时 - 适合复杂段落和学术内容"
echo "✅ 更保守的重试 - 减少重复翻译"
echo "✅ 适合学术著作、技术文档等高质量要求场景"
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   监控命令${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "# 查看实时进度"
echo "tail -f translation_precise.log"
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
