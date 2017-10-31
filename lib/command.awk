function command(   cmd, perm, time, call, n, i, output) {
  cmd = var["irc"]["cmd"]

  if (cmd) {
    if (cmd in var["commands"]) {
      dbg(5, "command", sprintf("Found command \"%s\"", cmd))
  
      perm = 0
      # is the user allowed to run this command
      if (cmd in var["permissions"]) {
        if (isPartOf(var["irc"]["user"], var["permissions"][cmd])) perm = 1
        else dbg(4, "command", sprintf("var["permissions"][%s] user \"%s\" not in \"%s\"", cmd, var["irc"]["user"], var["permissions"][cmd]))
      } else perm = 1
  
      time = 0
      # commands have minimum interval between runs
      if (cmd in var["timers"]) {
        trgt = tolower(cmd","var["irc"]["target"])
        if (systime() >= var["timer"][trgt]) {
          var["timer"][trgt] = systime() + var["timers"][cmd]
          time = 1
        } else dbg(4, "command", sprintf("timer[%s] %s has not yet passed %s", trgt, strftime("%T"), strftime("%T", var["timer"][trgt])))
      } else time = 1
  
      # everything is ok, run command
      if (perm && time) {
        switch(var["commands"][cmd]) {
          case "cmd":
            call = "_"cmd
            if (call in FUNCTAB) {
              dbg(4, "command", sprintf("Executing internal command %s(\"%s\")", call, var["irc"]["args"]))
              msg(@call(var["irc"]["args"]))
              return(1)
            } else dbg(2, "command", sprintf("defined command \"%s\" does not have a function \"%s\"", cmd, call))
          break

          case "awk":
            dbg(4, "command", sprintf("Executing external command %s(\"%s\")", cmd, var["irc"]["args"]))
            n = dyncommand(var["commands"][cmd], cmd"."var["commands"][cmd], var["irc"]["args"], output)
            for (i=1; i<=n; i++)
              msg(output[i])
            return(1)
          break

          default:
            dbg(1, "command", sprintf("Unknown handler \"%s\" for command \"%s\"", var["commands"][cmd], cmd))
        }
      } else dbg(5, "command", sprintf("perm: %s; time: %s %s %s", (perm==1)?"true":"false", strftime("%T"), (time==1)?">":"<", strftime("%T", var["timer"][trgt])))
  
    } else dbg(5, "command", sprintf("No such command \"%s\"", cmd))
  }
}
