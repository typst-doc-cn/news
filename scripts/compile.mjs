// @ts-check

import fs from "fs";
import {
  NodeCompiler,
  ProjectWatcher,
} from "@myriaddreamin/typst-ts-node-compiler";
import { isDev, urlBase } from "./args.mjs";

/**
 * The flag for indicating whether there is any error during the build process.
 */
export let hasError = false;

/**
 * The arguments for the compiler.
 *
 * @type {import("@myriaddreamin/typst-ts-node-compiler").CompileArgs}
 */
const compileArgs = {
  workspace: ".",
  inputs: {
    "x-target": "web-light",
    ...(urlBase ? { "x-url-base": urlBase } : {}),
  },
  fontArgs: [{ fontPaths: ["./assets/fonts", "./assets/typst-fonts"] }],
};

/**
 * The arguments for querying metadata.
 *
 * @type {import("@myriaddreamin/typst-ts-node-compiler").CompileArgs}
 */
const queryArgs = {
  ...compileArgs,
  inputs: {
    "x-meta": "true",
    ...compileArgs.inputs,
  },
};

/**
 * Lazily created compiler.
 * @type {import("@myriaddreamin/typst-ts-node-compiler").NodeCompiler | undefined}
 */
let _compiler = undefined;
/**
 * Lazily created compiler.
 * @returns {import("@myriaddreamin/typst-ts-node-compiler").NodeCompiler}
 */
export const compiler = () => (_compiler ||= NodeCompiler.create(compileArgs));
/**
 * @type {import("@myriaddreamin/typst-ts-node-compiler").ProjectWatcher | undefined}
 */
let _watcher = undefined;
/**
 * Lazily created watcher
 * @returns {import("@myriaddreamin/typst-ts-node-compiler").ProjectWatcher}
 */
export const watcher = () => (_watcher ||= ProjectWatcher.create(compileArgs));

/**
 * Common getter for the compiler or watcher.
 */
export const compilerOrWatcher = () => _compiler || _watcher;

/**
 * Compiles the source file to the destination file.
 *
 * @param {string} src The source file path
 * @param {string} dst The destination file path
 *
 * @example
 * compile("src/index.typ", "dist/index.html")(compiler());
 */
export const compile = (src, dst) => {
  /**
   * @param {import("@myriaddreamin/typst-ts-node-compiler").NodeTypstProject} compiler
   */
  return (compiler) => {
    let alreadyHasError = false;

    /**
     * Theme-specific compilation
     *
     * @param {string} theme The theme to compile
     */
    const compileTheme = (theme) => {
      const htmlResult = compiler.mayHtml({
        mainFilePath: src,
        inputs: {
          ...compileArgs.inputs,
          "x-target": `web-${theme}`,
        },
      });

      hasError = hasError || htmlResult.hasError();

      // Only print the error once
      if (!alreadyHasError) {
        htmlResult.printErrors();
      }
      alreadyHasError = htmlResult.hasError();

      const htmlContent = htmlResult.result;
      if (htmlContent?.length !== undefined) {
        const themeDst =
          theme === "light" ? dst.replace(".html", `.${theme}.html`) : dst;
        fs.writeFileSync(themeDst, htmlContent);
      }
    };

    compileTheme("light");
    compileTheme("dark");

    if (alreadyHasError) {
      console.log(` \x1b[1;31mError\x1b[0m ${src}`);
    } else {
      console.log(` \x1b[1;32mCompiled\x1b[0m ${src}`);

      // Evicts the cache unused in last 30 runs
      compilerOrWatcher()?.evictCache(30);
    }
  };
};

/**
 * User trigger compiles the source file to the destination file or watches the source file.
 *
 * All the errors are caught and printed to the console.
 *
 * @param {string} src The source file path
 * @param {string} dst The destination file path
 *
 * @example
 * compileOrWatch("src/index.typ", "dist/index.html");
 */
export const compileOrWatch = (src, dst) => {
  try {
    if (isDev) {
      watcher().add([src], compile(src, dst));
    } else {
      compile(src, dst)(compiler());
    }
  } catch (e) {
    console.error(e);
    return;
  }
};

/**
 * Triggers query on the source file
 *
 * All the errors are caught and printed to the console.
 *
 * @param {string} src The source file path.
 * @param {string} selector The selector for the query.
 * @param {boolean} one Casts the result to a single element if the result is an array and the length is 1.
 *
 * @returns {any[] | any | undefined}
 *
 * @example
 * query("src/index.typ", "<rss-feed>", true)(compiler());
 */
export const query = (src, selector, one) => {
  /**
   * @param {import("@myriaddreamin/typst-ts-node-compiler").NodeTypstProject} compiler
   */
  return (compiler) => {
    try {
      /**
       * @type {any[]}
       */
      const queryData = compiler.query(
        { mainFilePath: src, ...queryArgs },
        { selector }
      );
      if (queryData?.length !== undefined) {
        if (one) {
          if (queryData.length !== 1) {
            throw new Error(
              `Query expected one result, but got ${queryData.length}`
            );
          }
          return queryData[0];
        }
        return queryData;
      }
    } catch (e) {
      hasError = true;
      throw e;
    }
  };
};

/**
 * User trigger queries the source file to the destination file or watches the source file
 *
 * @param {string} src The source file path.
 * @param {string} selector The selector for the query.
 * @param {boolean} one Casts the result to a single element if the result is an array and the length is 1.
 *
 * @returns {import("./types").FileMetaElem | undefined}
 */
export const typstQuery = (src, selector, one) => {
  try {
    return query(src, selector, one)(compiler());
  } catch (e) {
    console.log(`\x1b[1;31mError\x1b[0m ${src}`);
    console.error(e);
    return;
  }
};
