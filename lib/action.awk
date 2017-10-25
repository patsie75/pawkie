# ON <action> [FROM "%"<group>|<nick>["!"<auth>"@"<host>]] [TO "#"<channel>|<nick>] [SAYING <contents>] [CHANCE <percent>] DO <command>;
function reaction(action,   tmp) {
  if (split(action, tmp, "\001") == 6)
    return(sprintf("ON \"%s\"%s%s%s%s DO \"%s\"", tmp[1], tmp[2]?" FROM \""tmp[2]"\"":"", tmp[3]?" TO \""tmp[3]"\"":"", tmp[4]?" SAYING \""tmp[4]"\"":"", tmp[5]?" CHANCE \""tmp[5]"\"":"", tmp[6]))
  else {
    dbg(2, "reaction", sprintf("broken action \"%s\"", action))
    return("<BROKEN ACTION>")
  }
}


function action(   act, i, from, to, saying, chance, token, n, tmp, plugin, command) {
  dbg(6, "action", sprintf("processing %d actions", var["system"]["actions"]))

  # loop over all actions
  for (act=1; act<=var["system"]["actions"]; act++) {
    from = 0
    to = 0
    saying = 0
    chance = 0

    # split action on separator
    if (split(var["actions"][act], token, "\001") == 6) {

      # ON <action>
      if (tolower(token[1]) == tolower(var["irc"]["action"])) {
        dbg(6, "action", sprintf("Found ON %s", toupper(token[1])))

        # FROM "%"<group>|<nick>["!"<auth>["@"<host>]] (todo: nick!auth@host)
        if (token[2]) {
          # split multiple persons/groups "FROM %group1|%group2"
          n = split(tolower(token[2]), tmp, "|")
          for (i=1; i<=n; i++) {
            # test if it's a group "%groupname"
            if (substr(tmp[i], 1, 1) == "%") {
              # check if activating user is part of the group
              if (isPartOf(var["irc"]["user"], substr(tmp[i], 2))) {
                from = 1
                dbg(6, "action", sprintf(" FROM (%s in %s)", var["irc"]["user"], tmp[i]))
                break
              }
            } else dbg(3, "action", sprintf("FROM %s not a group", tmp[i]))
          }
        } else from = 1


        # TO "#"<channel>|<nick> (todo: nick)
        if (token[3]) {
          # split multiple channels/nicks "TO #chan1|#chan2"
          n = split(tolower(token[3]), tmp, "|")
          for (i=1; i<=n; i++) {
            # check if activating target is part of the list
            if (tolower(var["irc"]["target"]) == tmp[i]) {
              to = 1
              dbg(6, "action", sprintf(" TO (%s)", var["irc"]["target"]))
              break
            }
          }
        } else to = 1


        # SAYING <contents>
        if (token[4]) {
          # check if spoken text regexp matches <content> (case insensitive)
          if (tolower(var["irc"]["msg"]) ~ tolower(token[4])) {
            saying = 1
            dbg(6, "action", sprintf(" SAYING (%s)", var["irc"]["msg"]))
          }
        } else saying = 1


        # CHANCE <percent>
        if (token[5]) {
          # generate random number (1-100)
          rnd = int(rand() * 100) + 1

          # check if CHANCE is bigger (or equal) than rnd
          if (token[5] >= rnd) chance = 1
          dbg(6, "action", sprintf(" CHANCE %d %s %d", token[5], (token[5]>=rnd)?">=":"<", rnd))
        } else chance = 1


        # DO <command [<args>]
        if (from && to && saying && chance) {
          dbg(4, "action", sprintf("raw \"%s\" matches action \"%s\"", var["irc"]["raw"], reaction(var["actions"][act])))

          # extract plugin:command from DO
          plugin = substr(token[6], 1, index(token[6], ":")-1)
          command = substr(token[6], index(token[6], ":")+1)

          # extract cmd" "args from command
          if ( (i=index(command, " ")) > 0) {
            var["irc"]["cmd"] = substr(command, 1, i-1)
            var["irc"]["args"] = substr(command, i+1)
          } else {
            var["irc"]["cmd"] = substr(command, 1)
            var["irc"]["args"] = ""
          }

          dbg(5, "action", sprintf("plugin: \"%s\" command: \"%s\" args: \"%s\"", plugin, var["irc"]["cmd"], var["irc"]["args"]))

          # pick plugin for command to  run
          switch(plugin) {
            # "raw" just send command to IRC server
            case "raw":
              send(vsub(command))
              return
            break

            # "cmd" is internal command (if awk function is undefined, causes crash)
            case "cmd": 
              if (var["irc"]["cmd"] in var["commands"]) {
                # called function is prepended with "_"
                call = "_"var["irc"]["cmd"]
                if (call in FUNCTAB) {
                  # catch single line return from function and send PRIVMSG to IRC server
                  out = @call(var["irc"]["args"])
                  if (out ~ /^ACTION/)
                    send(sprintf("PRIVMSG $T :\001%s\001", out))
                  else
                    send(sprintf("PRIVMSG $T :%s", out))
                } else dbg(2, "action", sprintf("Configured command \"%s\" doesn't have a function %s()", var["irc"]["cmd"], call))
              } else dbg(4, "action", sprintf("No such internal function \"%s\"", var["irc"]["cmd"]))
              return
            break

            # "awk" runs external awk script
            case "awk":
              # call dyncommand, catch number of output lines
              n = dyncommand("awk", var["irc"]["cmd"]".awk", var["irc"]["args"], output)
              # send output as PRIVMSG to IRC server
              for (i=1; i<=n; i++)
                if (output[i] ~ /^ACTION/)
                  send(vsub(sprintf("PRIVMSG $T :\001%s\001", output[i])))
                else
                  send(vsub(sprintf("PRIVMSG $T :%s", output[i])))
              return
            break

            default:
              dbg(1, "action", sprintf("Unknown plugin \"%s\" in action #%d", plugin, act))
          }

        } else dbg(5, "action", sprintf("%s Failed%s%s%s%s", reaction(var["actions"][act]), from?"":" FROM", to?"":" TO", saying?"":" SAYING", chance?"":" CHANCE"))
      }
    } else dbg(2, "action", sprintf("broken action #%d", act))
  }
}

