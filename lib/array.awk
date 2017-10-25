function loadArray(label) {
  delete var[label]
  mergeArray(label)
}

function mergeArray(fname,   ext, n, file, start, keyval) {
  file = ""
  label = substr(fname, 1, rindex(fname, ".")-1)
  ext = substr(fname, rindex(fname, ".")+1)

  switch(ext) {
    case "cfg":
      file = var["config"]["configdir"] ? var["config"]["configdir"]"/"fname : "./"fname
    break
    case "dat":
      file = var["config"]["datadir"] ? var["config"]["datadir"]"/"fname : "./"fname
    break
    default:
      dbg(2, "mergeArray", sprintf("Unknown type \"%s\"", ext))
      return(0)
  }

  if (!exists(file)) {
    dbg(2, "mergeArray", sprintf("Missing file \"%s\"", file))
    return(0)
  }

  n = 0
  start = preciseTime()

  dbg(4, "mergeArray", sprintf("Loading \"%s\" (%s)", file, label))
  while ((getline < file) > 0) {
    dbg(6, "mergeArray", sprintf(" \"%s\"", $0))

    ## skip comments and split key=value pairs
    if ( ($0 !~ /^ *(#|;)/) && (match($0, /([^=]+)=(.+)/, keyval) > 0) ) {
      ## strip leading/trailing spaces and doublequotes
      gsub(/^ *"?|"? *$/, "", keyval[1])
      gsub(/^ *"?|"? *$/, "", keyval[2])

      dbg(5, "mergeArray", sprintf("var[%s][%s]=\"%s\"", label, tolower(keyval[1]), keyval[2]))
      var[label][tolower(keyval[1])] = keyval[2]
      n++
    }

  }
  close(file)

  dbg(3, "mergeArray", sprintf("Loaded %d entries from %s in %.2f seconds", n, file, preciseTime()-start))
  return(n)
}

function saveArray(fname,    label, ext, n, file, start, idx) {
  file = ""
  label = substr(fname, 1, length(fname)-4)
  ext = substr(fname, length(fname)-2)

  switch(ext) {
    case "cfg":
      file = var["config"]["configdir"] ? var["config"]["configdir"]"/"fname : "./"fname
    break
    case "dat":
      file = var["config"]["datadir"] ? var["config"]["datadir"]"/"fname : "./"fname
    break
    default:
      dbg(2, "saveArray", sprintf("Unknown file-type \"%s\"", ext))
      return(0)
  }

  n = 0
  start = preciseTime()

  if (isarray(var[label])) {
    printf("; This file was created by %s on %s\n", var["config"]["nick"], strftime("%a, %b %d at %T")) >file
  
    dbg(6, "saveArray", sprintf("isarray(var): %s, label: %s, isarray(var[%s]): %s", isarray(var)?"true":"false", label, label, isarray(var[label])?"true":"false"))
    for (idx in var[label]) {
      if ( (idx != "") && (var[label][idx] != "") ) {
        if (var[label][idx] ~ /^[0-9]+$/) printf("%s = %s\n", idx, var[label][idx]) >>file
        else printf("%s = \"%s\"\n", idx, var[label][idx]) >>file
  
        n++
        dbg(5, "saveArray", sprintf("#%02d: %s: %s = \"%s\"", n, label, idx, var[label][idx]))
      }
    }
    close(file)

    dbg(3, "saveArray", sprintf("Saved %d entries to %s in %.2f seconds", n, file, preciseTime()-start))
    return(n)
  }

  dbg(2, "saveArray", sprintf("var[%s] not an array", label))
  return(0)
}

function reconfig(   str, cfg, c) {
  str = ""
  dbg(5, "reconfig", sprintf("Pass config: \"%s\"", var["config"]["dynconfig"]))
  split(var["config"]["dynconfig"], cfg, ",")

  for (c in var["config"])
    if ( inArray(c, cfg) && (length(var["config"][c]) < 20) ) {
      dbg(6, "reconfig", sprintf(" adding %s=\"%s\"", c, var["config"][c]))
      str = str ? str"\001"c"="var["config"][c] : c"="var["config"][c]
    }

  if (str) {
    dbg(5, "reconfig", sprintf("str: \"%s\"", str))
    return(str)
  }
}
