// @ts-check

import fs from "fs";
import { generateNewsList } from "./generate-news-list.mjs";
import watch from "glob-watcher";
import { dirname } from "path";
import {
  NodeCompiler,
  ProjectWatcher,
} from "@myriaddreamin/typst-ts-node-compiler";

const isDev = process.argv.includes("--dev");

let hasError = false;

let _compiler = undefined;
/**
 *
 * @returns {import("@myriaddreamin/typst-ts-node-compiler").NodeCompiler}
 */
const compiler = () =>
  (_compiler ||= NodeCompiler.create({
    workspace: ".",
  }));
let _watcher = undefined;
/**
 *
 * @returns {import("@myriaddreamin/typst-ts-node-compiler").ProjectWatcher}
 */
const watcher = () =>
  (_watcher ||= ProjectWatcher.create({
    workspace: ".",
  }));

let killPreviousProcesses = () => {
  watcher().clear();
};

/**
 * @param {string} src
 * @param {string} dst
 */
const compile = (src, dst) => {
  /**
   * @param {import("@myriaddreamin/typst-ts-node-compiler").NodeTypstProject} compiler
   */
  return (compiler) => {
    const htmlResult = compiler.mayHtml({ mainFilePath: src });

    hasError = hasError || htmlResult.hasError();
    htmlResult.printErrors();
    const htmlContent = htmlResult.result;
    if (htmlContent?.length !== undefined) {
      fs.writeFileSync(dst, htmlContent);
      console.log(` \x1b[1;32mCompiled\x1b[0m ${src}`);
      watcher().evictCache(30);
    }
  };
};

const typstRun = (src, dst) => {
  try {
    if (isDev) {
      watcher().add([src], compile(src, dst));
    } else {
      compile(src, dst)(compiler());
    }
  } catch (e) {
    console.error(e);
    return;
  }
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
      typstContentWatch(news.content.en);
    }
    if (news.content["zh-CN"]) {
      typstContentWatch(news.content["zh-CN"]);
    }
  }

  const indexSrc = "src/index.typ";
  const indexDst = "dist/index.html";
  typstRun(indexSrc, indexDst);

  if (isDev) {
    watcher().watch();
  }
};

if (isDev) {
  const watcher = watch(["content/{en,zh-CN}/news/**/*.typ"]);
  watcher.on("add", build);
  watcher.on("remove", build);

  build();
} else {
  build();
  if (hasError) {
    process.exit(1);
  }
}
