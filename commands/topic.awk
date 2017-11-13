BEGIN {
  var["commands"]["topic"] = "cmd"
  var["permissions"]["topic"] = "admin|oper|friend"
  var["timers"]["topic"] = 300

  var["help"]["topic"] = "Change topic on a channel"
  var["usage"]["topic"] = "<new topic>"
}

function _topic(str) {
  if (str) send(vsub("TOPIC $T :(\002$N\002) "str))
  else return("I need to be told a new topic")
}
