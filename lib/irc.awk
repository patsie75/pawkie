## send string to server
function send(str) {
  if ( str !~ /^PONG / )
    printf("[%s] > %s\n", strftime("%T"), str)
  print str |& var["system"]["ircd"]
}

## receive string from server
function recv(   i, try) {
  try = 1

  if ( (i=(var["system"]["ircd"] |& getline)) > 0 ) {

#  while ( (i=(var["system"]["ircd"] |& getline)) < 1 && (try <= config["readfails"]?config["readfails"]:4) ) {
#    dbg(2, "recv", sprintf("read failure #%d from %s", try, var["system"]["ircd"]))
#    system("sleep " try)
#    try++
#  }
#
#  if (i > 0) {
    if ($0 !~ /^PING /)
      printf("[%s] < %s\n", strftime("%T"), $0)

    gsub(/\r$/, "", $0)
  } else dbg(0, "recv", sprintf("lost connection with %s", var["system"]["ircd"]))

  return(i)
}


## return if userhost is part of a group (admin|oper|friend)
## Usage: isPartOf("nick!user@domain.com", "group1|group2")
function isPartOf(userhost, grps,   i, u, usr, g, grp) {
  u = tolower(userhost)
  dbg(5, "isPartOf", sprintf("user = \"%s\", groups = \"%s\"", u, grps))

  # split grps to array (separator "|")
  if (split(grps, grp, "|") > 0) {
    for (g in grp) {
      # split groups[] into usr elements
      dbg(6, "isPartOf", sprintf("grp = \"%s\" (%s)", grp[g], var["groups"][grp[g]]))
      if (split(tolower(var["groups"][grp[g]]), usr, " ") > 0) {
        for (i in usr) {
          # match userhost to usr from groups[]
          dbg(6, "isPartOf", sprintf("usr[%s] = \"%s\"", i, usr[i]))
          if (u ~ usr[i]) {
            # there is a match
            dbg(5, "isPartOf", sprintf("\"%s\" =~ \"%s\"", u, usr[i]))
            return(1)
          }
        }
      }
    }
  }

  # this user is not part of any of the groups
  dbg(4, "isPartOf", sprintf("\"%s\" no match", u, usr[i]))
  return(0)
}

# $U = usermask (nick!login@host)
# $N = nick
# $A = auth
# $H = host
# $C = channel
# $T = target (either nick or channel)
# $I = IRC action
# $M = message (complete)
# $c = bot command
# $m = message (without command)
# $1-$9 = first 9 words of (short) message
function vsub(msg) {
  dbg(6, "vsub", sprintf("pre msg=\"%s\"", msg))
  gsub(/\$U/, var["irc"]["user"], msg)
  gsub(/\$N/, var["irc"]["nick"], msg)
  gsub(/\$A/, var["irc"]["auth"], msg)
  gsub(/\$H/, var["irc"]["host"], msg)
  gsub(/\$T/, var["irc"]["target"], msg)
  gsub(/\$I/, var["irc"]["action"], msg)
  gsub(/\$C/, var["irc"]["channel"], msg)
  gsub(/\$M/, var["irc"]["msg"], msg)
  gsub(/\$c/, var["irc"]["cmd"], msg)
  gsub(/\$m/, var["irc"]["args"], msg)
  gsub(/\$1/, var["irc"]["argv"][1], msg)
  gsub(/\$2/, var["irc"]["argv"][2], msg)
  gsub(/\$3/, var["irc"]["argv"][3], msg)
  gsub(/\$4/, var["irc"]["argv"][4], msg)
  gsub(/\$5/, var["irc"]["argv"][5], msg)
  gsub(/\$6/, var["irc"]["argv"][6], msg)
  gsub(/\$7/, var["irc"]["argv"][7], msg)
  gsub(/\$8/, var["irc"]["argv"][8], msg)
  gsub(/\$9/, var["irc"]["argv"][9], msg)
  dbg(6, "vsub", sprintf("post msg=\"%s\"", msg))

  return(msg)
}

