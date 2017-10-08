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

  config["debuglvl"] = 5
  #config["debugfnc"] = "loadConfig,tokenize"

  ## load different configs
  mergeArray(cfg?cfg:"config.cfg", config)
  mergeArray("plugins.cfg", plugins)
  mergeArray("groups.cfg", groups)
  mergeArray("commands.cfg", commands)
  mergeArray("permissions.cfg", permissions)
  mergeArray("timers.cfg", timers)
  loadArray("mimic.dat", mimic)

  ## read "actions" file
  sysvar["actions"] = tokenize("actions", actions)

  ## define IRC server connection
  ircd = "/inet/tcp/0/" config["host"] "/" config["port"]

  ## wait for connection to be established
  sysvar["startup"] = systime()
  if (recv(ircd) <= 0) {
    dbg(0, "main", sprintf("Failed to establish connection to %s:%s", config["host"], config["port"]))
    exit(-1)
  }

  ## login
  system("sleep 1"); send(ircd, "NICK " config["nick"])
  system("sleep 1"); send(ircd, "USER " config["user"] " 8 * :" config["geco"])

  ## wait for login process to complete
  if (recv(ircd) <= 0) {
    dbg(0, "main", sprintf("Connection to %s:%s closed while logging in", config["host"], config["port"]))
    exit(-1)
  }

  ## join channels
  if (config["channels"]) {
    system("sleep 3")
    split(config["channels"], chan, ",")
    for (c in chan)
      send(ircd, "JOIN " strip(chan[c]))
  }

  ## main loop
  while (recv(ircd) > 0) {
    sysvar["then"] = sysvar["now"]
    sysvar["now"] = systime()

    ## utmost priority, respond to server PING commands
    if ($1 == "PING") {
      sysvar["lastping"] = sysvar["now"]
      send(ircd, "PONG " $2)
      continue
    }

    # :user@auth@host ACTION [target] [:]message
    # :Patsie!patsie@patsie.nl NICK :Petsie

    if (match($0, /^:([^ ]+) ([0-9A-Z]+) ([^ ]+)? ?:?(.*)$/, raw)) {
      var["raw"] = $0
      parse(raw)
  
#      dbg(4, "main", sprintf("raw: \"%s\"", var["raw"]))
#      dbg(5, "main", sprintf("user: %s [%s!%s@%s]", var["user"], var["nick"], var["auth"], var["host"]))
#      dbg(5, "main", sprintf("target: %s", var["target"]))
#      dbg(5, "main", sprintf("action: %s", var["action"]))
#      dbg(5, "main", sprintf("message: %s [%s (%s)]", var["msg"], var["cmd"], var["args"]))
#      s = "words:"
#      for (w in varargs) s = s" "w":\""varargs[w]"\""
#      dbg(5, "main", sprintf("%s", s))

      # handle internal commands first
      command()

      # handle configured actions
      action()

      # handle oneliners
      if (var["cmd"] && var["channel"]) {
        msg = _onelinerAction(var["cmd"])
        if (msg) {
          if (msg ~ /^ACTION/)
            send(ircd, vsub(sprintf("PRIVMSG $T :\001%s\001", msg)))
          else
            send(ircd, vsub(sprintf("PRIVMSG $T :%s", msg)))
        }
      }

      # Add text to mimic library
      if (!var["cmd"] && var["channel"]) {
        mimicAddLine(mimic, var["msg"])
        sysvar["mimiccnt"]++
        if (sysvar["mimiccnt"] % 100 == 0) {
          mimicCleanup()
          sysvar["mimiccnt"] = 0
        }
        if (sysvar["mimiccnt"] % 10 == 0)
          saveArray("mimic.dat", mimic)
      }
    }
  }

  ## connection terminated
  close(ircd)
  printf("main(): Connection to %s:%s closed\n", config["host"], config["port"])
  printf("main(): Startup %s\n", strftime("%a, %b %d at %T", sysvar["startup"]) )
  printf("main(): Last ping %s\n", strftime("%a, %b %d at %T", sysvar["lastping"]) )
  printf("main(): Now %s\n", strftime("%a, %b %d at %T",systime()) )
  exit(-1)
}

