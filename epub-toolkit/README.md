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
