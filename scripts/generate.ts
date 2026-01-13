import { groupBy } from "es-toolkit/array";
import fs from "node:fs";
import { dirname } from "node:path";
import { siteUrl } from "./args.ts";
import { typstQuery } from "./compile.ts";
import { extract, FALLBACK_LANG, LANGS } from "./i18n.ts";
import { toDist } from "./route.ts";
import type { FileMeta, I18n, NewsMeta } from "./types";

const NEWS_PATH_PATTERN =
  /^(?<id>\d{4}-\d{2}\/.+)\.(?<lang>[a-z]{2}(?:-[A-Z]{2})?)\.typ$/;

/** A pair of redirect paths */
interface RedirectPair {
  from: string;
  to: string;
}

/**
 * todo: looks quite ugly, need to refactor
 *
 * @param siteUrl The base URL of the website
 */
export const generateNewsList = (siteUrl: string): NewsMeta[] => {
  const i18nFileMeta: Record<
    string,
    I18n<Omit<FileMeta, "redirect-from"> & { content: string }>
  > = {};
  const redirects: RedirectPair[] = [];

  const travel = (): void => {
    const newsDir = `content/news`;
    const monthsList: string[] = fs.readdirSync(newsDir);
    const newsList = monthsList.reduce<
      { path: string; lang: string; id: string }[]
    >((acc, month) => {
      const monthPath = `${newsDir}/${month}`;
      const news = fs
        .readdirSync(monthPath)
        .filter((news) => news.endsWith(".typ"))
        .map((news) => {
          const newsPath = `${month}/${news}`;

          const m = NEWS_PATH_PATTERN.exec(newsPath);
          if (!m || !m.groups) {
            throw new Error(`Failed to parse a news path: ${newsPath}`);
          }
          const { lang, id } = m.groups;
          return { path: `${newsDir}/${newsPath}`, lang, id };
        });
      return [...acc, ...news];
    }, []);

    const newsGroups = groupBy(newsList, ({ id }) => id);
    for (const [id, newsLangs] of Object.entries(newsGroups)) {
      const actualLangs = newsLangs.map(({ lang }) => lang);
      const missingLangs = LANGS.filter((lang) => !actualLangs.includes(lang));
      if (missingLangs.length > 0) {
        console.warn(
          `\x1b[1;93mWarning\x1b[0m News item ${id} will be ignored because some languages are missing: ${
            missingLangs.join(", ")
          }`,
        );
        continue;
      }

      for (const { path, lang } of newsLangs) {
        const { "redirect-from": redirectFrom, ...fileMeta } =
          typstQuery(path, "<front-matter>", true)!.value;
        if (!i18nFileMeta[id]) {
          // @ts-ignore: This type error will be fixed after the for-loop is finished.
          i18nFileMeta[id] = {};
        }
        i18nFileMeta[id][lang] = {
          content: path,
          ...fileMeta,
        };
        redirects.push(...redirectFrom.map((from) => ({ from, to: path })));
      }

      // Verify that dates are consistent across languages
      const dates = new Set(
        Object.values(i18nFileMeta[id]).map(({ date }) => date),
      );
      if (dates.size !== 1) {
        const info = Object.fromEntries(
          Object.entries(i18nFileMeta[id]).map((
            [lang, { date }],
          ) => [lang, date]),
        );
        console.warn(
          `\x1b[1;93mWarning\x1b[0m News item ${id} has inconsistent dates across languages, and ${FALLBACK_LANG}'s will take priority: ${
            JSON.stringify(info)
          }`,
        );
      }
    }
  };
  travel();

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
  generateRedirects(siteUrl, redirects);

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
  i18nFileMeta: Record<
    string,
    I18n<Pick<FileMeta, "title" | "description"> & { content: string }>
  >,
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
        const dst = toDist(en).replace("dist/", "/");
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

function generateRedirects(siteUrl: string, redirects: RedirectPair[]): void {
  for (const { from, to } of redirects) {
    const srcPath = toDist(from);
    const dstUrl = `${siteUrl}${toDist(to).replace("dist/", "/")}`;
    const redirectContent = `<!DOCTYPE html>
<html lang="en-US">
<head>
  <meta charset="utf-8">
  <title>Redirecting…</title>
  <link rel="canonical" href="${dstUrl}">
  <script>window.location.replace("${dstUrl}")</script>
  <meta http-equiv="refresh" content="0; url=${dstUrl}">
  <meta name="robots" content="noindex">
</head>
<body>
  <h1>Redirecting…</h1>
  <a href="${dstUrl}">Click here if you are not redirected.</a>
</body>
</html>`;
    fs.mkdirSync(dirname(srcPath), { recursive: true });
    fs.writeFileSync(srcPath, redirectContent);
  }
}

const thisName = import.meta.url.split("/").pop()!;

if (process.argv[1].endsWith(thisName)) {
  generateNewsList(siteUrl);
}
