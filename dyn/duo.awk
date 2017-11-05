#!/usr/bin/gawk -f
@include "dyn/dynconfig.awk"
@include "dyn/dynarray.awk"
@include "dyn/i18n.awk"

BEGIN {
  l10n["duo,datfile"]["en"] = "duo_en.dat"
  l10n["duo,response1"]["en"] = "%s and %s\n"
  l10n["duo,response1"]["nl"] = "%s en %s\n"

  srand()
}

{
  # load data
  dynLoadArray(i18n("duo,datfile"), duo)

  # pick two duo parts
  rnd1 = int(rand() * duo["0"] + 1)
  rnd2 = int(rand() * duo["0"] + 1)

  # try and pick a different one
  if (rnd1 == rnd2)
    rnd2 = int(rand() * duo["0"] + 1)

  # and return a duo
  printf(i18n("duo,response1"), duo[rnd1",1"], duo[rnd2",2"])
}
