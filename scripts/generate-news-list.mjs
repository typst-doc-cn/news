// content/en

import fs from "fs";

export const generateNewsList = () => {
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
    newsListJson.push({
      id,
      content: {
        en: newsPath,
        [`zh-CN`]: newsPath.replace("content/en", "content/zh-CN"),
      },
    });
  }

  fs.writeFileSync(
    "content/meta/news-list.json",
    JSON.stringify(newsListJson, null, 2)
  );
  return newsListJson;
};

if (process.argv[1].endsWith(import.meta.url.split("/").pop())) {
  generateNewsList();
}
