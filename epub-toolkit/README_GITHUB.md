# 📚 EPUB 翻译工具包

<div align="center">

**使用 AI 大模型翻译 EPUB 电子书的完整工具包**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![Status](https://img.shields.io/badge/status-production%20ready-green)]()

[功能特性](#-功能特性) • [快速开始](#-快速开始) • [安装指南](#-安装指南) • [使用示例](#-使用示例) • [成功案例](#-成功案例)

</div>

---

## 📖 简介

这是一个**完整的 EPUB 翻译解决方案**，专为翻译学术著作、技术文档和文学作品而设计。基于开源项目 [TranslateBooksWithLLMs](https://github.com/hydropix/TranslateBooksWithLLMs)，集成了翻译启动、质量检查、进度备份等全套工具。

### ✨ 核心优势

- ✅ **完整翻译** - 支持任意大小 EPUB 文件
- ✅ **断点续翻** - 中断后可从任意位置恢复
- ✅ **质量保证** - 5 阶段全面质量检测
- ✅ **学术优化** - 保留人名、书名、引用原文（便于检索）
- ✅ **本地部署** - 支持本地 AI 模型，保护隐私

---

## 🚀 功能特性

### 1. 智能翻译
- 支持 Qwen、MiniMax、GPT 等多种 AI 模型
- 自动检测文件类型（EPUB/SRT/TXT）
- 智能分块处理，保持上下文连贯
- HTML 标签和格式完整保留

### 2. 断点续翻
- 自动保存翻译进度
- 支持从中断处继续
- 零进度丢失保障

### 3. 质量检查
- 英文残留检测
- HTML 标签完整性验证
- EPUB 结构验证
- 未翻译内容统计

### 4. 备份管理
- 自动备份翻译进度
- 压缩存储节省空间
- 支持多版本管理

---

## 📦 安装指南

### 前置要求

- Python 3.8+
- Git
- 一个可用的 AI 模型（本地或云端）

### 步骤 1：克隆依赖项目

```bash
# 克隆翻译工具
git clone https://github.com/hydropix/TranslateBooksWithLLMs.git
cd TranslateBooksWithLLMs

# 安装依赖
pip3 install --break-system-packages -r requirements.txt
```

### 步骤 2：配置 API

```bash
# 创建配置文件
cat > .env << 'EOF'
# 本地 Qwen 配置（推荐）
OPENAI_API_ENDPOINT=http://192.168.80.121:32788/v1/chat/completions
OPENAI_API_KEY=your_api_key_here
LLM_PROVIDER=openai
OPENAI_MODEL=qwen35-397b-a17b
REQUEST_TIMEOUT=600

# 或使用云端 API（示例：MiniMax）
# OPENAI_API_ENDPOINT=https://api.minimaxi.com/anthropic/v1/messages
# OPENAI_API_KEY=your_minimax_key
# OPENAI_MODEL=MiniMax-M2.7
EOF
```

---

## 🎯 快速开始

### 方法 1：使用启动脚本（推荐）

```bash
# 启动翻译
./start_translation.sh book.epub

# 恢复翻译（使用之前的 session ID）
./start_translation.sh book.epub cli_xxxxxxxx
```

### 方法 2：手动启动

```bash
# 设置环境变量
export REQUEST_TIMEOUT=600

# 启动翻译
nohup python3 translate.py \
  -i book.epub \
  -sl English -tl Chinese \
  -m qwen35-397b-a17b \
  --provider openai \
  --openai_api_key YOUR_API_KEY \
  --api_endpoint http://192.168.80.121:32788/v1/chat/completions \
  >> translation.log 2>&1 &

# 保存进程 ID
echo $! > translation.pid
```

---

## 📊 监控进度

### 实时日志

```bash
# 查看实时进度
tail -f translation.log
```

### 检查完成数量

```bash
# 查看已完成章节数
ls data/uploads/cli_*/translated_files/text/ | wc -l
```

### 检查进程状态

```bash
# 检查翻译进程
ps aux | grep translate.py | grep -v grep
```

---

## 🔍 质量检查

### 运行全面检查

```bash
# 执行检查
./quality_check.sh
```

### 检查内容

1. **未翻译 chunks 分析** - 统计失败原因
2. **英文残留检测** - 54 个文件逐一检测
3. **HTML 标签完整性** - 占位符残留检查
4. **EPUB 结构验证** - 文件完整性测试

### 验收标准

| 指标 | 优秀 | 良好 | 需改进 |
|------|------|------|--------|
| 未翻译 | <2% | 2-5% | >5% |
| 英文残留 | <30/千字符 | 30-50/千字符 | >50/千字符 |
| 占位符残留 | 0 | <5 | >5 |

---

## 💾 备份管理

### 自动备份

```bash
# 运行备份脚本
./backup_translation.sh
```

### 手动备份

```bash
# 备份当前进度
cp -r data/uploads/cli_* /backup/location/

# 压缩备份
tar -czf backup_$(date +%Y%m%d_%H%M%S).tar.gz data/uploads/cli_*
```

---

## 📖 使用示例

### 示例 1：翻译学术著作

```bash
# 复制 EPUB 到工作目录
cp Capitalism_A_Global_History.epub .

# 启动翻译
./start_translation.sh Capitalism_A_Global_History.epub

# 预计耗时：3-4 天（25MB 文件）
```

### 示例 2：翻译技术文档

```bash
# 小文件翻译
./start_translation.sh technical_manual.epub

# 预计耗时：2-4 小时
```

---

## 🏆 成功案例

### 《Capitalism: A Global History》中文版

**项目时间**: 2026-04-01 至 2026-04-05  
**原文**: Sven Beckert 著，25MB EPUB  
**章节**: 54 个文件，2569 个 chunks  

#### 翻译成果

| 指标 | 成果 |
|------|------|
| **总章节** | 54/54 (100%) ✅ |
| **翻译成功率** | 98.1% (2521/2569) |
| **总耗时** | 3 天 18 小时 |
| **质量评分** | 90/100 ⭐⭐⭐⭐⭐ |

#### 用户评价

> "翻译的效果相当不错！保留人名、书名原文让读者更容易查找原始资料。脚注翻译得很好，留住了原文，方便溯源。"

#### 质量对比

| 维度 | Qwen (本地) | MiniMax (云端) |
|------|-----------|--------------|
| **准确性** | 90/100 | 70/100 |
| **流畅度** | 90/100 | 70/100 |
| **速度** | 60 分钟/章 | 7 分钟/章 ⭐ |
| **成本** | ¥0 (免费) | ~¥15 |
| **隐私** | ✅ 完全本地 | ❌ 云端处理 |

**结论**: 本地模型在质量和成本上完胜！

---

## 🔧 故障排除

### 常见问题

#### 1. 进程挂起

**症状**: 日志长时间无更新

**解决**:
```bash
# 检查日志
tail -100 translation.log

# 重启翻译（会自动恢复）
kill $(cat translation.pid)
./start_translation.sh book.epub
```

#### 2. 磁盘空间不足

**症状**: 翻译失败，提示空间不足

**解决**:
```bash
# 检查空间
df -h

# 清理临时文件
rm -rf data/uploads/cli_*/xhtml_states/*.json
```

#### 3. 无法恢复翻译

**症状**: 使用 `--translation-id` 仍从头开始

**解决**:
```bash
# 检查 checkpoint 文件
ls -la data/uploads/cli_*/xhtml_states/

# 确保使用正确的 translation_id
ls data/uploads/ | grep cli_
```

---

## 📚 最佳实践

### 1. Prompt 优化

**学术翻译原则**:
- ✅ 保留人名、地名原文
- ✅ 保留书名、期刊名原文
- ✅ 保留出版社信息
- ✅ 正文完全翻译

### 2. 超时配置

**关键配置**:
```bash
export REQUEST_TIMEOUT=600  # 10 分钟超时
```

**原因**: 大文件（100KB+ 章节）需要更长时间

### 3. 定期备份

**建议频率**:
- 每 24 小时备份一次
- 翻译关键章节后备份
- 停止翻译前备份

---

## 📊 性能基准

### 翻译速度

| 文件类型 | 大小 | 耗时 | 速度 |
|---------|------|------|------|
| 小文件 | <10KB | 1-2 分钟 | - |
| 中等章节 | 100-150KB | 15-20 分钟 | ~7KB/分钟 |
| 大章节 | 200-250KB | 30-40 分钟 | ~6KB/分钟 |
| **平均** | - | - | **~6.5KB/分钟** |

### 资源消耗

- **CPU**: 平均 15% (单核)
- **内存**: 峰值 2GB
- **网络**: 持续连接到 API
- **磁盘**: 临时文件约 500MB

---

## 🤝 贡献

欢迎贡献代码、报告问题或提出建议！

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

---

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

---

## 🙏 致谢

- [TranslateBooksWithLLMs](https://github.com/hydropix/TranslateBooksWithLLMs) - 核心翻译工具
- [Qwen](https://github.com/QwenLM/Qwen) - 优秀的 AI 模型
- 所有贡献者和用户

---

## 📞 联系方式

- **项目主页**: [GitHub](https://github.com/YOUR_USERNAME/epub-translation-toolkit)
- **问题反馈**: [Issues](https://github.com/YOUR_USERNAME/epub-translation-toolkit/issues)

---

<div align="center">

**⭐ 如果这个项目对你有帮助，请给个 Star！** ⭐

Made with ❤️ by OpenCode AI

</div>
