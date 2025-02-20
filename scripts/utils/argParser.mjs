// x-url-base
export const parseArg = (argName) =>
  [process.argv.find((arg) => arg.startsWith(`--${argName}=`))].map((arg) => {
    if (arg) {
      return arg.split("=")[1];
    }
    return undefined;
  })[0];

/**
 * Watches the project if the `--dev` flag is present
 */
export const isDev = () => process.argv.includes("--dev");
export const siteUrl = () =>
  (parseArg("site-url") || "https://typst-doc-cn.github.io/news").replace(
    /\/$/,
    ""
  );
// x-url-base
export const urlBase = () => parseArg("url-base");
