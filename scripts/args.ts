import assert from "node:assert";
import { argv } from "node:process";
import { parseArgs } from "node:util";

const { values: args } = parseArgs({
  args: argv.slice(2),
  strict: true,
  options: { dev: { type: "boolean" }, base: { type: "string" }, mirror: { type: "string" } },
});

/**
 * Watches the project if the `--dev` flag is present
 */
export const isDev = args.dev === true;

/** The profile for mirror-link. */
export const mirrorProfile = (args.mirror || "default") as 'default' | 'netlify' | 'cloudflare' | 'vercel';

export type SiteUrlBase = `https://${string}/` | `http://${string}/`;

function expectValidUrlBase(base: string): SiteUrlBase {
  assert(
    (base.startsWith("https://") || base.startsWith("http://")) &&
    base.endsWith("/"),
    "Site URL base must be an absolute http(s) URL ending with `/`",
  );
  return base as SiteUrlBase;
}

/**
 * The URL base for the project website.
 *
 * - The base path is used for relative links to assets and pages in the project.
 * - The full base (origin + base path) is used for absolute URLs in RSS and QR codes.
 */
export const siteUrlBase: SiteUrlBase = expectValidUrlBase(
  args.base || "https://typst-doc-cn.github.io/news/",
);
