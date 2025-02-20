// @ts-check

import fs from "fs";
import watch from "glob-watcher";
import { hasError, typstRun, watcher } from "./compile.mjs";
import { isDev, siteUrl } from "./args.mjs";
import { generateNewsList } from "./generate.mjs";
import { dirname } from "path";
import { FALLBACK_LANG, LANGS } from "./i18n.mjs";

const main = () => {
  if (isDev) {
    const watcher = watch([
      "content/{en,zh-CN}/news/**/*.typ",
      "content/meta/news-list.json",
      "src/**/*.typ",
    ]);
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
export const reload = () => {
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

  LANGS.forEach((lang) => {
    const indexSrc = `content/${lang}/index.typ`;
    const fallbackIndexSrc = `content/${FALLBACK_LANG}/index.typ`;
    const indexDst = `dist/${lang}/index.html`;
    typstRun(fs.existsSync(indexSrc) ? indexSrc : fallbackIndexSrc, indexDst);
  });

  const indexSrc = "src/index.typ";
  const indexDst = "dist/index.html";
  typstRun(indexSrc, indexDst);

  if (isDev) {
    watcher().watch();
  }
};

/**
 * Kills the previous tasks
 */
let killPreviousTasks = () => {
  watcher().clear();
};

main();
