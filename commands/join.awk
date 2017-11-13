BEGIN {
  var["commands"]["join"] = "cmd"
  var["permissions"]["join"] = "admin|oper"
  var["timers"]["join"] = 60

  var["help"]["join"] = "Join a channel"
  var["usage"]["join"] = "<channel>"
}

function _join(str) {
  if (str) send("JOIN " str)
  else return("I need to be told a channel to join")
}
