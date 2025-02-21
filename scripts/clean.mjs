// @ts-check

import fs from 'fs';

export const clean = () => {
    cleanDist();
    cleanMeta();
    console.log(" \x1b[1;32mCleaned\x1b[0m dist and meta");
};

const cleanDist = () => {
    const distDir = "dist";
    if (fs.existsSync(distDir)) {
        fs.rmSync(distDir, { recursive: true });
    }
};

const cleanMeta = () => {
    const metaFile = "content/meta/news-list.json";
    if (fs.existsSync(metaFile)) {
        fs.unlinkSync(metaFile);
    }
};

clean();
