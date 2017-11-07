BEGIN {
  var["commands"]["say"] = "cmd"
  var["permissions"]["say"] = "admin|oper"
  var["timers"]["say"] = 5

  var["help"]["say"] = "Say a message to either a person or channel"
  var["usage"]["say"] = "<target> <msg>"
}

function _say(str,   target, msg) {
  if (str ~ /^(#|&))/) {
    target = substr(str, 1, index(str, " ")-1)
    msg = substr(str, index(str, " ")+1)
  } else {
    target = var["irc"]["target"]
    msg = str
  }

  send(vsub(sprintf("PRIVMSG %s :%s", target, msg)))
}

