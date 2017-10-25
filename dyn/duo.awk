#!/usr/bin/gawk -f
@include "dyn/dynconfig.awk"
@include "dyn/dynarray.awk"

BEGIN {
#  commands["duo"] = "awk"
#  permissions["duo"] = "oper|admin|friend"
#  timers["duo"] = 600
#  help["duo"] = "Produces a famous duo"
#  usage["duo"] = ""
  srand()
}

{
  # load data
  dynLoadArray("duo.dat", duo)

  # pick two duo parts
  rnd1 = int(rand() * duo["0"] + 1)
  rnd2 = int(rand() * duo["0"] + 1)

  # try and pick a different one
  if (rnd1 == rnd2)
    rnd2 = int(rand() * duo["0"] + 1)

  # and return a duo
  printf("%s and %s\n", duo[rnd1",1"], duo[rnd2",2"])
}
