#!/usr/bin/gawk -f
@include "dyn/dynconfig.awk"
@include "dyn/dynarray.awk"
@include "dyn/i18n.awk"

BEGIN {
  l10n["bert,datfile"]["en"] = "bert_en.dat"
  l10n["bert,datfile"]["nl"] = "bert_nl.dat"
  l10n["bert,response1"]["en"] = "Isn't $m quite difficult, Bert?\n"
  l10n["bert,response1"]["nl"] = "Is $m niet heel moeilijk dan, Bert?\n"
  
  srand()
}

## do Bert
{
  ## load data if neccesary
  if (!bert["1,0"])
    dynLoadArray(i18n("bert,datfile"), bert);

  ## pick 2 random choices
  rnd1 = int(rand() * bert["1,0"] + 1);
  rnd2 = int(rand() * bert["2,0"] + 1);

  ## send output
  printf("%s?\n", bert["1,"rnd1])
  printf(i18n("bert,response1"))
  printf("%s!\n", bert["2,"rnd2])
}
