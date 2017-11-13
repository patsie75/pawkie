BEGIN {
  var["commands"]["sudo"] = "cmd"
  var["permissions"]["sudo"] = "admin|oper"
  var["timers"]["sudo"] = 5

  var["help"]["sudo"] = "Run a command without timer limitation"
  var["usage"]["sudo"] = "<cmd> [<args>]"
}

function _sudo(str) {
  # set sudo flag
  var["system"]["sudo"] = 1

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

  # run new command (as long as it is not sudo again..)
  alias()
  if (var["irc"]["cmd"] != "sudo")
    command()

  # unset sudo flag
  var["system"]["sudo"] = 0
}
