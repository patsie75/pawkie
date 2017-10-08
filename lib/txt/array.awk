## load data from file into an array (uses: config[])
function loadArray(label, array,   n, f, start, arr) {
  n = 0
  delete array
  f = config["datadir"] "/" label ".dat"
  start = preciseTime()

  ## parse file (key=value)
  while ( (getline <f) > 0) {
    if ( ($0 !~ /^ *(#|;)/) && (split($0, arr, "=") > 1) ) {
      ## strip leading/trailing spaces from key and value
      gsub(/^ *| *$|^ *\"|\" *$/, "", arr[1])
      gsub(/^ *| *$|^ *\"|\" *$/, "", arr[2])
      array[tolower(arr[1])] = arr[2]
      n++
      dbg(5, "loadArray", sprintf("#%02d: %s[%s] = \"%s\"", n, label, tolower(arr[1]), array[arr2]))
    }
  }
  close(f)

  dbg(3, "loadArray", sprintf("Loaded %d entries from %s in %.2f seconds", n, f, preciseTime()-start))
  return(n)
}


## save contents of array to file (uses: config[])
function saveArray(label, array,   n, f, start, idx) {
  n = 0
  f = config["datadir"] "/" label ".dat"
  start = preciseTime()

  printf("; This file was created by %s on %s\n", config["nick"], strftime("%a, %b %d at %T")) >f

  for (idx in array) {
    if ( (idx != "") && (array[idx] != "") ) {
      if (array[idx] ~ /^[0-9]+$/) printf("%s = %s\n", idx, array[idx]) >>f
      else printf("%s = \"%s\"\n", idx, array[idx]) >>f

      n++
      dbg(5, "saveArray", sprintf("#%02d: %s[%s] = \"%s\"", n, label, idx, array[idx]))
    }
  }
  close(f)

  dbg(3, "saveArray", sprintf("Saved %d entries to %s in %.2f seconds", n, f, preciseTime()-start))
  return(n)
}

