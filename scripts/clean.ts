import fs from "fs";

export const clean = (): void => {
  cleanDist();
  cleanMeta();
  console.log(" \x1b[1;32mCleaned\x1b[0m dist and meta");
};

const cleanDist = (): void => {
  const distDir = "dist";
  if (fs.existsSync(distDir)) {
    fs.rmSync(distDir, { recursive: true });
  }
};

const cleanMeta = (): void => {
  const metaFile = "content/meta/news-list.json";
  if (fs.existsSync(metaFile)) {
    fs.unlinkSync(metaFile);
  }
};

clean();
