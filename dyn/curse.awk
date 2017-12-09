#!/usr/bin/gawk -f
@include "dyn/dynconfig.awk"
@include "dyn/dynarray.awk"
@include "dyn/i18n.awk"

BEGIN {
  l10n["curse,datfile"]["en"] = "curse_en.dat"
  l10n["curse,datfile"]["nl"] = "curse_nl.dat"
  l10n["curse,response1"]["en"] = "Hey %s, you %s!\n"
  l10n["curse,response1"]["nl"] = "Hey %s, jij %s!\n"
  l10n["curse,response2"]["en"] = "You %s!\n"
  l10n["curse,response2"]["nl"] = "Jij %s!\n"

  srand()
}

## return a curse sentence
{
  ## load data
  dynLoadArray(i18n("curse,datfile"), curse);

  ## pick first curse word
  rnd = int(rand() * curse["bvnw,0"] + 1);
  result = curse["bvnw,"rnd];

  ## pick 1-3 extra curse words
  cnt = int(rand() * 3 + 1);
  for (i=0; i<cnt; i++) {
    rnd = int(rand() * curse["bvnw,0"] + 1);
    result = result ", " curse["bvnw,"rnd];
  }

  ## pick final curseword
  rnd = int(rand() * curse["zsnw,0"] + 1);
  result = result " " curse["zsnw,"rnd];

  ## and return sentence
  if ($0) printf(i18n("curse,response1"), $0, result)
  else printf(i18n("curse,response2"), result)
}
