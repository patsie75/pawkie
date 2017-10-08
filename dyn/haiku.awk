#!/usr/bin/gawk -f
@include "dyn/dynconfig.awk"
@include "dyn/dynarray.awk"

BEGIN {
#  commands["haiku"] = "awk"
#  permissions["haiku"] = "oper|admin|friend"
#  timers["hakiu"] = 600
#  help["haiku"] = "Haiku"
#  usage["haiku"] = "<form of action>"
  srand()
}

## do haiku
#function haikuSentence(_out, nr) {
{
  if (!haiku["cnt"])
    dynLoadArray("haiku.dat", haiku)

  rnd = int(rand() * haiku["pre"] + 1);
  printf("%s\n", haiku["0," rnd])

  if ( ($1 > 0) && ($1 <= haiku["cnt"]) ) rnd = $1
  else rnd = int(rand() * haiku["cnt"] + 1)

  printf("%s\n", haiku[rnd ",1"])
  printf("%s\n", haiku[rnd ",2"])
  printf("%s\n", haiku[rnd ",3"])
}

