// content/en

import fs from "fs";
import { siteUrl } from "./argParser.mjs";
import { generateNewsList } from "./common.mjs";

if (process.argv[1].endsWith(import.meta.url.split("/").pop())) {
  generateNewsList(siteUrl());
}
