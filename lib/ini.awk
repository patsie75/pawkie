function loadIni(label) {
  delete var[label]
  mergeIni(label)
}

function mergeIni(fname,   ext, n, file, start, keyval) {
  file = ""
  label = substr(fname, 1, rindex(fname, ".")-2)
  ext = substr(fname, rindex(fname, "."))

  switch(ext) {
    case "ini":
    case "cfg":
      file = var["config"]["configdir"] ? var["config"]["configdir"]"/"fname : "./"fname
    break
    case "dat":
      file = var["config"]["datadir"] ? var["config"]["datadir"]"/"fname : "./"fname
    break
    default:
      dbg(2, "mergeIni", sprintf("Unknown type \"%s\"", ext))
      return(0)
  }

  if (!exists(file)) {
    dbg(2, "mergeIni", sprintf("Missing file \"%s\"", file))
    return(0)
  }

  n = 0
  start = preciseTime()

  dbg(4, "mergeIni", sprintf("Loading \"%s\" (%s)", file, label))
  while ((getline < file) > 0) {
    dbg(6, "mergeIni", sprintf(" \"%s\"", $0))

    ## skip comments and split key=value pairs
    if ( ($0 !~ /^ *(#|;)/) && (match($0, /([^=]+)=(.+)/, keyval) > 0) ) {
      ## strip leading/trailing spaces and doublequotes
      gsub(/^ *"?|"? *$/, "", keyval[1])
      gsub(/^ *"?|"? *$/, "", keyval[2])

      dbg(5, "mergeIni", sprintf("var[%s][%s]=\"%s\"", label, tolower(keyval[1]), keyval[2]))
      var[label][tolower(keyval[1])] = keyval[2]
      n++
    }

    # have a [label] tag to init-style switch labels
    if (match($0, /^\[([^]]*)\]$/, l)) {
      label = l[1]
      dbg(6, "mergeIni", sprintf("  new label \"%s\"", label))
    }
  }
  close(file)

  dbg(3, "mergeIni", sprintf("Loaded %d entries from %s in %.2f seconds", n, file, preciseTime()-start))
  return(n)
}

function saveIni(fname,    ext, n, file, start, idx) {
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
      dbg(2, "saveIni", sprintf("Unknown file-type \"%s\"", ext))
      return(0)
  }

  n = 0
  start = preciseTime()

  printf("; This file was created by %s on %s\n", var["config"]["nick"], strftime("%a, %b %d at %T")) >file

  for (idx in var[label]) {
    if ( (idx != "") && (var[label][idx] != "") ) {
      if (var[label][idx] ~ /^[0-9]+$/) printf("%s = %s\n", idx, var[label][idx]) >>file
      else printf("%s = \"%s\"\n", idx, var[label][idx]) >>file

      n++
      dbg(5, "saveIni", sprintf("#%02d: %s: %s = \"%s\"", n, label, idx, var[label][idx]))
    }
  }
  close(file)

  dbg(3, "saveIni", sprintf("Saved %d entries to %s in %.2f seconds", n, file, preciseTime()-start))
  return(n)
}

