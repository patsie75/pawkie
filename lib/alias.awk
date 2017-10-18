function alias(   cmd, args, tmp) {
  cmd = var["irc"]["cmd"]
  args = var["irc"]["args"]
  dbg(6, "alias", sprintf("cmd=\"%s\" args=\"%s\"", cmd, args))

  if (cmd) {
    if (cmd in var["aliases"]) {
      dbg(5, "alias", sprintf("Found alias \"%s\"", cmd))
     
      if (index(var["aliases"][cmd], " ")) {
        var["irc"]["cmd"] = substr(var["aliases"][cmd], 1, index(var["aliases"][cmd], " ")-1)
        var["irc"]["args"] = substr(var["aliases"][cmd], index(var["aliases"][cmd], " ")+1) " " args
      } else var["irc"]["cmd"] = var["aliases"][cmd]

      dbg(4, "alias", sprintf("%s(\"%s\") -> %s(\"%s\")", cmd, args, var["irc"]["cmd"], var["irc"]["args"]))
    } else dbg(5, "alias", sprintf("No such alias \"%s\"", cmd))
  }
}
