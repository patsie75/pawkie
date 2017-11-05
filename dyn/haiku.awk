#!/usr/bin/gawk -f
@include "dyn/dynconfig.awk"
@include "dyn/dynarray.awk"
@include "dyn/i18n.awk"

BEGIN {
  l10n["haiku,datfile"]["en"] = "haiku_en.dat"
  l10n["haiku,datfile"]["nl"] = "haiku_nl.dat"
 
  srand()
}

## do haiku
{
  if (!haiku["cnt"])
    dynLoadArray(i18n("haiku,datfile"), haiku)

  rnd = int(rand() * haiku["pre"] + 1);
  printf("%s\n", haiku["0," rnd])

  if ( ($1 > 0) && ($1 <= haiku["cnt"]) ) rnd = $1
  else rnd = int(rand() * haiku["cnt"] + 1)

  printf("%s\n", haiku[rnd ",1"])
  printf("%s\n", haiku[rnd ",2"])
  printf("%s\n", haiku[rnd ",3"])
}

