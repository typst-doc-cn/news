import type { I18n, TFallbackLang } from "./types";

/**
 * Supported languages, currently used for generating index.html
 */
export const LANGS: string[] = ["en", "zh-CN"];
export const FALLBACK_LANG: TFallbackLang = "en";

/**
 * Here `K` is the type of `key`.
 */
export function extract<T, K extends keyof T>(
  raw: I18n<T>,
  key: K
): I18n<T[K]> {
  const result: I18n<T[K]> = {
    [FALLBACK_LANG]: raw[FALLBACK_LANG][key],
  };
  for (const lang of LANGS) {
    if (!(lang in raw)) {
      continue;
    }
    if (lang === FALLBACK_LANG) {
      continue;
    }
    result[lang] = raw[lang][key];
  }
  return result;
}
