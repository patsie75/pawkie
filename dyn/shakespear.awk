#!/usr/bin/gawk -f
@include "dyn/dynconfig.awk"
@include "dyn/dynarray.awk"

## return a shakespearian curse
function shakespearSentence(target,   result, rnd) {
  # load data
  dynLoadArray("shakespear.dat", shakespear)

  ## pick curse words
  rnd = int(rand() * shakespear["1,0"] + 1)
  result = shakespear["1,"rnd]

  rnd = int(rand() * shakespear["2,0"] + 1)
  result = result ", " shakespear["2,"rnd]

  rnd = int(rand() * shakespear["3,0"] + 1)
  result = result " " shakespear["3,"rnd]

  ## and return sentence
  if (target)
    return("Hey " target ", you " result)
  else
    return("You " result)
}

{
  srand()
  print shakespearSentence($0)
}

