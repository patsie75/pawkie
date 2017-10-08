#!/usr/bin/gawk -f
@include "dyn/dynconfig.awk"
@include "dyn/dynarray.awk"

BEGIN {
#  commands["bert"] = "awk"
#  permissions["bert"] = "oper|admin|friend"
#  timers["bert"] = 600
#  help["bert"] = "Bert helps you out of a tight situation with words of wisdom"
#  usage["bert"] = "<form of action>"
  srand()
}

## do Bert
#function _bert(msg,   rnd1, rnd2) {
{
  ## load data if neccesary
  if (!bert["1,0"])
    dynLoadArray("bert.dat", bert);

  ## pick 2 random choices
  rnd1 = int(rand() * bert["1,0"] + 1);
  rnd2 = int(rand() * bert["2,0"] + 1);

  ## send output
  printf("%s?\n", bert["1,"rnd1])
  printf("Is $m niet heel moeilijk dan, Bert?\n")
  printf("%s!\n", bert["2,"rnd2])
}
