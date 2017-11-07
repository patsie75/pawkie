BEGIN {
  var["commands"]["nick"] = "cmd"
  var["permissions"]["nick"] = "admin|oper"
  var["timers"]["nick"] = 60

  var["help"]["nick"] = "Change my nickname"
  var["usage"]["nick"] = "<newnick>"
}

function _nick(str) {
  if (str) send("NICK " str)
  else send(vsub("PRIVMSG $T :What nick would you like me to take?"))
}
