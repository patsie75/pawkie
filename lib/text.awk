# load data from file (uses: config[], creates/modifies: data[])
function loadText(label,   n, file, t1) {
  n = 0
  file = var["config"]["datadir"] ? var["config"]["datadir"]"/"label".txt" : "./"label".txt"

  t1 = preciseTime()

  while ( (getline <file) > 0 )
    data[label,++n] = $0
  close(file)

  dbg(4, "loadText", sprintf("Loaded %d entries from %s.txt in %.2f seconds", n, label, preciseTime()-t1))
  return(data[label,0]=n)
}

