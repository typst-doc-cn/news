// typst watch --root . src/index.typ --features html dist/index.html

import child_process from "child_process";
import fs from "fs";
import { generateNewsList } from "./generate-news-list.mjs";
import watch from "glob-watcher";
import { dirname } from "path";

const previousProcesses = [];

const isDev = process.argv.includes("--dev");

const typstRun = (src, dst) =>
  child_process.spawn(
    "typst",
    [
      isDev ? "watch" : "compile",
      "--root",
      ".",
      src,
      "--diagnostic-format",
      "short",
      "--features",
      "html",
      dst,
    ],
    {
      stdio: "inherit",
    }
  );

const killPreviousProcesses = () => {
  for (const process of previousProcesses) {
    process.kill();
  }
  previousProcesses.splice(0, previousProcesses.length);
};

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
      previousProcesses.push(typstContentWatch(news.content.en));
    }
    if (news.content["zh-CN"]) {
      previousProcesses.push(typstContentWatch(news.content["zh-CN"]));
    }
  }

  const indexSrc = "src/index.typ";
  const indexDst = "dist/index.html";
  previousProcesses.push(typstRun(indexSrc, indexDst));
};

if (isDev) {
  const watcher = watch(["content/{en,zh-CN}/news/**/*.typ"]);
  watcher.on("add", build);
  watcher.on("remove", build);
} else {
  build();
  for (const process of previousProcesses) {
    process.on("exit", (code) => {
      if (code !== 0) {
        process.exit(code);
      }
    });
  }
}
