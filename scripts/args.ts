/**
 * Parses a long argument from the command line.
 *
 * @param argName name of the argument without `--`
 */
export const parseArg = (argName: string): string | undefined =>
  [process.argv.find((arg) => arg.startsWith(`--${argName}=`))].map((arg) => {
    if (arg) {
      return arg.split("=")[1];
    }
    return undefined;
  })[0];

/**
 * Watches the project if the `--dev` flag is present
 */
export const isDev = process.argv.includes("--dev");

/**
 * The URL base for the project on the website.
 *
 * For example, if the website is hosted at `https://example.com/news/`, then the URL base is `/news/`.
 */
export const urlBase: string | undefined = parseArg("url-base");

/**
 * The site URL for the project.
 *
 * For example, if the website is hosted at `https://example.com/news/`, then the site URL is `https://example.com`.
 */
export const siteUrl: string = (
  parseArg("site-url") || "https://typst-doc-cn.github.io/news"
).replace(/\/$/, "");
