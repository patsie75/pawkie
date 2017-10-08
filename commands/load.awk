BEGIN {
  commands["load"] = "cmd"
  permissions["load"] = "admin|oper"
  timers["load"] = 5

  help["load"] = "(re)loads configuration files"
  usage["load"] = "[config|plugins|groups|commands|permissions|actions|all]"
}

function _load(args) {
  dbg(5, "_load", sprintf("args: \"%s\"", args))
  argc = split(args, argv, " ")

  if (argc >= 1) {
    switch(argv[1]) {
      case "config":
        loadArray(cfg?cfg:"config.cfg", config)
        send(ircd, vsub("PRIVMSG $T :Reloaded $1"))
      break

      case "plugins":
        loadArray("plugins.cfg", plugins)
        send(ircd, vsub("PRIVMSG $T :Reloaded $1"))
      break

      case "groups":
        loadArray("groups.cfg", groups)
        send(ircd, vsub("PRIVMSG $T :Reloaded $1"))
      break

      case "commands":
        loadArray("commands.cfg", commands)
        send(ircd, vsub("PRIVMSG $T :Reloaded $1"))
      break

      case "permissions":
        loadArray("permissions.cfg", permissions)
        send(ircd, vsub("PRIVMSG $T :Reloaded $1"))
      break

      case "timers":
        loadArray("timers.cfg", timers)
        send(ircd, vsub("PRIVMSG $T :Reloaded $1"))
      break

      case "actions":
        sysvar["actions"] = tokenize("actions", actions)
        send(ircd, vsub("PRIVMSG $T :Reloaded $1"))
      break
  
      case "all":
        ## load different configs
        loadArray(cfg?cfg:"config.cfg", config)
        loadArray("plugins.cfg", plugins)
        loadArray("groups.cfg", groups)
        loadArray("commands.cfg", commands)
        loadArray("permissions.cfg", permissions)
        loadArray("timers.cfg", timers)
  
        ## read "actions" file
        sysvar["actions"] = tokenize("actions", actions)
      break
  
      default:
        send(ircd, vsub(sprintf("PRIVMSG $T :Unknown option \"%s\"", argv[1])))
    }
  } else dbg(4, "_load", "Not enough arguments")
}
