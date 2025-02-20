// @ts-check

import fs from "fs";
import { dirname } from "path";
import {
  NodeCompiler,
  ProjectWatcher,
} from "@myriaddreamin/typst-ts-node-compiler";
import { isDev, urlBase, siteUrl } from "./args.mjs";
import { extract, FALLBACK_LANG, LANGS } from "./i18n.mjs";

/**
 * The flag for indicating whether there is any error during the build process
 */
export let hasError = false;

/**
 * The arguments for the compiler
 *
 * @type {import("@myriaddreamin/typst-ts-node-compiler").CompileArgs}
 */
const compileArgs = {
  workspace: ".",
  ...(urlBase
    ? { inputs: { "x-url-base": urlBase, "x-target": "web-light" } }
    : {}),
};

/**
 * The arguments for querying metadata
 *
 * @type {import("@myriaddreamin/typst-ts-node-compiler").CompileArgs}
 */
const queryArgs = {
  ...compileArgs,
  inputs: {
    "x-meta": "true",
    ...compileArgs.inputs,
  },
};

/**
 * Lazily created compiler and watcher
 */
let _compiler = undefined;
/**
 *
 * @returns {import("@myriaddreamin/typst-ts-node-compiler").NodeCompiler}
 */
export const compiler = () => (_compiler ||= NodeCompiler.create(compileArgs));
let _watcher = undefined;
/**
 *
 * @returns {import("@myriaddreamin/typst-ts-node-compiler").ProjectWatcher}
 */
export const watcher = () => (_watcher ||= ProjectWatcher.create(compileArgs));

export const compilerOrWatcher = () => _compiler || _watcher;

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

/**
 * @param {string} src
 * @param {string} dst
 */
export const compile = (src, dst) => {
  /**
   * @param {import("@myriaddreamin/typst-ts-node-compiler").NodeTypstProject} compiler
   */
  return (compiler) => {
    let alreadyHasError = false;

    /**
     *
     * @param {string} theme The theme to compile
     */
    const compileTheme = (theme) => {
      const htmlResult = compiler.mayHtml({
        mainFilePath: src,
        inputs: { "x-target": `web-${theme}` },
      });

      hasError = hasError || htmlResult.hasError();

      if (!alreadyHasError) {
        htmlResult.printErrors();
      }
      alreadyHasError = htmlResult.hasError();

      const htmlContent = htmlResult.result;
      if (htmlContent?.length !== undefined) {
        const themeDst =
          theme === "light" ? dst.replace(".html", `.${theme}.html`) : dst;
        fs.writeFileSync(themeDst, htmlContent);
      }
    };

    compileTheme("light");
    compileTheme("dark");

    if (alreadyHasError) {
      console.log(` \x1b[1;31mError\x1b[0m ${src}`);
    } else {
      console.log(` \x1b[1;32mCompiled\x1b[0m ${src}`);
      compilerOrWatcher()?.evictCache(30);
    }
  };
};

/**
 * @param {string} src
 * @param {string} dst
 */
export const typstRun = (src, dst) => {
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

/**
 * @param {string} src
 * @param {string} selector
 * @param {boolean} one
 */
export const query = (src, selector, one) => {
  /**
   * @param {import("@myriaddreamin/typst-ts-node-compiler").NodeTypstProject} compiler
   */
  return (compiler) => {
    try {
      /**
       * @type {any[]}
       */
      const queryData = compiler.query(
        { mainFilePath: src, ...queryArgs },
        { selector }
      );
      if (queryData?.length !== undefined) {
        if (one) {
          if (queryData.length !== 1) {
            throw new Error(
              `Query expected one result, but got ${queryData.length}`
            );
          }
          return queryData[0];
        }
        return queryData;
      }
    } catch (e) {
      hasError = true;
      throw e;
    }
  };
};

/**
 * @param {string} src
 * @param {string} selector
 * @param {boolean} one
 *
 * @returns {import("./types.d.ts").FileMetaElem | undefined}
 */
const typstQuery = (src, selector, one) => {
  try {
    return query(src, selector, one)(compiler());
  } catch (e) {
    console.log(`\x1b[1;31mError\x1b[0m ${src}`);
    console.error(e);
    return;
  }
};

/**
 * @param {string} siteUrl The base URL of the website
 * @returns
 */
export const generateNewsList = (siteUrl) => {
  /** @type {Record<string, import("./types.d.ts").I18n<import("./types.d.ts").FileMeta & {content: string}>>} */
  const i18nFileMeta = {};

  /** @param {string} lang */
  const travel = (lang) => {
    const newsDir = `content/${lang}/news`;
    const monthsList = fs.readdirSync(newsDir);
    /** @type {string[]} */
    // @ts-ignore
    const newsList = monthsList.reduce((acc, month) => {
      const monthPath = `${newsDir}/${month}`;
      const news = fs
        .readdirSync(monthPath)
        .filter((news) => news.endsWith(".typ"))
        .map((news) => `${month}/${news}`);
      return [...acc, ...news];
    }, []);

    for (const newsId of newsList) {
      const id = newsId.replace(".typ", "");
      const newsPath = `${newsDir}/${newsId}`;
      const fileMeta = typstQuery(newsPath, "<front-matter>", true)?.value;
      if (lang === FALLBACK_LANG) {
        i18nFileMeta[id] = {
          // @ts-ignore
          [lang]: {
            content: newsPath,
            ...fileMeta,
          },
        };
      } else {
        if (!i18nFileMeta[id]) {
          throw new Error(`News ${id} not found in fallback language`);
        }
        if (fileMeta) {
          i18nFileMeta[id][lang] = {
            content: newsPath,
            ...fileMeta,
          };
        }
      }
    }
  };

  travel(FALLBACK_LANG);
  LANGS.forEach((lang) => {
    if (lang !== FALLBACK_LANG) {
      travel(lang);
    }
  });

  /** @type {import("./types.d.ts").NewsMeta[]} */
  const newsListJson = [];

  for (const [id, meta] of Object.entries(i18nFileMeta)) {
    newsListJson.push({
      id,
      date: meta[FALLBACK_LANG].date,
      content: extract(meta, "content"),
      description: extract(meta, "description"),
      tags: extract(meta, "tags"),
      title: extract(meta, "title"),
    });
  }
  // latest first
  newsListJson.sort((a, b) => {
    // @ts-ignore
    return new Date(b.date) - new Date(a.date);
  });

  fs.writeFileSync(
    "content/meta/news-list.json",
    JSON.stringify(newsListJson, null, 2)
  );

  generateRssFeed(siteUrl, newsListJson);
  return newsListJson;
};

const generateRssFeed = (siteUrl, newsListJson) => {
  const rssFeed = `<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
  <channel>
    <title>Typ Blog</title>
    <link>${siteUrl}/</link>
    <description>Typ Blog</description>
    ${newsListJson
      .map((news) => {
        const en = news.content.en;
        const dst = en.replace("content/", "/").replace(".typ", ".html");
        return `
      <item>
        <title>${news.title}</title>
        <link>${siteUrl}${dst}</link>
        <description>${news.description}</description>
        <pubDate>${new Date(news.date).toUTCString()}</pubDate>
      </item>`;
      })
      .join("")}
  </channel>
</rss>`;
  fs.mkdirSync("dist/news", { recursive: true });
  fs.writeFileSync("dist/feed.xml", rssFeed);
};
