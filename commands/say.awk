BEGIN {
  commands["say"] = "cmd"
  permissions["say"] = "admin|oper"
  timers["say"] = 5

  help["say"] = "Say a message to either a person or channel"
  usage["say"] = "say <target> <msg>"
}

function _say(str,   target, msg) {
  if (str ~ /^(#|&))/) {
    target = substr(str, 1, index(str, " ")-1)
    msg = substr(str, index(str, " ")+1)
  } else {
    target = var["target"]
    msg = str
  }

  send(ircd, vsub(sprintf("PRIVMSG %s :%s", target, msg)))
}

