#!/bin/bash
# EPUB 翻译质量全面检查脚本

set -e

# 配置
UPLOADS_DIR="${1:-/home/syrme/TranslateBooksWithLLMs/data/uploads/cli_45544b92}"
OUTPUT_LOG="${2:-/mnt/data/workshop/translation/quality_check.log}"
EPUB_FILE="${3:-/mnt/data/workshop/book (Chinese).epub}"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   EPUB 翻译质量全面检查${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# 初始化日志
echo "=== 翻译质量全面检查 ===" > "$OUTPUT_LOG"
echo "开始时间：$(date)" >> "$OUTPUT_LOG"
echo "" >> "$OUTPUT_LOG"

# 阶段 1：未翻译 chunks 分析
echo -e "${BLUE}[阶段 1/5]${NC} 未翻译 Chunks 分析..."
echo "=== 阶段 1：未翻译 Chunks 分析 ===" >> "$OUTPUT_LOG"
echo "" >> "$OUTPUT_LOG"

TRANSLATION_LOG="/home/syrme/TranslateBooksWithLLMs/translation.log"
if [ -f "$TRANSLATION_LOG" ]; then
    UNTRANSLATED_COUNT=$(grep -c "Phase 3 fallback" "$TRANSLATION_LOG" || echo 0)
    echo "统计未翻译 chunks 数量:" >> "$OUTPUT_LOG"
    echo "$UNTRANSLATED_COUNT" >> "$OUTPUT_LOG"
    echo "" >> "$OUTPUT_LOG"
    echo "未翻译 chunks 详细列表:" >> "$OUTPUT_LOG"
    grep "Phase 3 fallback" "$TRANSLATION_LOG" >> "$OUTPUT_LOG" || true
    echo -e "  ${YELLOW}未翻译 chunks${NC}: $UNTRANSLATED_COUNT"
else
    echo -e "  ${RED}日志文件不存在${NC}"
fi
echo ""

# 阶段 2：英文残留全面检测
echo -e "${BLUE}[阶段 2/5]${NC} 英文残留全面检测（54 个文件）..."
echo "=== 阶段 2：英文残留全面检测（54 个文件）===" >> "$OUTPUT_LOG"
echo "" >> "$OUTPUT_LOG"

TRANSLATED_DIR="$UPLOADS_DIR/translated_files/text"
if [ -d "$TRANSLATED_DIR" ]; then
    HIGH_RESIDUAL_FILES=()
    for file in "$TRANSLATED_DIR"/*.html; do
        filename=$(basename "$file")
        english_count=$(grep -oE "[A-Za-z]{4,}" "$file" 2>/dev/null | wc -l)
        total_chars=$(wc -c < "$file")
        if [ "$total_chars" -gt 0 ]; then
            density=$(echo "scale=2; $english_count * 1000 / $total_chars" | bc)
            echo "$filename: 英文单词=$english_count, 密度=${density}/千字符" >> "$OUTPUT_LOG"
            
            # 标记高密度文件
            if (( $(echo "$density > 50" | bc -l) )); then
                HIGH_RESIDUAL_FILES+=("$filename ($density/千字符)")
            fi
        fi
    done
    
    if [ ${#HIGH_RESIDUAL_FILES[@]} -gt 0 ]; then
        echo -e "  ${YELLOW}高英文残留文件${NC}: ${#HIGH_RESIDUAL_FILES[@]}个"
        for f in "${HIGH_RESIDUAL_FILES[@]}"; do
            echo -e "    - $f"
        done
    else
        echo -e "  ${GREEN}所有文件英文残留正常${NC}"
    fi
else
    echo -e "  ${RED}翻译目录不存在${NC}"
fi
echo ""

# 阶段 3：HTML 标签完整性检查
echo -e "${BLUE}[阶段 3/5]${NC} HTML 标签完整性检查..."
echo "" >> "$OUTPUT_LOG"
echo "=== 阶段 3：HTML 标签完整性检查 ===" >> "$OUTPUT_LOG"
echo "" >> "$OUTPUT_LOG"

PLACEHOLDER_ISSUES=0
if [ -d "$TRANSLATED_DIR" ]; then
    for file in "$TRANSLATED_DIR"/*.html; do
        filename=$(basename "$file")
        placeholder_count=$(grep -c "\[id[0-9]\]" "$file" 2>/dev/null | head -1)
        if [ "$placeholder_count" -gt 0 ] 2>/dev/null; then
            echo "⚠️ $filename: 发现 $placeholder_count 个未解析占位符" >> "$OUTPUT_LOG"
            ((PLACEHOLDER_ISSUES++)) || true
        fi
    done
    
    if [ $PLACEHOLDER_ISSUES -gt 0 ]; then
        echo -e "  ${RED}发现占位符残留${NC}: $PLACEHOLDER_ISSUES个文件"
    else
        echo -e "  ${GREEN}HTML 标签完整，无占位符残留${NC}"
    fi
fi
echo ""

# 阶段 4：EPUB 结构验证
echo -e "${BLUE}[阶段 4/5]${NC} EPUB 结构验证..."
echo "" >> "$OUTPUT_LOG"
echo "=== 阶段 4：EPUB 结构验证 ===" >> "$OUTPUT_LOG"
echo "" >> "$OUTPUT_LOG"

if [ -f "$EPUB_FILE" ]; then
    echo "1. EPUB 完整性检查:" >> "$OUTPUT_LOG"
    if unzip -t "$EPUB_FILE" >> "$OUTPUT_LOG" 2>&1; then
        echo -e "  ${GREEN}✓ EPUB 文件完整无损${NC}"
    else
        echo -e "  ${RED}✗ EPUB 文件损坏${NC}"
    fi
    
    echo "" >> "$OUTPUT_LOG"
    echo "2. 文件数量统计:" >> "$OUTPUT_LOG"
    HTML_COUNT=$(unzip -l "$EPUB_FILE" | grep -c "\.xhtml\|\.html" || echo 0)
    echo "$HTML_COUNT" >> "$OUTPUT_LOG"
    echo -e "  ${YELLOW}HTML 文件数${NC}: $HTML_COUNT"
    
    echo "" >> "$OUTPUT_LOG"
    echo "3. 关键文件检查:" >> "$OUTPUT_LOG"
    unzip -l "$EPUB_FILE" | grep -E "part0000|part0054|titlepage" >> "$OUTPUT_LOG" || true
else
    echo -e "  ${RED}EPUB 文件不存在${NC}: $EPUB_FILE"
fi
echo ""

# 阶段 5：生成总结报告
echo -e "${BLUE}[阶段 5/5]${NC} 生成总结报告..."
echo "" >> "$OUTPUT_LOG"
echo "=== 检查总结 ===" >> "$OUTPUT_LOG"
echo "完成时间：$(date)" >> "$OUTPUT_LOG"
echo "" >> "$OUTPUT_LOG"

# 计算总评分
TOTAL_SCORE=100
if [ $UNTRANSLATED_COUNT -gt 50 ]; then
    ((TOTAL_SCORE-=10)) || true
fi
if [ ${#HIGH_RESIDUAL_FILES[@]} -gt 10 ]; then
    ((TOTAL_SCORE-=10)) || true
fi
if [ $PLACEHOLDER_ISSUES -gt 0 ]; then
    ((TOTAL_SCORE-=20)) || true
fi

echo "问题文件统计:" >> "$OUTPUT_LOG"
echo "- 未翻译 chunks: $UNTRANSLATED_COUNT" >> "$OUTPUT_LOG"
echo "- 高英文残留文件：${#HIGH_RESIDUAL_FILES[@]}" >> "$OUTPUT_LOG"
echo "- 有占位符残留的文件：$PLACEHOLDER_ISSUES" >> "$OUTPUT_LOG"
echo "" >> "$OUTPUT_LOG"
echo "综合评分：$TOTAL_SCORE/100" >> "$OUTPUT_LOG"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   检查完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}📊 综合评分${NC}: $TOTAL_SCORE/100"
echo -e "${YELLOW}📝 详细报告${NC}: $OUTPUT_LOG"
echo ""

if [ $TOTAL_SCORE -ge 85 ]; then
    echo -e "${GREEN}✅ 翻译质量优秀！${NC}"
elif [ $TOTAL_SCORE -ge 70 ]; then
    echo -e "${YELLOW}⚠️  翻译质量良好，部分需要改进${NC}"
else
    echo -e "${RED}❌ 翻译质量问题较多，建议重译${NC}"
fi
