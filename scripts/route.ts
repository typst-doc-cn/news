import assert from "node:assert";

/**
 * Convert a news path in `content/…/*.typ` to the corresponding path in `dist/…/*.html`.
 */
export function toDist(srcPath: string): string {
  return srcPath.replace(
    /^content\/(?<path>.+)\.(?<lang>[a-z]{2}(?:-[A-Z]{2})?)\.typ$/,
    (_match, path, lang) => `dist/${lang}/${path}.html`,
  );
}

assert.equal(
  toDist("content/index.en.typ"),
  "dist/en/index.html",
);
assert.equal(
  toDist("content/index.zh-CN.typ"),
  "dist/zh-CN/index.html",
);
assert.equal(
  toDist("content/news/2025-06/gap.en.typ"),
  "dist/en/news/2025-06/gap.html",
);
assert.equal(
  toDist("content/news/2025-06/gap.zh-CN.typ"),
  "dist/zh-CN/news/2025-06/gap.html",
);
