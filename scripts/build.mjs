import fs from "fs";
import { generateNewsList } from "./generate-news-list.mjs";
import watch from "glob-watcher";
import { dirname } from "path";
import { NodeCompiler } from "@myriaddreamin/typst-ts-node-compiler";

const isDev = process.argv.includes("--dev");

const compiler = NodeCompiler.create({
  workspace: ".",
});

// isDev ? "watch" : "compile",
// "--diagnostic-format",
// "short",

const typstRun = (src, dst) => {
  try {
    const htmlContent = compiler.html({
      mainFilePath: src,
    });

    fs.writeFileSync(dst, htmlContent);
  } catch (e) {
    console.error(e);
    return;
  }
};

const killPreviousProcesses = () => {};

const build = () => {
  killPreviousProcesses();
  const meta = generateNewsList();

  const typstContentWatch = (src) => {
    const dst = src.replace("content/", "dist/").replace(".typ", ".html");
    const dstDir = dirname(dst);
    fs.mkdirSync(dstDir, { recursive: true });
    return typstRun(src, dst);
  };

  for (const news of meta) {
    if (news.content.en) {
      typstContentWatch(news.content.en);
    }
    if (news.content["zh-CN"]) {
      typstContentWatch(news.content["zh-CN"]);
    }
  }

  const indexSrc = "src/index.typ";
  const indexDst = "dist/index.html";
  typstRun(indexSrc, indexDst);
};

if (isDev) {
  const watcher = watch(["content/{en,zh-CN}/news/**/*.typ"]);
  watcher.on("add", build);
  watcher.on("remove", build);
} else {
  build();
}
