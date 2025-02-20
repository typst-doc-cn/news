// content/en

import { siteUrl } from "./utils/args.mjs";
import { generateNewsList } from "./common.mjs";

if (process.argv[1].endsWith(import.meta.url.split("/").pop())) {
  generateNewsList(siteUrl);
}
