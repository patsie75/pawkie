function dynLoadArray(label, array,   n, file, line, keyval) {
  n = 0
  file = config["datadir"] ? config["datadir"]"/"label : "./"label

  delete array

  while ((getline line < file) > 0) {
    ## skip comments and split key=value pairs
    if ( (line !~ /^ *(#|;)/) && (match(line, /([^=]+)=(.+)/, keyval) > 0) ) {
      ## strip leading/trailing spaces and doublequotes
      gsub(/^ *"?|"? *$/, "", keyval[1])
      gsub(/^ *"?|"? *$/, "", keyval[2])

      array[tolower(keyval[1])] = keyval[2]
      n++
    }
  }
  close(file)
  return(n)
}

