BEGIN {
  commands["oneliners"] = "cmd"
  permissions["oneliners"] = "admin|oper"
  timers["oneliners"] = 5

  help["oneliners"] = "oneliners help"
  usage["oneliners"] = "oneliners [add|del] <oneliner>"

  commands["onelinerAction"] = "cmd"
  permissions["onelinerAction"] = "bot"
}


## return a list of oneliners configures (uses: config[])
function _oneliners(str,    reply, cmd, args, arr, i) {
  reply = ""
  cmd = substr(str, 1, index(str, " ")-1)
  args = substr(str, index(str, " ")+1)

  dbg(5, "oneliners", sprintf("cmd: \"%s\" args: \"%s\"", cmd, args))

  switch(cmd) {
    case "add":
      if (loadText(args)) {
        config["oneliners"] = config["oneliners"] " " args
        reply = "Added oneliner \""args"\""
      } else reply = "Failed to add oneliner \""args"\""
    break

    case "del":
    case "delete":
      split(config["oneliners"], arr, " ")
      if (inArray(args, arr)) {
        config["oneliners"] = ""
        for (i in arr)
          if (arr[i] != args)
            config["oneliners"] = config["oneliners"] ? config["oneliners"] " " arr[i] : arr[i]
        reply = "Removed oneliner \""args"\""
      } else reply = "No such oneliner \""args"\""
    break

    default:
      split(config["oneliners"], arr, " ")
      for (i in arr)
        reply = "!" arr[i] " " reply

      if (reply) return("Try one of: " reply)
      else return("No oneliners are available at this moment")
  }

  if (reply) return(reply)
}


function _onelinerAction(cmd,   arr, i) {
  split(config["oneliners"], arr, " ")

  for (i in arr) {
    if (cmd == arr[i]) {
      if (!data[cmd,0]) loadText(cmd)
      rnd = int(rand() * data[cmd,0]) + 1
      return(data[cmd,rnd])
    }
  }
}

