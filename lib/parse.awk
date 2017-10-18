## parse 'raw' output to usable var[]
#[18:44:45] < :Patsie!patsie@patsie.nl PRIVMSG #Pawkie :test
#[17:53:27] < :Patsie!patsie@patsie.nl TOPIC #Pawkie :test
#[17:54:31] < :Patsie!patsie@patsie.nl MODE #Pawkie +o Pawkie2
#[17:58:19] < :Patsie!patsie@patsie.nl JOIN :#Pawkie
#[17:55:12] < :Patsie!patsie@patsie.nl PART #Pawkie
#[17:47:22] < :Petsie!patsie@patsie.nl NICK :Patsie

function parse(raw,   i, usr, varargs) {
  for (i in raw)
    dbg(6, "parse", sprintf("raw[%s] = \"%s\"", i, raw[i]))

  var["irc"]["user"] = raw[1] ? raw[1] : ""
  if (match(var["irc"]["user"], /:*(.+)!(.+)@(.+)/, usr)) {
    var["irc"]["nick"] = usr[1] ? usr[1] : ""
    var["irc"]["auth"] = usr[2] ? usr[2] : ""
    var["irc"]["host"] = usr[3] ? usr[3] : ""
  } else var["irc"]["nick"] = var["irc"]["auth"] = var["irc"]["host"] = ""

  var["irc"]["action"] = raw[2] ? raw[2] : ""
  switch(var["irc"]["action"]) {
    case "PRIVMSG":
    case "TOPIC":
    case "MODE":
      var["irc"]["target"] = (raw[3] ~ /^(#|&)/) ? raw[3] : var["irc"]["nick"]
      var["irc"]["msg"] = raw[4] ? raw[4] : ""
    break

    case "JOIN":
    case "PART":
    case "NICK":
      var["irc"]["target"] = (raw[4] ~ /^(#|&)/) ? raw[4] : var["irc"]["nick"]
      var["irc"]["msg"] = ""
    break

    default:
      var["irc"]["target"] = (raw[3] ~ /^(#|&)/) ? raw[3] : var["irc"]["nick"]
      var["irc"]["msg"] = raw[4] ? raw[4] : ""
  }

  var["irc"]["channel"] = (var["irc"]["target"] ~ /^(#|&)/) ? var["irc"]["target"] : ""

  # check if this is a command
  if (substr(var["irc"]["msg"], 1, 1) == var["config"]["cmdchar"]) {
    # do we have arguments?
    if ( (i=index(var["irc"]["msg"], " ")) > 0) {
      var["irc"]["cmd"] = substr(var["irc"]["msg"], 2, i-2)
      var["irc"]["args"] = substr(var["irc"]["msg"], i+1)
    } else {
      var["irc"]["cmd"] = substr(var["irc"]["msg"], 2)
      var["irc"]["args"] = ""
    }
  } else var["irc"]["cmd"] = var["irc"]["args"] = ""

  # split message into separate words varargs[]
  delete var["irc"]["argv"]
  var["irc"]["argc"] = split(var["irc"]["args"], varargs, " ")
  for (i in varargs) var["irc"]["argv"][i] = varargs[i]
}

