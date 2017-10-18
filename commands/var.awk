BEGIN {
  var["commands"]["var"] = "cmd"
  var["permissions"]["var"] = "admin"

  var["aliases"]["get"] = "var get"
  var["aliases"]["set"] = "var set"
  var["aliases"]["del"] = "var del"

  var["help"]["var"] = "shows or modifies system variables"
  var["usage"]["var"][2] = "get <key1>[\".\"<key2>[\".\"<etc>]] (show value of key)"
  var["usage"]["var"][3] = "set <key1>[\".\"<key2>[\".\"<etc>]] <value> (modify key to value)"
  var["usage"]["var"][4] = "del <key1>[\".\"<key2>[\".\"<etc>]] (deletes key)"
}


function listArray(arr,   result, key) {
  if (isarray(arr)) {
    result = ""
    for (key in arr)
      # arrays are added as "[array]" scalars as "scalar"
      if (isarray(arr[key])) result = result?result", ["key"]":"["key"]"
      else result = result?result", "key:key
    return("[ "result" ]")
  } else return("<no array>")
}

function getValue(arr, keys,   k1, k2) {
  # k1 is first key, k2 is rest (key1.key2.key3.etc)
  # k1 is empty and k2 set with only 1 key (key1)
  k1 = substr(keys, 1, index(keys, ".")-1)
  k2 = substr(keys, index(keys, ".")+1)

  if (k1) {
    # itterate over all keys
    if (isarray(arr)) {
      if (k1 in arr) {
        if (isarray(arr[k1])) return(getValue(arr[k1], k2))
        else return("<\""k1"\" is scalar>")
      } else return("<invalid key \""k1"\">")
    } else return("<no array>")
  } else {
    # display value of final key
    if (isarray(arr)) {
      if (k2 in arr) {
        if (isarray(arr[k2])) return(listArray(arr[k2]))
        else return(arr[k2])
      } else return("<invalid key \""k2"\">")
    } else return("<\""k2"\" is scalar>")
  }
} 

function setValue(arr, keys, value,   k1, k2, v) {
  # k1 is first key, k2 is rest (key1.key2.key3.etc)
  # k1 is empty and k2 set with only 1 key (key1)
  k1 = substr(keys, 1, index(keys, ".")-1)
  k2 = substr(keys, index(keys, ".")+1)

  if (k1) {
    # itterate over all keys
    if (isarray(arr)) {
      if (k1 in arr) {
        if (isarray(arr[k1])) return(setValue(arr[k1], k2, value))
        else return("<\""k1"\" is scalar>")
      } else {
        # key does not exist yet, create temp array,
        # assign value and destroy temp value
        arr[k1]["__placeholder__"] = ""
        v = setValue(arr[k1], k2, value)
        delete arr[k1]["__placeholder__"]
        return(v)
      }
    } else return("<no array>")
  } else {
    # set value of final key
    if (isarray(arr)) {
      if (isarray(arr[k2])) return("<\""k2"\" is array>")
      else return(arr[k2]=value)
    } else return("<\""k2"\" is scalar>")
  }
}

function delValue(arr, keys,   k1, k2) {
  # k1 is first key, k2 is rest (key1.key2.key3.etc)
  # k1 is empty and k2 set with only 1 key (key1)
  k1 = substr(keys, 1, index(keys, ".")-1)
  k2 = substr(keys, index(keys, ".")+1)

  if (k1) {
    # itterate over all keys
    if (isarray(arr)) {
      if (k1 in arr) {
        if (isarray(arr[k1])) return(delValue(arr[k1], k2))
        else return("<\""k1"\" is scalar>")
      } else return("<invalid key \""k1"\">")
    } else return("<no array>")
  } else {
    # delete final key
    if (k2 in arr) { delete arr[k2]; return("<deleted>") }
    else return("<invalid key \""k2"\">")
  }
}

function _var(args,    argc, argv) {
  dbg(5, "var", sprintf("args: \"%s\"", args))
  argc = split(args, argv, " ")

  if (argc >= 2) {
    switch(argv[1]) {
      case "get": return(sprintf("%s = %s", argv[2], getValue(var, argv[2])))
      case "set": return(sprintf("%s = %s", argv[2], setValue(var, argv[2], argv[3])))
      case "del": 
        if ((argv[2] != "config") && (argv[2] != "system"))
          return(sprintf("%s = %s", argv[2], delValue(var, argv[2])))
        else return("Sorry, I will not selfdestruct")
      default: return("Unknown option: "argv[1])
    }
  } else dbg(2, "var", sprintf("Too few arguments (#%d < 2)", argc))
}
