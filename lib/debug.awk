## prints a timestamped message if the configured debug level is high enough
## Usage: dbg(4, "callingFunction", "message")
function dbg(level, fnc, msg,   fncs) {
  # only debug functions configured in config["debugfnc"]
  if ("debugfnc" in var["config"]) {
    # ! negates the debugfnc list
    if ( substr(var["config"]["debugfnc"], 1, 1) == "!" ) {
      negate = 1
      split(tolower(substr(var["config"]["debugfnc"], 2)), fncs, ",")
    } else {
      negate = 0
      split(tolower(var["config"]["debugfnc"]), fncs, ",")
    }

    if (negate) {
      if ( (var["config"]["debuglvl"] >= level) && ! inArray(tolower(fnc), fncs) )
        printf("[%s] %-5s: %s(): %s\n", strftime("%T"), debug[level], fnc, msg)
    } else {
      if ( (var["config"]["debuglvl"] >= level) && inArray(tolower(fnc), fncs) )
        printf("[%s] %-5s: %s(): %s\n", strftime("%T"), debug[level], fnc, msg)
    }
  } else {
    # if no config["debugfnc"] is defined do everything
    if (var["config"]["debuglvl"] >= level)
      printf("[%s] %-5s: %s(): %s\n", strftime("%T"), debug[level], fnc, msg)
  }
}

