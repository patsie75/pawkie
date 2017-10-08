## parse 'raw' output to usable var[]
#[18:44:45] < :Patsie!patsie@patsie.nl PRIVMSG #Pawkie :test
#[17:53:27] < :Patsie!patsie@patsie.nl TOPIC #Pawkie :test
#[17:54:31] < :Patsie!patsie@patsie.nl MODE #Pawkie +o Pawkie2
#[17:58:19] < :Patsie!patsie@patsie.nl JOIN :#Pawkie
#[17:55:12] < :Patsie!patsie@patsie.nl PART #Pawkie
#[17:47:22] < :Petsie!patsie@patsie.nl NICK :Patsie

function parse(raw,   i) {
  for (i in raw)
    dbg(6, "parse", sprintf("raw[%s] = \"%s\"", i, raw[i]))

  var["user"] = raw[1] ? raw[1] : ""
  if (match(var["user"], /:*(.+)!(.+)@(.+)/, usr)) {
    var["nick"] = usr[1] ? usr[1] : ""
    var["auth"] = usr[2] ? usr[2] : ""
    var["host"] = usr[3] ? usr[3] : ""
  } else var["nick"] = var["auth"] = var["host"] = ""

  var["action"] = raw[2] ? raw[2] : ""
  switch(var["action"]) {
    case "PRIVMSG":
    case "TOPIC":
    case "MODE":
      var["target"] = (raw[3] ~ /^(#|&)/) ? raw[3] : var["nick"]
      var["msg"] = raw[4] ? raw[4] : ""
    break

    case "JOIN":
    case "PART":
    case "NICK":
      var["target"] = (raw[4] ~ /^(#|&)/) ? raw[4] : var["nick"]
      var["msg"] = ""
    break

    default:
      var["target"] = (raw[3] ~ /^(#|&)/) ? raw[3] : var["nick"]
      var["msg"] = raw[4] ? raw[4] : ""
  }

  var["channel"] = (var["target"] ~ /^(#|&)/) ? var["target"] : ""

  # check if this is a command
  if (substr(var["msg"], 1, 1) == config["cmdchar"]) {
    # do we have arguments?
    if ( (i=index(var["msg"], " ")) > 0) {
      var["cmd"] = substr(var["msg"], 2, i-2)
      var["args"] = substr(var["msg"], i+1)
    } else {
      var["cmd"] = substr(var["msg"], 2)
      var["args"] = ""
    }
  } else var["cmd"] = var["args"] = ""

  # split message into separate words varargs[]
  delete varargs
  split(var["args"], varargs, " ")
}

