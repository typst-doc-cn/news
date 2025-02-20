// @ts-check

import watch from "glob-watcher";
import { hasError, isDev, reload } from "./common.mjs";


const main = () => {
  if (isDev) {
    const watcher = watch(["content/{en,zh-CN}/news/**/*.typ"]);
    watcher.on("add", reload);
    watcher.on("remove", reload);

    // The first reload.
    reload();
  } else {
    reload();
    if (hasError) {
      process.exit(1);
    }
  }
};

main();
