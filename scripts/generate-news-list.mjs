// content/en

import fs from "fs";
import { siteUrl } from "./argParser.mjs";

/**
 * @param {string} siteUrl The base URL of the website
 * @returns
 */
export const generateNewsList = (siteUrl) => {
  const newsDir = "content/en/news";

  const monthsList = fs.readdirSync(newsDir);
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

    const title = newsContent.match(/title: "(.*?)"/)[1];
    const date = newsContent.match(/date: "(.*?)"/)[1];
    const description = newsContent.match(/description: "(.*?)"/)[1];

    newsListJson.push({
      id,
      title,
      date,
      description,
      content: {
        en: newsPath,
        [`zh-CN`]: newsPath.replace("content/en", "content/zh-CN"),
      },
    });
  }

  // latest first
  newsListJson.sort((a, b) => {
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

if (process.argv[1].endsWith(import.meta.url.split("/").pop())) {
  generateNewsList(siteUrl());
}
