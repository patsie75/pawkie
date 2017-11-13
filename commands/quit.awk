BEGIN {
  var["commands"]["quit"] = "cmd"
  var["permissions"]["quit"] = "admin"
  var["timers"]["quit"] = 600

  var["aliases"]["die"] = "quit"

  var["help"]["quit"] = "quits, terminates and ends all life on the planet"
  var["usage"]["quit"] = "[<message>]"
}

function _quit(str) {

  # save all data
#  saveIni(cfg?cfg:"config.ini")
  saveArray("mimic.dat")

  # Goodbye
  send("QUIT :" str)
}

