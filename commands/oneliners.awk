BEGIN {
  var["commands"]["oneliners"] = "cmd"
  var["permissions"]["oneliners"] = "admin|oper"
  var["timers"]["oneliners"] = 5

  var["help"]["oneliners"] = "oneliners help"
  var["usage"]["oneliners"] = "oneliners [add|del] <oneliner>"

  var["commands"]["onelineraction"] = "cmd"
  #var["permissions"]["onelineraction"] = "bot"
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
        var["config"]["oneliners"] = var["config"]["oneliners"] " " args
        reply = "Added oneliner \""args"\""
      } else reply = "Failed to add oneliner \""args"\""
    break

    case "del":
    case "delete":
      split(var["config"]["oneliners"], arr, " ")
      if (inArray(args, arr)) {
        var["config"]["oneliners"] = ""
        for (i in arr)
          if (arr[i] != args)
            var["config"]["oneliners"] = var["config"]["oneliners"] ? var["config"]["oneliners"] " " arr[i] : arr[i]
        reply = "Removed oneliner \""args"\""
      } else reply = "No such oneliner \""args"\""
    break

    default:
      split(var["config"]["oneliners"], arr, " ")
      for (i in arr)
        reply = "!" arr[i] " " reply

      if (reply) return("Try one of: " reply)
      else return("No oneliners are available at this moment")
  }

  if (reply) return(reply)
}


function _onelinerAction(cmd,   arr, i, time, trgt) {
  dbg(5, "onelinerAction", sprintf("cmd: \"%s\"", cmd))
  split(var["config"]["oneliners"], arr, " ")

  time = 0
  # commands have minimum interval between runs
  if ("onelineraction" in var["timers"]) {
    trgt = tolower("onelineraction,"var["irc"]["target"])
    if (systime() >= var["timer"][trgt]) {
      var["timer"][trgt] = systime() + var["timers"]["onelineraction"]
      time = 1
    }
  } else time = 1

  if (time) {
    for (i in arr) {
      if (cmd == arr[i]) {
        dbg(5, "onelinerAction", sprintf("found match for cmd: \"%s\"", cmd))
        if (!data[cmd,0]) loadText(cmd)
        rnd = int(rand() * data[cmd,0]) + 1
        dbg(5, "onelinerAction", sprintf("responding: \"%s\"", data[cmd,rnd]))
        return(data[cmd,rnd])
      }
    }
    dbg(5, "onelinerAction", sprintf("cmd: \"%s\" not found", cmd))
  }
  dbg(4, "onelineraction", sprintf("timer[%s] %s has not yet passed %s", trgt, strftime("%T"), strftime("%T", var["timer"][trgt])))
}

