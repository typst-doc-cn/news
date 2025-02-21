// @ts-check

(function () {
  // check system theme
  const systemTheme = window.matchMedia("(prefers-color-scheme: dark)").matches;

  // check local storage theme
  const localTheme = localStorage.getItem("typst-theme");

  // check if local storage theme is set
  if (localTheme) {
    // set theme
    document.documentElement.setAttribute("data-theme", localTheme);
  }

  let currentTheme = localTheme || (systemTheme ? "dark" : "light");

  /**
   *
   * @param {string} theme Theme to set
   * @param {boolean} save Save theme to local storage
   */
  const reloadTheme = (theme, save) => {
    if (save) {
      localStorage.setItem("typst-theme", theme);
    }
    currentTheme = theme;
  };
  const toggleTheme = () => {
    const nextTheme = currentTheme === "dark" ? "light" : "dark";
    const href = window.location.href;
    const hrefWithIndexHtml = !href.endsWith(".html")
      ? href.replace(/\/$/g, "") +
        (currentTheme === "dark" ? "/index.html" : "/index.light.html")
      : href;
    const newUrl = new URL(
      currentTheme === "dark"
        ? hrefWithIndexHtml.replace(".html", ".light.html")
        : hrefWithIndexHtml.replace(".light.html", ".html")
    );

    reloadTheme(nextTheme, true);

    window.location.href = newUrl.toString();
  };

  window.toggleTheme = toggleTheme;
})();
