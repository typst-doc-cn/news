import fs from "fs";
import watch from "glob-watcher";
import { hasError, compileOrWatch, watcher } from "./compile.ts";
import { isDev, siteUrl } from "./args.ts";
import { generateNewsList } from "./generate.ts";
import { dirname } from "path";
import { FALLBACK_LANG, LANGS } from "./i18n.ts";

const main = (): void => (isDev ? mainWatch() : mainBuild());

/**
 * Watches the files and rebuilds the project
 */
const mainWatch = (): void => {
  // When these files change, we need to reload the documents.
  const watcher = watch([
    "content/{en,zh-CN}/news/**/*.typ",
    "content/meta/news-list.json",
    "src/**/*.typ",
  ]);
  watcher.on("add", reload);
  watcher.on("remove", reload);

  // The first reload.
  reload();
};

/**
 * Builds the project
 */
const mainBuild = (): void => {
  reload();
  if (hasError) {
    process.exit(1);
  }
};

/**
 * Reloads and builds the project
 */
export const reload = (): void => {
  // Kills the previous watches
  watcher().clear();
  // Gets all the news
  const meta = generateNewsList(siteUrl);

  /**
   * Watches a regular typst document.
   */
  const makeDoc = (src: string): void => {
    const dst = src.replace("content/", "dist/").replace(".typ", ".html");
    const dstDir = dirname(dst);
    fs.mkdirSync(dstDir, { recursive: true });
    compileOrWatch(src, dst);
  };

  /**
   * News documents.
   */
  for (const news of meta) {
    LANGS.forEach((lang) => {
      if (news.content[lang]) {
        makeDoc(news.content[lang]);
      }
    });
  }
  /**
   * Language-specific index documents.
   */
  LANGS.forEach((lang) => {
    const langIndexSrc = `content/${lang}/index.typ`;
    const fallbackIndexSrc = `content/${FALLBACK_LANG}/index.typ`;
    const indexSrc = fs.existsSync(langIndexSrc)
      ? langIndexSrc
      : fallbackIndexSrc;
    const indexDst = `dist/${lang}/index.html`;
    compileOrWatch(indexSrc, indexDst);
  });
  /**
   * The main index
   */
  {
    const indexSrc = "src/index.typ";
    const indexDst = "dist/index.html";
    compileOrWatch(indexSrc, indexDst);
  }
  /**
   * All the documents are put into the watch list. Let's watch them.
   */
  if (isDev) {
    watcher().watch();
  }
};

main();
