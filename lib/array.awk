function loadArray(label, array) {
  delete array
  mergeArray(label, array)
}

function mergeArray(label, array,   n, file, start, keyval) {
  file = ""

  switch(substr(label, length(label)-3)) {
    case ".cfg":
      file = config["configdir"] ? config["configdir"]"/"label : "./"label
    break
    case ".dat":
      file = config["datadir"] ? config["datadir"]"/"label : "./"label
    break
    default:
      dbg(2, "loadArray", sprintf("Unknown file-type \"%s\"", label))
      return(0)
  }

  if (!exists(file)) {
    dbg(2, "loadArray", sprintf("Missing file \"%s\"", file))
    #send(ircd, vsub(sprintf("PRIVMSG $T :Missing file \"%s\"", file)))
    return(0)
  }

  n = 0
  start = preciseTime()

  dbg(4, "loadArray", sprintf("Loading \"%s\" (%s)", file, label))
  while ((getline < file) > 0) {
    dbg(6, "loadArray", sprintf(" \"%s\"", $0))

    ## skip comments and split key=value pairs
    if ( ($0 !~ /^ *(#|;)/) && (match($0, /([^=]+)=(.+)/, keyval) > 0) ) {
      ## strip leading/trailing spaces and doublequotes
      gsub(/^ *"?|"? *$/, "", keyval[1])
      gsub(/^ *"?|"? *$/, "", keyval[2])

      dbg(5, "loadArray", sprintf("%s[%s]=\"%s\"", label, tolower(keyval[1]), keyval[2]))
      array[tolower(keyval[1])] = keyval[2]
      n++
    }
  }
  close(file)

  dbg(3, "loadArray", sprintf("Loaded %d entries from %s in %.2f seconds", n, file, preciseTime()-start))
  return(n)
}

function saveArray(label, array,   n, file, start, idx) {
  file = ""

  switch(substr(label, length(label)-3)) {
    case ".cfg":
      file = config["configdir"] ? config["configdir"]"/"label : "./"label
    break
    case ".dat":
      file = config["datadir"] ? config["datadir"]"/"label : "./"label
    break
    default:
      dbg(2, "saveArray", sprintf("Unknown file-type \"%s\"", label))
      return(0)
  }

  n = 0
  start = preciseTime()

  printf("; This file was created by %s on %s\n", config["nick"], strftime("%a, %b %d at %T")) >file

  for (idx in array) {
    if ( (idx != "") && (array[idx] != "") ) {
      if (array[idx] ~ /^[0-9]+$/) printf("%s = %s\n", idx, array[idx]) >>file
      else printf("%s = \"%s\"\n", idx, array[idx]) >>file

      n++
      dbg(5, "saveArray", sprintf("#%02d: %s: %s = \"%s\"", n, label, idx, array[idx]))
    }
  }
  close(file)

  dbg(3, "saveArray", sprintf("Saved %d entries to %s in %.2f seconds", n, file, preciseTime()-start))
  return(n)
}

function reconfig(   str, cfg, c) {
  str = ""
  dbg(5, "reconfig", sprintf("Pass config: \"%s\"", config["dynconfig"]))
  split(config["dynconfig"], cfg, ",")

  for (c in config)
    if ( inArray(c, cfg) && (length(config[c]) < 20) ) {
      dbg(6, "reconfig", sprintf(" adding %s=\"%s\"", c, config[c]))
      str = str "\001" c "=" config[c]
    }

  if (str != "") {
    dbg(5, "reconfig", sprintf("str: \"%s\"", str))
    return(substr(str,2))
  }
}
