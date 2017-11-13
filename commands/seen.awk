BEGIN {
  var["commands"]["seen"] = "cmd"
  var["permissions"]["seen"] = "admin|oper|friend"
  var["timers"]["seen"] = 60

  var["help"]["seen"] = "Tell when a person has been seen last"
  var["usage"]["seen"] = "<nick>[!<auth>@<host>]"
}

function timeago(epoch,   now) {
  now = var["system"]["now"]

  days = int( (now-epoch)/3600/24 )
  hrs = int( (now-epoch)/24%3600 )
  mins = int( (now-epoch)/60%60 )
  secs = int( (now-epoch)%60 )
}

function _seen(str,   user, usr, u, time) {
  time = 0
  usr = tolower(str)

  dbg(5, "seen", "Searching for user: "usr)
  for (user in var["seen"]) {
    dbg(6, "seen", "checking user: "user)
    if (user ~ usr) {
      dbg(5, "seen", " match user ("usr" ~ "user")")
      if (var["seen"][user] > time) {
        split(user, u, "!")
        dbg(5, "seen", " timestamp ("var["seen"][user]" > "time")")
        time = var["seen"][user]
      }
    }
  }

  if (time) {
    return(sprintf("I have seen %s here last at %s (%s days and %s hours ago) under the alias of %s", u[1], strftime("%a, %b %d %Y at %T", time), (var["system"]["now"]-time)/3600/24, (var["system"]["now"]-time)%3600, u[2]))
  } else return("I have not seen anybody with that name around here")
}

