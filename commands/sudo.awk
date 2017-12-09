BEGIN {
  var["commands"]["sudo"] = "cmd"
  var["permissions"]["sudo"] = "admin|oper"
  var["timers"]["sudo"] = 5

  var["help"]["sudo"] = "Run a command without timer limitation"
  var["usage"]["sudo"] = "[<cmd> [<args>]]"
}

function _sudo(str) {
  if (str) {
    # replace cmd + args
    if (index(str, " ")) {
      var["irc"]["cmd"] = substr(str, 1, index(str, " ")-1)
      var["irc"]["args"] = substr(str, index(str, " ")+1)
    } else {
      var["irc"]["cmd"] = str
      var["irc"]["args"] = ""
    }
  } else {
    # execute previous command
    var["irc"]["cmd"] = var["irc"]["prev"]["cmd"]
    var["irc"]["args"] = var["irc"]["prev"]["args"]
  }

  # process possible aliases
  alias()

  # run new command (as long as it is not sudo again..)
  if (var["irc"]["cmd"] != "sudo") {
    var["system"]["sudo"] = 1

    # handle command or oneliners
    if (! command()) {
      out = _onelinerAction(var["irc"]["cmd"])
      if (out) msg(vsub(out))
    }

    var["system"]["sudo"] = 0
  }
}
