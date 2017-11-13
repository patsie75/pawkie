#!/usr/bin/gawk -f

BEGIN {
  srand()
  dice="⚀⚁⚂⚃⚄⚅"
}

{
  result = ""

  for (i=1; i<6; i++) {
    d[i] = int(rand()*6+1)
    result = result "" substr(dice,d[i],1) " "
  }

  print "1 2 3 4 5"
  print result
  printf("%d %d %d %d %d\n", d[1], d[2], d[3], d[4], d[5])
}
