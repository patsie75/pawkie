BEGIN {
  var["commands"]["quit"] = "cmd"
  var["permissions"]["quit"] = "admin"
  var["timers"]["quit"] = 600

  var["aliases"]["die"] = "quit"

  var["help"]["quit"] = "quits, terminates and ends all life on the planet"
  var["usage"]["quit"] = "quit <msg>"
}

function _quit(str) {

  # save all data
  saveArray(cfg?cfg:"config.cfg")
  saveArray("plugins.cfg")
  saveArray("groups.cfg")
  saveArray("commands.cfg")
  saveArray("permissions.cfg")
  saveArray("mimic.dat")

  # Goodbye
  send(var["system"]["ircd"], "QUIT :" str)
}

