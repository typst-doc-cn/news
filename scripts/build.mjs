// @ts-check

import fs from "fs";
import { generateNewsList } from "./generate-news-list.mjs";
import watch from "glob-watcher";
import { dirname } from "path";
import {
  NodeCompiler,
  ProjectWatcher,
} from "@myriaddreamin/typst-ts-node-compiler";
import {
  isDev as isDevIt,
  urlBase as urlBaseIt,
  siteUrl as siteUrlIt,
} from "./argParser.mjs";

const isDev = isDevIt();
const urlBase = urlBaseIt();
const siteUrl = siteUrlIt();

/**
 * The arguments for the compiler
 *
 * @type {import("@myriaddreamin/typst-ts-node-compiler").CompileArgs}
 */
const compileArgs = {
  workspace: ".",
  ...(urlBase ? { inputs: { "x-url-base": urlBase } } : {}),
};

/**
 * The flag for indicating whether there is any error during the build process
 */
let hasError = false;

const main = () => {
  if (isDev) {
    const watcher = watch(["content/{en,zh-CN}/news/**/*.typ"]);
    watcher.on("add", reload);
    watcher.on("remove", reload);

    // The first reload.
    reload();
  } else {
    reload();
    if (hasError) {
      process.exit(1);
    }
  }
};

/**
 * Reloads and builds the project
 */
const reload = () => {
  killPreviousTasks();
  const meta = generateNewsList(siteUrl);

  /**
   * @param {string} src
   */
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

/**
 * Lazily created compiler and watcher
 */
let _compiler = undefined;
/**
 *
 * @returns {import("@myriaddreamin/typst-ts-node-compiler").NodeCompiler}
 */
const compiler = () => (_compiler ||= NodeCompiler.create(compileArgs));
let _watcher = undefined;
/**
 *
 * @returns {import("@myriaddreamin/typst-ts-node-compiler").ProjectWatcher}
 */
const watcher = () => (_watcher ||= ProjectWatcher.create(compileArgs));

const compilerOrWatcher = () => _compiler || _watcher;

/**
 * Kills the previous tasks
 */
let killPreviousTasks = () => {
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
      compilerOrWatcher()?.evictCache(30);
    }
  };
};

/**
 * @param {string} src
 * @param {string} dst
 */
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

main();
