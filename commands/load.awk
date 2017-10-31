BEGIN {
  var["commands"]["load"] = "cmd"
  var["permissions"]["load"] = "admin|oper"
  var["timers"]["load"] = 5

  var["aliases"]["reload"] = "load"

  var["help"]["load"] = "(re)loads configuration files"
  var["usage"]["load"] = "[config|plugins|groups|commands|permissions|timers|actions|all]"
}

function _load(args) {
  dbg(5, "load", sprintf("args: \"%s\"", args))
  argc = split(args, argv, " ")

  if (argc >= 1) {
    switch(argv[1]) {
      case "config":
      case "plugins":
      case "groups":
      case "commands":
      case "permissions":
      case "timers":
        loadArray(argv[1]".cfg")
        return("Reloaded "argv[1])
      break

      case "actions":
        sysvar["actions"] = tokenize("actions.cfg")
        return("Reloaded "argv[1])
      break
  
      case "all":
        ## load different configs
        loadArray("config.cfg")
        loadArray("plugins.cfg")
        loadArray("groups.cfg")
        loadArray("commands.cfg")
        loadArray("permissions.cfg")
        loadArray("timers.cfg")
  
        ## read "actions" file
        var["system"]["actions"] = tokenize("actions.cfg")
        return("Reloaded everything")
      break
  
      default:
        return("Unknown option \""argv[1]"\"")
    }
  } else dbg(4, "load", "Not enough arguments")
}
