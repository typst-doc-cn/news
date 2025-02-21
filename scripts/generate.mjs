// @ts-check

import fs from "fs";
import { siteUrl } from "./args.mjs";
import { extract, FALLBACK_LANG, LANGS } from "./i18n.mjs";
import { typstQuery } from "./compile.mjs";

/**
 * @param {string} siteUrl The base URL of the website
 * @returns {import("./types.d.ts").NewsMeta[]}
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

/**
 *
 * @param {string} siteUrl
 * @param {any[]} newsListJson
 */
const generateRssFeed = (siteUrl, newsListJson) => {
  const rssFeed = `<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">
  <channel>
    <title>Typst CN News (unofficial)</title>
    <link>${siteUrl}/</link>
    <description>The recent changes about typst.</description>
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

const thisName = import.meta.url.split("/").pop();

// @ts-ignore
if (process.argv[1].endsWith(thisName)) {
  generateNewsList(siteUrl);
}
