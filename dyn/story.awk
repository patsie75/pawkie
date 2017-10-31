#!/usr/bin/gawk -f
@include "dyn/dynconfig.awk"

function story(sym,  i, j) {
  if (sym in lhs) {                       # a nonterminal
    i = int(lhs[sym] * rand()) + 1        # random production
    for (j = 1; j <= rhscnt[sym,i]; j++) # expand rhs's
      story(rhslist[sym, i, j])
  } else {
    printf("%s ", tolower(sym))
  }
}


function readGrammar(Grammar) {
  while ( (getline < Grammar) > 0) {
    if ($2 == "->") {
      i = ++lhs[$1]              # count lhs
      rhscnt[$1, i] = NF-2       # how many in rhs
      for (j = 3; j <= NF; j++)  # record them
        rhslist[$1, i, j-2] = $j
    } else {
      if ($0 !~ /^[ \t]*$/)
        print "illegal production: " $0
    }
  }
}


{
  srand()
  grammar = $1 ? $1 : "scifi"
  start = $2 ? $2 : "START"

  readGrammar(config["datadir"] "/" grammar ".story")
  print story(start)
}
