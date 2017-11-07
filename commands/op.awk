BEGIN {
  var["commands"]["op"] = "cmd"
  var["permissions"]["op"] = "admin|oper|friend"
  var["timers"]["op"] = 5

  var["aliases"]["hulde"] = "op"

  var["help"]["op"] = "Give chanop to the requester"
  var["usage"]["op"] = ""
}

function _op(str,    cnt, arr, mode) {
  if (str) {
    cnt = split(str, arr, " ")
    mode = "+"
    for (i=1; i<=cnt; i++) mode = mode "o"
    send(sprintf("mode %s %s %s", var["irc"]["target"], mode, str))
  } else send(vsub("MODE $T +o $N"))
}
