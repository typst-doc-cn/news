import fs from "fs";
import { siteUrl } from "./args.ts";
import { extract, FALLBACK_LANG, LANGS } from "./i18n.ts";
import { typstQuery } from "./compile.ts";
import type { I18n, FileMeta, NewsMeta } from "./types";

/**
 * todo: looks quite ugly, need to refactor
 *
 * @param siteUrl The base URL of the website
 */
export const generateNewsList = (siteUrl: string): NewsMeta[] => {
  const i18nFileMeta: Record<string, I18n<FileMeta & { content: string; }>> = {};

  const travel = (lang: string): void => {
    const newsDir = `content/${lang}/news`;
    const monthsList: string[] = fs.readdirSync(newsDir);
    const newsList = monthsList.reduce<string[]>((acc, month) => {
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
      const fileMeta = typstQuery(newsPath, "<front-matter>", true)!.value;
      if (lang === FALLBACK_LANG) {
        i18nFileMeta[id] = {
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

  const newsListJson: NewsMeta[] = [];

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
    return new Date(b.date).getTime() - new Date(a.date).getTime();
  });

  fs.writeFileSync(
    "content/meta/news-list.json",
    JSON.stringify(newsListJson, null, 2)
  );

  generateRssFeed(siteUrl, newsListJson, i18nFileMeta);
  return newsListJson;
};

/**
 * Generates the RSS feed
 *
 * @param siteUrl The base URL of the website
 * @param newsListJson The news list JSON
 * @param i18nFileMeta The i18n file meta
 */
const generateRssFeed = (
  siteUrl: string,
  newsListJson: NewsMeta[],
  i18nFileMeta: Record<string, I18n<FileMeta & { content: string; }>>
): void => {
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
        const meta = i18nFileMeta?.[news.id]?.en;
        return `
      <item>
        <title>${meta.title}</title>
        <link>${siteUrl}${dst}</link>
        <description>${meta.description}</description>
        <pubDate>${new Date(news.date).toUTCString()}</pubDate>
      </item>`;
      })
      .join("")}
  </channel>
</rss>`;
  fs.mkdirSync("dist/news", { recursive: true });
  fs.writeFileSync("dist/feed.xml", rssFeed);
};

const thisName = import.meta.url.split("/").pop()!;

if (process.argv[1].endsWith(thisName)) {
  generateNewsList(siteUrl);
}
