function command(   perm, time, call, n, i, output) {
  if (var["cmd"]) {
    if (var["cmd"] in commands) {
      dbg(5, "command", sprintf("Found command \"%s\"", var["cmd"]))
  
      perm = 0
      # is the user allowed to run this command
      if (permissions[var["cmd"]]) {
        if (isPartOf(var["user"], permissions[var["cmd"]])) perm = 1
        else dbg(4, "command", sprintf("permissions[%s] user \"%s\" not in \"%s\"", var["cmd"], var["user"], permissions[var["cmd"]]))
      } else perm = 1
  
      time = 0
      # commands have minimum interval between runs
      if (timers[var["cmd"]]) {
        trgt = tolower(var["cmd"]","var["target"])
        if (systime() >= timer[trgt]) {
          timer[trgt] = systime() + timers[var["cmd"]]
          time = 1
        } else dbg(4, "command", sprintf("timer[%s] %s not yet passed %s", trgt, strftime("%T", timer[trgt]), strftime("%T")))
      } else time = 1
  
      # everything is ok, run command
      if (perm && time) {
        switch(commands[var["cmd"]]) {
          case "cmd":
            call = "_"var["cmd"]
            dbg(4, "command", sprintf("Executing internal command %s(%s)", call, var["args"]))
            out = @call(var["args"])
            if (out) send(ircd, vsub(sprintf("PRIVMSG $T :%s", out)))
          break

          case "awk":
            n = dyncommand(commands[var["cmd"]], var["cmd"]"."commands[var["cmd"]], var["args"], output)
            for (i=1; i<=n; i++)
              send(ircd, vsub(output[i]))
          break

          default:
            dbg(1, "command", sprintf("Unknown handler \"%s\" for command \"%s\"", commands[var["cmd"]], var["cmd"]))
        }
      } else dbg(5, "command", sprintf("perm %s %s 1; time %s %s 1", perm, (perm==1)?"==":"!=", time, (time==1)?"==":"!="))
  
    } else dbg(4, "command", sprintf("No such command \"%s\"", var["cmd"]))
  }
}
