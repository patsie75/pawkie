## split a string "cfg" of "key1=val1\001key2=val2\001..." into a config[] array
{
  split(cfg, arr, "\001")

  for (i in arr) {
    if (match(arr[i], /([^=]+)=(.+)/, keyval) > 0) {
      gsub(/^ *"?|"? *$/, "", keyval[1])
      gsub(/^ *"?|"? *$/, "", keyval[2])
      config[tolower(keyval[1])] = keyval[2]

      #printf("config[\"%s\"] = \"%s\"\n", tolower(keyval[1]), keyval[2])
    }
  }
}

