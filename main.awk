BEGIN {
  srand()
  PROCINFO["sorted_in"]   = "cmp_idx"

  # define debug levels
  debug[6] = "OMG!"
  debug[5] = "DEBUG"
  debug[4] = "INFO"
  debug[3] = "LOG"
  debug[2] = "WARN"
  debug[1] = "ERROR"
  debug[0] = "CRIT"

  # Index Separator
  var["IS"] = "."
  var["config"]["locale"] = ENVIRON["LANG"]

  var["config"]["debuglvl"] = 6
  #var["config"]["debugfnc"] = "loadConfig,tokenize"

  ## load different configs
  loadIni(cfg?cfg:"config.ini")

  ## read "actions" file
  var["system"]["actions"] = tokenize("actions.cfg")

  # create empty mimic array
  loadArray("mimic.dat")
  var["mimic"]["__placeholder__"] = ""
  delete var["mimic"]["__placeholder__"]

  ## define IRC server connection
  var["system"]["ircd"] = "/inet/tcp/0/" var["config"]["host"] "/" var["config"]["port"]

  # send password if configured
  if ("password" in var["config"]) {
    send("PASS " var["config"]["password"])
  }

  ## wait for connection to be established
  var["system"]["startup"] = systime()
  if (recv() <= 0) {
    dbg(0, "main", sprintf("Failed to establish connection to %s:%s", var["config"]["host"], var["config"]["port"]))
    exit(-1)
  }

  ## login
  if ("nick" in var["config"]) {
    system("sleep 1")
    send("NICK " var["config"]["nick"])
  } else {
    dbg(0, "main", "Missing config item 'nick'")
    exit(-1)
  }
  if (("user" in var["config"]) && ("geco" in var["config"])) {
    system("sleep 1")
    send("USER " var["config"]["user"] " 8 * :" var["config"]["geco"])
  } else {
    dbg(0, "main", "Missing config item 'user' and/or 'geco'")
    exit(-1)
  }

  ## wait for login process to complete
  if (recv() <= 0) {
    dbg(0, "main", sprintf("Connection to %s:%s closed while logging in", var["config"]["host"], var["config"]["port"]))
    exit(-1)
  }

  ## join channels
  if ("channels" in var["config"]) {
    system("sleep 3")
    split(var["config"]["channels"], chan, ",")
    for (c in chan)
      send("JOIN " strip(chan[c]))
  }

  ## if gracetime is defined, set a grace period
  if ("gracetime" in var["config"]) {
    var["system"]["gracetime"] = systime() + var["config"]["gracetime"]
  }

  ## main loop
  while (recv() > 0) {
    var["system"]["then"] = var["system"]["now"]
    var["system"]["now"] = systime()

    ## utmost priority, respond to server PING commands
    if ($1 == "PING") {
      var["system"]["lastping"] = var["system"]["now"]
      send("PONG " $2)
      continue
    }

    ## ignore anything within grace period
    if (var["system"]["now"] <= var["system"]["gracetime"]) {
      dbg(3, "main", sprintf("gracetime ignore (%s < %s)", strftime("%T", var["system"]["now"]), strftime("%T", var["system"]["gracetime"])))
      continue
    }

    ## parse input data
    if (match($0, /^:([^ ]+) ([0-9A-Z]+) ([^ :]+)? ?:?(.*)$/, raw)) {
      var["irc"]["raw"] = $0
      parse(raw)
  
#      dbg(5, "main", sprintf("raw: \"%s\"", var["irc"]["raw"]))
#      dbg(6, "main", sprintf("user: %s [%s!%s@%s]", var["irc"]["user"], var["irc"]["nick"], var["irc"]["auth"], var["irc"]["host"]))
#      dbg(6, "main", sprintf("target: %s (channel: %s)", var["irc"]["target"], var["irc"]["channel"]))
#      dbg(6, "main", sprintf("action: %s", var["irc"]["action"]))
#      dbg(6, "main", sprintf("message: %s [%s (%s)]", var["irc"]["msg"], var["irc"]["cmd"], var["irc"]["args"]))
#      s = "words:"
#      for (w in var["irc"]["argv"]) s = s" "w":\""var["irc"]["argv"][w]"\""
#      dbg(6, "main", sprintf("%s", s))

      # handle commands
      if (var["irc"]["cmd"] && var["irc"]["target"]) {
        # process aliasses first
        alias()

        # then internal commands
        if (command()) continue

        # finally oneliners (if no command was found)
        out = _onelinerAction(var["irc"]["cmd"])
        if (out) {
          msg(vsub(out))
          continue
        }
      }

      # handle non-commands
      if (!var["irc"]["cmd"] && var["irc"]["channel"]) {
        # handle configured actions
        action()

        # add text to mimic library
        mimicAddLine(var["irc"]["msg"])
      }
    }
  }

  ## connection terminated
  close(var["system"]["ircd"])
  printf("main(): Connection to %s:%s closed\n", var["config"]["host"], var["config"]["port"])
  printf("main(): Startup %s\n", strftime("%a, %b %d at %T", var["system"]["startup"]) )
  printf("main(): Last ping %s\n", strftime("%a, %b %d at %T", var["system"]["lastping"]) )
  printf("main(): Now %s\n", strftime("%a, %b %d at %T",systime()) )
  exit(0)
}

