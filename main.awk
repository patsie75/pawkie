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

  var["config"]["debuglvl"] = 6
  #var["config"]["debugfnc"] = "loadConfig,tokenize"

  ## load different configs
  mergeArray(cfg?cfg:"config.cfg")
  mergeArray("plugins.cfg")
  mergeArray("groups.cfg")
  mergeArray("commands.cfg")
  mergeArray("permissions.cfg")
  mergeArray("timers.cfg")
  loadArray("mimic.dat")

  ## read "actions" file
  var["system"]["actions"] = tokenize("actions.cfg")

  ## define IRC server connection
  var["system"]["ircd"] = "/inet/tcp/0/" var["config"]["host"] "/" var["config"]["port"]

  ## wait for connection to be established
  var["system"]["startup"] = systime()
  if (recv(var["system"]["ircd"]) <= 0) {
    dbg(0, "main", sprintf("Failed to establish connection to %s:%s", var["config"]["host"], var["config"]["port"]))
    exit(-1)
  }

  ## login
  system("sleep 1"); send(var["system"]["ircd"], "NICK " var["config"]["nick"])
  system("sleep 1"); send(var["system"]["ircd"], "USER " var["config"]["user"] " 8 * :" var["config"]["geco"])

  ## wait for login process to complete
  if (recv(var["system"]["ircd"]) <= 0) {
    dbg(0, "main", sprintf("Connection to %s:%s closed while logging in", var["config"]["host"], var["config"]["port"]))
    exit(-1)
  }

  ## join channels
  if (var["config"]["channels"]) {
    system("sleep 3")
    split(var["config"]["channels"], chan, ",")
    for (c in chan)
      send(var["system"]["ircd"], "JOIN " strip(chan[c]))
  }

  ## main loop
  while (recv(var["system"]["ircd"]) > 0) {
    var["system"]["then"] = var["system"]["now"]
    var["system"]["now"] = systime()

    ## utmost priority, respond to server PING commands
    if ($1 == "PING") {
      var["system"]["lastping"] = var["system"]["now"]
      send(var["system"]["ircd"], "PONG " $2)
      continue
    }

    # :user@auth@host ACTION [target] [:]message
    # :Patsie!patsie@patsie.nl NICK :Petsie

    if (match($0, /^:([^ ]+) ([0-9A-Z]+) ([^ ]+)? ?:?(.*)$/, raw)) {
      # parse input data
      var["irc"]["raw"] = $0
      parse(raw)
  
#      dbg(4, "main", sprintf("raw: \"%s\"", var["irc"]["raw"]))
#      dbg(5, "main", sprintf("user: %s [%s!%s@%s]", var["irc"]["user"], var["irc"]["nick"], var["irc"]["auth"], var["irc"]["host"]))
#      dbg(5, "main", sprintf("target: %s", var["irc"]["target"]))
#      dbg(5, "main", sprintf("action: %s", var["irc"]["action"]))
#      dbg(5, "main", sprintf("message: %s [%s (%s)]", var["irc"]["msg"], var["irc"]["cmd"], var["irc"]["args"]))
#      s = "words:"
#      for (w in var["irc"]["argv"]) s = s" "w":\""var["irc"]["argv"][w]"\""
#      dbg(5, "main", sprintf("%s", s))

      # process aliasses first
      alias()

      # handle internal commands next
      if (command()) continue

      # handle configured actions
      action()

      # handle oneliners
      if (var["irc"]["cmd"] && var["irc"]["channel"]) {
        out = _onelinerAction(var["irc"]["cmd"])
        if (out) {
          if (out ~ /^ACTION/)
            send(var["system"]["ircd"], vsub(sprintf("PRIVMSG $T :\001%s\001", out)))
          else
            send(var["system"]["ircd"], vsub(sprintf("PRIVMSG $T :%s", out)))
        }
      }

      # Add text to mimic library
      if (!var["irc"]["cmd"] && var["irc"]["channel"]) {
        mimicAddLine(mimic, var["irc"]["msg"])
        var["system"]["mimiccnt"]++
        if (var["system"]["mimiccnt"] % 100 == 0) {
          mimicCleanup()
          var["system"]["mimiccnt"] = 0
        }
        if (var["system"]["mimiccnt"] % 10 == 0)
          saveArray("mimic.dat")
      }
    }
  }

  ## connection terminated
  close(var["system"]["ircd"])
  printf("main(): Connection to %s:%s closed\n", var["config"]["host"], var["config"]["port"])
  printf("main(): Startup %s\n", strftime("%a, %b %d at %T", var["system"]["startup"]) )
  printf("main(): Last ping %s\n", strftime("%a, %b %d at %T", var["system"]["lastping"]) )
  printf("main(): Now %s\n", strftime("%a, %b %d at %T",systime()) )
  exit(-1)
}
