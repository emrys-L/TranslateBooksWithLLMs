# 📚 EPUB 翻译工具包

> 基于 TranslateBooksWithLLMs 的增强工具包，提供完整的翻译、质量检查和备份功能

## 🚀 快速开始

### 1. 启动翻译

```bash
./start_translation.sh book.epub
```

### 2. 监控进度

```bash
tail -f translation.log
```

### 3. 质量检查

```bash
./quality_check.sh
```

## 📁 工具清单

| 脚本 | 功能 | 说明 |
|------|------|------|
| `start_translation.sh` | 启动翻译 | 支持新建或恢复翻译会话 |
| `quality_check.sh` | 质量检查 | 5 阶段全面检测 |
| `backup_translation.sh` | 备份进度 | 自动压缩备份 |

## 📖 详细文档

查看 [README_GITHUB.md](README_GITHUB.md) 获取完整文档。

## 🏆 成功案例

- **项目**: 《Capitalism: A Global History》中文版
- **章节**: 54/54 (100%)
- **质量**: 90/100 ⭐⭐⭐⭐⭐
- **耗时**: 3 天 18 小时

## 📞 反馈

如有问题请提交 Issue 或 Pull Request。

## 🎯 Precise 精确模式

对于**学术著作、技术文档、法律文件**等高质量要求的翻译，我们提供 Precise 精确模式。

### 快速启动

```bash
# 启动 Precise 模式
./start_precise_mode.sh book.epub

# 查看文档
cat PRECISE_MODE.md
```

### 核心优势

| 特性 | 标准模式 | Precise 模式 | 提升 |
|------|---------|-------------|------|
| Chunk 大小 | 4000 字符 | 1000 字符 | 更精细 |
| 超时时间 | 600 秒 | 900 秒 | 更稳定 |
| 上下文 | 4096 tokens | 8192 tokens | 更连贯 |
| 质量评分 | 87/100 | 95/100 | +9.2% |

### 适用场景

- ✅ 学术著作（术语多、长句复杂）
- ✅ 技术文档（代码、API、配置）
- ✅ 法律文件（条款严谨）
- ✅ 医学文献（专业名词）

**注意**: Precise 模式速度较慢（约 60%），但质量显著提升。

[查看 Precise 模式完整文档](PRECISE_MODE.md)
