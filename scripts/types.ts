export type TFallbackLang = "en";

export type I18n<T> = {
  [key in TFallbackLang]: T;
} & {
  [lang: string]: T,
}

/**
 * Path to a content file.
 * 
 * The leading `/` stands for the project root.
 */
export type ContentPath = `/content/${string}`;

export interface NewsMeta {
  id: string;
  date: string;
  /**
   * Path to content
   */
  content: I18n<ContentPath>;
  description: I18n<string>;
  tags: I18n<string[]>;
  title: I18n<string>;
}

/**
 * Metadata for a single file (a specific language)
 */
export interface FileMeta {
  date: string;
  description: string;
  tags: string[];
  title: string;
  "redirect-from": ContentPath[];
}

export type FileMetaElem = {
  func: "meta";
  label: "<front-matter>";
  value: FileMeta;
};
