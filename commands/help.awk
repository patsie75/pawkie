BEGIN {
  var["commands"]["help"] = "cmd"
  var["timers"]["help"] = 5

  var["aliases"]["usage"] = "help usage"
  var["aliases"]["man"] = "help usage"

  var["help"]["help"] = "Get help about certain commands"
  var["usage"]["help"] = "help [<command>]"
}

function _help(str,    cmd, result) {
  dbg(5, "help", "str = \""str"\"")

  if (str ~ /^usage /) {
    cmd = substr(str, 7)
    dbg(6, "help", "usage: cmd = \""cmd"\"")
    if (cmd in var["usage"]) {
      dbg(6, "help", "usage: "cmd" in usage")
      if (cmd in var["permissions"]) {
        dbg(6, "help", "usage: "cmd" in permissions")
        if (isPartOf(var["irc"]["user"], var["permissions"][cmd])) {
          return(var["usage"][cmd])
        } else return("This is not a command for you")
      } else return(var["usage"][cmd])
    } else return("Can't find manual for "cmd)
  }

  if (str == "") {
    dbg(6, "help", "list")
    # list all commands
    for (cmd in var["commands"]) {
      # only add if user has permissions
      if (cmd in var["permissions"]) {
        if (isPartOf(var["irc"]["user"], var["permissions"][cmd]))
          result = result?result", "cmd:cmd
      } else result = result?result", "cmd:cmd
    }
    return("Commands available for you are: " result)

  } else {

    cmd = str
    dbg(6, "help", "help: cmd = \""cmd"\"")
    if (cmd in var["help"]) {
      if (cmd in var["permissions"]) {
        if (isPartOf(var["irc"]["user"], var["permissions"][cmd])) {
          return(var["help"][cmd])
        } else return("This is not a command for you")
      } else return(var["help"][cmd])
    } else return("Can't find help on "cmd)
  }

}
