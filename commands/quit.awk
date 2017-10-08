BEGIN {
  commands["quit"] = "cmd"
  permissions["quit"] = "admin"
  timers["quit"] = 600

  help["quit"] = "quits, terminates and ends all life on the planet"
  usage["quit"] = "quit <msg>"
}

function _quit(str) {

  # save all data
  saveArray(cfg?cfg:"config.cfg", config)
  saveArray("plugins.cfg", plugins)
  saveArray("groups.cfg", groups)
  saveArray("commands.cfg", commands)
  saveArray("permissions.cfg", permissions)
  saveArray("mimic.dat", mimic)

  # Goodbye
  send(ircd, vsub(sprintf("QUIT :%s", str)))
}

