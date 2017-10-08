function loadConfig(label, array,   n, file, start, keyval) {
  n = 0
  file = config["configdir"] ? config["configdir"]"/"label".cfg" : "./"label".cfg"
  start = preciseTime()

  dbg(4, "loadConfig", sprintf("Loading \"%s\" (%s)", file, label))
  while ((getline < file) > 0) {
    dbg(6, "loadConfig", sprintf(" \"%s\"", $0))

    ## skip comments and split key=value pairs
    if ( ($0 !~ /^ *(#|;)/) && (match($0, /([^=]+)=(.+)/, keyval) > 0) ) {
      ## strip leading/trailing spaces and doublequotes
      gsub(/^ *"?|"? *$/, "", keyval[1])
      gsub(/^ *"?|"? *$/, "", keyval[2])
      dbg(5, "loadConfig", sprintf("%s[%s]=\"%s\"", label, tolower(keyval[1]), keyval[2]))
      array[tolower(keyval[1])] = keyval[2]
      n++
    }
  }
  close(file)

  dbg(3, "loadConfig", sprintf("Loaded %d entries from %s in %.2f seconds", n, file, preciseTime()-start))
  return(n)
}

