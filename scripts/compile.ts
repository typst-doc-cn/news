import {
  NodeCompiler,
  ProjectWatcher,
  type CompileArgs,
  type NodeTypstProject,
} from "@myriaddreamin/typst-ts-node-compiler";
import fs from "node:fs";
import { isDev, mirrorProfile, siteUrlBase } from "./args.ts";
import type { FileMetaElem } from "./types.ts";

/**
 * The flag for indicating whether there is any error during the build process.
 */
export let hasError: boolean = false;

/**
 * The arguments for the compiler.
 */
const compileArgs: CompileArgs = {
  workspace: ".",
  inputs: {
    "x-target": "web-light",
    "x-site-url-base": siteUrlBase,
    "x-profile": mirrorProfile,
  },
  fontArgs: [{ fontPaths: ["./assets/fonts", "./assets/typst-fonts"] }],
};

/**
 * The arguments for querying metadata.
 */
const queryArgs: CompileArgs = {
  ...compileArgs,
  inputs: {
    "x-meta": "true",
    ...compileArgs.inputs,
  },
};

/**
 * Lazily created compiler.
 */
let _compiler: NodeCompiler | undefined = undefined;
/**
 * Lazily created compiler.
 */
export const compiler = (): NodeCompiler =>
  (_compiler ||= NodeCompiler.create(compileArgs));

let _watcher: ProjectWatcher | undefined = undefined;
/**
 * Lazily created watcher
 */
export const watcher = (): ProjectWatcher =>
  (_watcher ||= ProjectWatcher.create(compileArgs));

/**
 * Common getter for the compiler or watcher.
 */
export const compilerOrWatcher = (): NodeCompiler | ProjectWatcher | undefined =>
  _compiler || _watcher;

/**
 * Compiles the source file to the destination file.
 *
 * @param src The source file path
 * @param dst The destination file path
 *
 * @example
 * compile("src/index.typ", "dist/index.html")(compiler());
 */
export const compile = (src: string, dst: string) => {
  return (compiler: NodeTypstProject): void => {
    let alreadyHasError = false;

    /**
     * Theme-specific compilation
     *
     * @param theme The theme to compile
     */
    const compileTheme = (theme: string): void => {
      const htmlResult = compiler.tryHtml({
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

      const htmlContent = htmlResult.result?.html();
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
 * @param src The source file path
 * @param dst The destination file path
 *
 * @example
 * compileOrWatch("src/index.typ", "dist/index.html");
 */
export const compileOrWatch = (src: string, dst: string): void => {
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
 * @param src The source file path.
 * @param selector The selector for the query.
 * @param one Casts the result to a single element if the result is an array and the length is 1.
 *
 * @example
 * query("src/index.typ", "<rss-feed>", true)(compiler());
 */
export const query = (src: string, selector: string, one: boolean): any[] | any | undefined => {
  return (compiler: NodeTypstProject): unknown[] | unknown | undefined => {
    try {
      // Calling `compiler.query` directly only supports the paged target, not html.
      // Therefore, we have to call `compiler.compileHtml` first.
      // https://github.com/Myriad-Dreamin/typst.ts/issues/647#issuecomment-2693595551
      const result = compiler.compileHtml(
        { mainFilePath: src, ...queryArgs }
      );
      if (result.hasError() || result.result === null) {
        result.printErrors();
        throw new Error(`Failed to compile ${src} for query.`);
      }
      const queryData: any[] = compiler.query(
        result.result,
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
 * @param src The source file path.
 * @param selector The selector for the query.
 * @param one Casts the result to a single element if the result is an array and the length is 1.
 */
export const typstQuery = (
  src: string,
  selector: string,
  one: boolean
): FileMetaElem | undefined => {
  try {
    return query(src, selector, one)(compiler());
  } catch (e) {
    console.log(`\x1b[1;31mError\x1b[0m ${src}`);
    console.error(e);
    return;
  }
};
