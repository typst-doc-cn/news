import {
    isDev as isDevIt,
    urlBase as urlBaseIt,
    siteUrl as siteUrlIt,
} from "./argParser.mjs";

export const isDev = isDevIt();
export const urlBase = urlBaseIt();
export const siteUrl = siteUrlIt();