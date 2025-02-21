// @ts-check

/**
 * Supported languages, currently used for generating index.html
 */
export const LANGS = ["en", "zh-CN"];
/** @type {import("./types").TFallbackLang} */
export const FALLBACK_LANG = "en";

/**
 * Here `K` is the type of `key`.
 *
 * @template T, K
 * @param {import("./types").I18n<T>} raw
 * @param {keyof T} key
 *
 * @returns {import("./types").I18n<T[K]>}
 */
export const extract = (raw, key) => {
  /**
   * @type {Record<string, any>}
   */
  const result = {
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
  // @ts-ignore
  return result;
};
