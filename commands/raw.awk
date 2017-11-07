BEGIN {
  var["commands"]["raw"] = "cmd"
  var["permissions"]["raw"] = "admin"
  var["timers"]["raw"] = 5

  var["help"]["raw"] = "Do a raw IRC command"
  var["usage"]["raw"] = "<raw command>"
}

function _raw(str) {
  send(vsub(str))
}

