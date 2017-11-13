BEGIN {
  var["commands"]["load"] = "cmd"
  var["permissions"]["load"] = "admin|oper"
  var["timers"]["load"] = 5

  var["aliases"]["reload"] = "load"

  var["help"]["load"] = "(re)loads configuration files"
  var["usage"]["load"] = ""
}

function _load(args) {
  dbg(5, "load", sprintf("args: \"%s\"", args))
  argc = split(args, argv, " ")

  ## load different configs
  loadIni(cfg?cfg:"config.ini")

  ## read "actions" file
  var["system"]["actions"] = tokenize("actions.cfg")

  # create empty mimic array
  loadArray("mimic.dat")
  var["mimic"]["__placeholder__"] = ""
  delete var["mimic"]["__placeholder__"]

  dbg(4, "load", "Reload complete")
  return("Reload complete")
}
