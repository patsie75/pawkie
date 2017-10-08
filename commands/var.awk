function var_list(arr, _1, _2,   str, idx) { str = ""; for (idx in arr) str = str?str" "idx:idx; return(str) }
function var_get(arr, idx, _2) { if (idx in arr) return(arr[idx]); else return("<undefined>") }
function var_set(arr, idx, value) { return(arr[idx] = value) }
function var_add(arr, idx, value) { return(arr[idx] = arr[idx] " " value) }
function var_del(arr, idx, value,   i, tmp) {
  if (value != "") {
    split(arr[idx], tmp, " ")
    arr[idx] = ""

    for (i in tmp)
      if (value !~ tmp[i])
        arr[idx] = arr[idx]?arr[idx]" "tmp[i]:tmp[i]

    return(arr[idx])
  } else {
    delete arr[idx]
    return("<empty>")
  }
}

BEGIN {
  commands["var"] = "cmd"
  permissions["var"] = "admin|oper"
  timers["var"] = 5

  help["var"] = "shows or modifies system variables"
  usage["var"][1] = "list <group> (list keys in a group)"
  usage["var"][2] = "get <group> <key> (show value of key in group)"
  usage["var"][3] = "set <group> <key> <value> (modify key in group to value)"
  usage["var"][4] = "del <group> <key> (deletes key from group)"
  
  split("list get set add del", _var_types, " ")
}

function _var(args,    argc, argv, call, value) {
  dbg(5, "_var", sprintf("args: \"%s\"", args))
  argc = split(args, argv, " ")

  if (argc >= 2) {
    if (inArray(argv[1], _var_types)) {
      call = "var_" argv[1]
      dbg(4, "_var", sprintf("calling function %s(%s, %s, %s)", call, argv[2], argv[3], argv[4]))

      switch( substr(argv[2],1,3) ) {
        case "cfg":
        case "con": value = @call(config, argv[3], argv[4]); break
        case "grp":
        case "gro": value = @call(groups, argv[3], argv[4]); break
        case "prm":
        case "per": value = @call(permissions, argv[3], argv[4]); break
        case "sv":
        case "sys": value = @call(sysvar, argv[3], argv[4]); break
        case "cmd":
        case "com": value = @call(commands, argv[3], argv[4]); break
        case "tmr":
        case "tim": value = @call(timers, argv[3], argv[4]); break
        default: send(ircd, vsub(sprintf("PRIVMSG $T :Unknown config \"%s\"", argv[2])))
      }
      send(ircd, vsub(sprintf("PRIVMSG $T :%s[%s] = %s", argv[2], argv[3], value?value:"<empty>")))

    } else dbg(2, "_var", sprintf("Unknown function var_%s(%s, %s, %s)", argv[1], argv[2], argv[3], argv[4]))
  } else dbg(2, "_var", sprintf("Too few arguments (#%d < 2)", argc))

}
