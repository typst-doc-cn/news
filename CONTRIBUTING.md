## 安装构建环境

本地预览 HTML 导出还处于实验阶段，因此只能通过脚本构建和预览 HTML 导出，需要 Node.js 环境。

```bash
npm install
```

## 构建（Build）

```bash
npm run build
```

## 持续构建（Watch）

```bash
npm run dev
npm run serve
```

## 创建新条目

在`content/en/news/date/`目录下创建一个新的 Typst 文件，包含以下内容：

```typ
#import "/typ/templates/news.typ": *

#show: news-template.with(
  date: "2025-02-06", // 日期
  title: "Typst 0.13.0, RC 1 released", // 标题
  lang: "en", // 语言
  tags: ("update",), // 标签
  description: "Typst 0.13.0, RC 1 was released.", // 描述
)
```

可以使用翻译软件在下`content/zh-CN/news/date/`为内容添加翻译版本。

## 内容预览

本地预览 HTML 导出还处于实验阶段，因此只能通过脚本构建和预览 HTML 导出。
