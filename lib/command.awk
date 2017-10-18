function command(   perm, time, call, n, i, output) {
  if (var["irc"]["cmd"]) {
    if (var["irc"]["cmd"] in var["commands"]) {
      dbg(5, "command", sprintf("Found command \"%s\"", var["irc"]["cmd"]))
  
      perm = 0
      # is the user allowed to run this command
      if (var["permissions"][var["irc"]["cmd"]]) {
        if (isPartOf(var["irc"]["user"], var["permissions"][var["irc"]["cmd"]])) perm = 1
        else dbg(4, "command", sprintf("var["permissions"][%s] user \"%s\" not in \"%s\"", var["irc"]["cmd"], var["irc"]["user"], var["permissions"][var["irc"]["cmd"]]))
      } else perm = 1
  
      time = 0
      # commands have minimum interval between runs
      if (var["timers"][var["irc"]["cmd"]]) {
        trgt = tolower(var["irc"]["cmd"]","var["irc"]["target"])
        if (systime() >= timer[trgt]) {
          timer[trgt] = systime() + var["timers"][var["irc"]["cmd"]]
          time = 1
        } else dbg(4, "command", sprintf("timer[%s] %s has not yet passed %s", trgt, strftime("%T"), strftime("%T", timer[trgt])))
      } else time = 1
  
      # everything is ok, run command
      if (perm && time) {
        switch(var["commands"][var["irc"]["cmd"]]) {
          case "cmd":
            call = "_"var["irc"]["cmd"]
            if (call in FUNCTAB) {
              dbg(4, "command", sprintf("Executing internal command %s(\"%s\")", call, var["irc"]["args"]))
              out = @call(var["irc"]["args"])
              if (out) {
                if (out ~ /^ACTION/)
                  send(var["system"]["ircd"], sprintf("PRIVMSG %s :\001%s\001", var["irc"]["target"], out))
                else
                  send(var["system"]["ircd"], sprintf("PRIVMSG %s :%s", var["irc"]["target"], out))
              }
              return(1)
            } else dbg(2, "command", sprintf("defined command \"%s\" does not have a function \"%s\"", var["irc"]["cmd"], call))
          break

          case "awk":
            dbg(4, "command", sprintf("Executing external command %s(\"%s\")", var["irc"]["cmd"], var["irc"]["args"]))
            n = dyncommand(var["commands"][var["irc"]["cmd"]], var["irc"]["cmd"]"."var["commands"][var["irc"]["cmd"]], var["irc"]["args"], output)
            for (i=1; i<=n; i++)
              if (output[i] ~ /^ACTION/)
                send(var["system"]["ircd"], sprintf("PRIVMSG %s :\001%s\001", var["irc"]["target"], output[i]))
              else
                send(var["system"]["ircd"], sprintf("PRIVMSG %s :%s", var["irc"]["target"], output[i]))
            return(1)
          break

          default:
            dbg(1, "command", sprintf("Unknown handler \"%s\" for command \"%s\"", var["commands"][var["irc"]["cmd"]], var["irc"]["cmd"]))
        }
      } else dbg(5, "command", sprintf("perm %s %s 1; time %s %s 1", perm, (perm==1)?"==":"!=", time, (time==1)?"==":"!="))
  
    } else dbg(5, "command", sprintf("No such command \"%s\"", var["irc"]["cmd"]))
  }
}
