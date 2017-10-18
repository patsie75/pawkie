## tokenize a file based on the following parser
## ON <action> [FROM "%"<group>|<nick>["!"<auth>"@"<host>]] [TO "#"<channel>|<nick>] [SAYING <contents>] [CHANCE <percent>] DO <command>;
function tokenize(file,   f, line, lnr, nractions, token) {
  f = var["config"]["configdir"] ? var["config"]["configdir"]"/"file : "./"file

  dbg(4, "tokenize", sprintf("file: \"%s\"", f))
  IGNORECASE = 1

  lnr = 0
  while ( (getline line < f) > 0 ) {
    lnr++
    dbg(5, "tokenize", sprintf("line #%d: \"%s\"", lnr, line))

    # skip comments and empty lines
    if (line ~ /^ *[#;]|^ *$/) continue

    if ( match(line, /^ON ("[^"]+|[^ ]+) (FROM ("[^"]+"|[^ ]+) )?(TO ("[^"]+"|[^ ]+) )?(SAYING ("[^"]+"|[^ ]+) )?(CHANCE ("[0-9]+"|[0-9]+)%? )?DO ("[^"]+"|[^ ]+)$/, token) ) {
      nractions++
      # strip leading/trailing spaces from tokens (is this necessary?)
      gsub(/^\s*"|"\s*$/, "", token[1])
      gsub(/^\s*"|"\s*$/, "", token[3])
      gsub(/^\s*"|"\s*$/, "", token[5])
      gsub(/^\s*"|"\s*$/, "", token[7])
      gsub(/^\s*"|"\s*$/, "", token[9])
      gsub(/^\s*"|"\s*$/, "", token[10])

      # add action to list, with unique separator
      var["actions"][nractions] = token[1] "\001" token[3] "\001" token[5] "\001" token[7] "\001" token[9] "\001" token[10]
      dbg(4, "tokenize", sprintf("ON [%s] FROM [%s] TO [%s] SAYING [%s] CHANCE [%s] DO [%s]", token[1], token[3], token[5], token[7], token[9], token[10]))
    } else {
      # generate message on malformed line
      dbg(2, "tokenize", sprintf("Error parsing line #%d in file \"%s\"", lnr, f))
      dbg(2, "tokenize", sprintf("%3d: \"%s\"", lnr, line))
    }
  }

  close(f)
  IGNORECASE = 0

  return(nractions)
}

