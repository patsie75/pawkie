BEGIN {
  var["commands"]["leave"] = "cmd"
  var["permissions"]["leave"] = "admin|oper"
  var["timers"]["leave"] = 60

  var["aliases"]["part"] = "leave"

  var["help"]["leave"] = "Leave a channel"
  var["usage"]["leave"] = "<channel>"
}

function _leave(str) {
  if (str) send("PART " str)
  else return("I need to be told a channel to leave")
}
