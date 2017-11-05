function i18n(idx,   locale) {
  if ("locale" in config) {
    #printf("i18n(): locale configured (%s)\n", config["locale"])
    if (match(config["locale"], /(.*)_(.*)\.(.*)/, locale)) {
      #printf("i18n(): lang = %s\n", locale[1])
    } else split("en US UTF-8", locale, " ")
  } else split("en US UTF-8", locale, " ")

  if (locale[1] in l10n[idx]) return(l10n[idx][locale[1]])
  else return(l10n[idx]["en"])
}
