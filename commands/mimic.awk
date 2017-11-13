BEGIN {
  var["commands"]["mimic"] = "cmd"
  var["permissions"]["mimic"] = "admin|oper|friend"
  var["timers"]["mimic"] = 300

  var["help"]["mimic"] = "Immitate the users on the channel"
  var["usage"]["mimic"] = ""
}


## Return a random sentence from a mimic dictionary
function _mimic(    min, max, sentence, key, word, nrwords, arr, i, n) {
  min = var["config"]["mimicminwords"] ? int(var["config"]["mimicminwords"]) : 10
  max = var["config"]["mimicmaxwords"] ? int(var["config"]["mimicmaxwords"]) : 15
  sentence = ""
  key = randkey(var["mimic"])

  ## Find an amount of words to concatenate based on the next/previous one
  nrwords = int(rand() * (max - min)) + min
  dbg(5, "mimic", sprintf("min: %s, max: %s, key: %s, nrwords: %s", min, max, key, nrwords))

  while (nrwords-- > 0) {
    for (i=1; i<=10; i++) {
      if (!var["mimic"][key]) key = randkey(var["mimic"])
      else continue
    }
    n = split(var["mimic"][key], arr, ",")
    i = randkey(arr)
    word = arr[i]
    sentence = sentence ? sentence" "word : word
    key = word
    dbg(6, "mimic", sprintf("key: \"%s\", arr=\"%s\", n=%d, i=\"%s\"",key, var["mimic"][key], n, i))
    dbg(6, "mimic", sprintf("word: \"%s\" sentence: \"%s\"", word, sentence))
  }

  dbg(5, "mimic", sprintf("sentence: \"%s\"", sentence))
  return(sentence)
}


## Split a line into words and add then to a mimic dictionary (uses: config[])
function mimicAddLine(line,   i, n, l, min, max, word, words, key) {
  dbg(5, "mimicAddLine", sprintf("line: %s", line))
  min = var["config"]["mimicminlen"] ? int(var["config"]["mimicminlen"]) : 2
  max = var["config"]["mimicmaxlen"] ? int(var["config"]["mimicmaxlen"]) : 20

  ## Strip non-alpha chars from input and split into array
  gsub(/[^[:alnum:] ]/, "", line)
  n = split(tolower(line), words, " ")

  ## Parse each word to lowercase and append to dictionary
  key = words[1]
  for (i=2; i<=n; i++) {
    word = words[i]
    l = length(word)
    dbg(6, "mimicAddLine", sprintf("words[%s] = %s (len=%d min=%d max=%d)", i, word, l, min, max))

    ## Add word to dictionary
    if ( (length(word) >= min) && (length(word) <= max) ) {
      var["mimic"][key] = (var["mimic"][key]) ? word","var["mimic"][key] : word
      dbg(6, "mimicAddLine", sprintf(" var[mimic][%s] += %s (%s)", key, word, var["mimic"][key]))
      key = word
    }
  }

}


## clean up the mimic dictionary
#function mimicCleanup(dict) {
#  delete newdict
#  oldKeyNr = newKeyNr = oldTotal = newTotal = 0
#
#  ## start time
#  t1 = preciseTime()
#
#  ## loop over all dictionary entries
#  for (key in dict) {
#    oldKeyNr++
#
#    ## check if key is valid length
#    if ( (length(key) >= (config["mimicminlen"]+0)) &&
#         (length(key) <= (config["mimicmaxlen"]+0)) ) {
#
#      ## key must be lowercase
#      newkey = tolower(key)
#      oldTotal += split(_dict[key], arr, ",")
#
#      n = 0
#      for (i in arr) {
#        word = tolower(arr[i])
#        ## word must be valid length, have new index and not exceed number of max words per entry
#        if ( (length(word) >= (config["mimicminlen"])+0) &&
#             (length(word) <= (config["mimicmaxlen"])+0) &&
#             ( (word in _dict) && (n < (config["mimicmaxwords"]*3)) ) ) {
#
#          ## make lowercase and add to new dictionary
#          word = tolower(word)
#          newdict[newkey] = (newdict[newkey]) ? word","newdict[newkey] : word
#          n++
#        }
#      }
#      newTotal += n
#    }
#  }
#
#  delete dict
#  for (i in newdict) {
#    dict[i] = newdict[i]
#    newKeyNr++
#  }
#
#  t2 = preciseTime()
#  printf("mimicCleanup(): Reduced number of keys from %d to %d and total words from %d to %d in %.2f seconds\n", oldKeyNr, newKeyNr, oldTotal, newTotal, t2-t1)
#
#}

