BEGIN {
  var["commands"]["op"] = "cmd"
  var["permissions"]["op"] = "admin|oper|friend"
  var["timers"]["op"] = 5

  var["help"]["op"] = "Give chanop to the requester"
  var["usage"]["op"] = ""
}

function _op(str) {
  send(vsub("MODE $T :+o $N"))
}

