// @ts-check

import fs from "fs";
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

export const isDev = isDevIt();
export const urlBase = urlBaseIt();
export const siteUrl = siteUrlIt();

/**
 * Supported languages, currently used for generating index.html
 */
export const LANGS = ["en", "zh-CN"];
export const FALLBACK_LANG = "en";

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
  ...(urlBase ? { inputs: { "x-url-base": urlBase } } : {}),
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
    typstRun(
      fs.existsSync(indexSrc) ? indexSrc : fallbackIndexSrc,
      indexDst
    );
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
    const queryData = compiler.query({ mainFilePath: src, inputs: { meta: "1" } }, { selector });
    if (queryData?.length !== undefined) {
      if (one) {
        return queryData[0];
      }
      return queryData;
    }
  };
};

/**
 * @param {string} src 
 * @param {string} selector 
 * @param {boolean} one
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
  const newsDir = "content/en/news";

  const monthsList = fs.readdirSync(newsDir);
  // @ts-ignore
  const newsList = monthsList.reduce((acc, month) => {
    const monthPath = `${newsDir}/${month}`;
    const news = fs
      .readdirSync(monthPath)
      .filter((news) => news.endsWith(".typ"))
      .map((news) => `${month}/${news}`);
    return [...acc, ...news];
  }, []);

  const newsListJson = [];
  for (const newsId of newsList) {
    const id = newsId.replace(".typ", "");
    const newsPath = `${newsDir}/${newsId}`;

    const newsContent = fs.readFileSync(newsPath, "utf-8");

    const { title, date, tags, description } = typstQuery(newsPath, "<front-matter>", true)?.value;

    newsListJson.push({
      id,
      title,
      date,
      description,
      tags,
      content: {
        en: newsPath,
        [`zh-CN`]: newsPath.replace("content/en", "content/zh-CN"),
      },
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

