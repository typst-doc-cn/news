## 安装构建环境

本地预览 HTML 导出还处于实验阶段，因此只能通过脚本构建和预览 HTML 导出，需要 Node.js 环境。

```bash
pnpm install
```

## 构建（Build）

```bash
pnpm run build
```

此命令支持以下参数。

- `--base BASE`

  设置网站的 base URL，默认为`https://typst-doc-cn.github.io/news/`。
  
  `BASE`必须是完整URL，因为会用于生成RSS和二维码；而且必须以`/`结尾，以保证相对链接能正确转换。

- `--mirror default|cloudflare|vercel|netlify`

  选择将中文社区导航、教程、文档等站点的链接替换为哪个镜像，默认为`default`。

  使用方法参考[镜像链接 | Typst 中文社区导航](https://typst.dev/guide/dev/mirror-link.html#使用方法)，但不会影响`--base`，而且不支持保持某个链接始终为原始 URL；具体替换规则见[`mirror-link.typ`](./typ/packages/mirror-link.typ)。

## 持续构建（Watch）

```bash
pnpm run dev
```

运行以上命令，然后访问 http://localhost:3000/news/。

推荐使用 VS Code 编辑文件。在 Windows 上，如果使用 Neovim 或 Helix 编辑，有一定概率检测不到更改，可用 VS Code 编辑一下其它文件触发刷新。

## 创建新条目

在`content/news/YYYY-MM/`目录下创建一个新的`SHORT-NAME.en.typ`文件，包含以下内容：

```typ
#import "/typ/templates/news.typ": link-news, news-template

#show: news-template.with(
  date: "2025-02-06", // 日期
  title: "Typst 0.13.0, RC 1 released", // 标题
  lang: "en", // 语言
  tags: ("update",), // 标签
  description: "Typst 0.13.0, RC 1 was released.", // 描述
)

Use `link-news(dest, body)` to link to #link-news("/content/news/2025-06/gap.en.typ")[another page].
```

可以使用翻译软件在同目录添加翻译版本`SHORT-NAME.zh-CN.typ`，中文版应标注`lang: "zh", region: "CN"`。

## 内容预览

本地预览 HTML 导出还处于实验阶段，因此只能通过脚本构建和预览 HTML 导出。

## 开发说明

- 文件路径用`/`开头的字符串表示，`/`表示项目根目录。
- URL 用不以`/`开头的字符串表示，相对于 base。
