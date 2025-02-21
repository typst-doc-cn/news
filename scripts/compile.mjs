// @ts-check

import fs from "fs";
import {
  NodeCompiler,
  ProjectWatcher,
} from "@myriaddreamin/typst-ts-node-compiler";
import { isDev, urlBase } from "./args.mjs";

/**
 * The flag for indicating whether there is any error during the build process
 */
export let hasError = false;

/**
 * The arguments for the compiler
 *
 * @type {import("@myriaddreamin/typst-ts-node-compiler").CompileArgs}
 */
const compileArgs = {
  workspace: ".",
  ...(urlBase
    ? { inputs: { "x-url-base": urlBase, "x-target": "web-light" } }
    : {}),
};

/**
 * The arguments for querying metadata
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
 * Lazily created compiler and watcher
 * @type {import("@myriaddreamin/typst-ts-node-compiler").NodeCompiler | undefined}
 */
let _compiler = undefined;
/**
 *
 * @returns {import("@myriaddreamin/typst-ts-node-compiler").NodeCompiler}
 */
export const compiler = () => (_compiler ||= NodeCompiler.create(compileArgs));
/**
 * @type {import("@myriaddreamin/typst-ts-node-compiler").ProjectWatcher | undefined}
 */
let _watcher = undefined;
/**
 *
 * @returns {import("@myriaddreamin/typst-ts-node-compiler").ProjectWatcher}
 */
export const watcher = () => (_watcher ||= ProjectWatcher.create(compileArgs));

export const compilerOrWatcher = () => _compiler || _watcher;

/**
 * @param {string} src
 * @param {string} dst
 */
export const compile = (src, dst) => {
  /**
   * @param {import("@myriaddreamin/typst-ts-node-compiler").NodeTypstProject} compiler
   */
  return (compiler) => {
    let alreadyHasError = false;

    /**
     *
     * @param {string} theme The theme to compile
     */
    const compileTheme = (theme) => {
      const htmlResult = compiler.mayHtml({
        mainFilePath: src,
        inputs: { "x-target": `web-${theme}` },
      });

      hasError = hasError || htmlResult.hasError();

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
      compilerOrWatcher()?.evictCache(30);
    }
  };
};

/**
 * @param {string} src
 * @param {string} dst
 */
export const typstRun = (src, dst) => {
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
 * @param {string} src
 * @param {string} selector
 * @param {boolean} one
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
 * @param {string} src
 * @param {string} selector
 * @param {boolean} one
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
