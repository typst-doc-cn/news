// @ts-check

import fs from "fs";

import {
  NodeCompiler,
  ProjectWatcher,
} from "@myriaddreamin/typst-ts-node-compiler";
import { urlBase } from "./args.mjs";


/**
 * The arguments for compiling to final documents
 *
 * @type {import("@myriaddreamin/typst-ts-node-compiler").CompileArgs}
 */
const compileArgs = {
  workspace: ".",
  inputs: { ...(urlBase ? { "x-url-base": urlBase } : {}) },
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
  }
};


let _compiler = undefined;
let _watcher = undefined;
/**
 * Lazily loaded compiler
 * 
 * @returns {import("@myriaddreamin/typst-ts-node-compiler").NodeCompiler}
 */
export const compiler = () => (_compiler ||= NodeCompiler.create(compileArgs));
/**
 * Lazily loaded watcher
 * 
 * @returns {import("@myriaddreamin/typst-ts-node-compiler").ProjectWatcher}
 */
export const watcher = () => (_watcher ||= ProjectWatcher.create(compileArgs));

/**
 * Only one of compiler and watcher will be created in a single run
 * @returns {import("@myriaddreamin/typst-ts-node-compiler").NodeCompiler | import("@myriaddreamin/typst-ts-node-compiler").ProjectWatcher}
 */
const compilerOrWatcher = () => _compiler || _watcher;

/**
 * The flag for indicating whether there is any error during the build process
 */
export let hasError = false;


/**
 * @param {string} src
 * @param {string} dst
 */
export const compile = (src, dst) => {
  /**
   * @param {import("@myriaddreamin/typst-ts-node-compiler").NodeTypstProject} compiler
   */
  return (compiler) => {
    const htmlResult = compiler.mayHtml({ mainFilePath: src });

    hasError = hasError || htmlResult.hasError();
    htmlResult.printErrors();
    const htmlContent = htmlResult.result;
    if (htmlContent?.length !== undefined) {
      fs.writeFileSync(dst, htmlContent);
      console.log(` \x1b[1;32mCompiled\x1b[0m ${src}`);
      compilerOrWatcher()?.evictCache(30);
    }
  };
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
      const queryData = compiler.query({ mainFilePath: src, ...queryArgs }, { selector });
      if (queryData?.length !== undefined) {
        if (one) {
          if (queryData.length !== 1) {
            throw new Error(`Query expected one result, but got ${queryData.length}`);
          }
          return queryData[0];
        }
        return queryData;
      }
    }
    catch (e) {
      hasError = true;
      throw e;
    }
  };
};
