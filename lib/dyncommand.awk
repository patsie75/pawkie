# tries to execute a script and return the results
function dyncommand(plugin, script, message, output,   nrlines, dyndir, exec, maxlines) {
  nrlines = 0;
  # is dyndir absolute or relative
  dyndir = var["config"]["dyndir"] ? var["config"]["dyndir"] : "./dyn"

  dbg(4, "dyncommand", sprintf("plugin: \"%s\", script: \"%s\", message: \"%s\"", plugin, script, message))
  # check if plugin and script are configured and exist
  if ( (plugin in var["plugins"]) && exists(dyndir"/"script) ) {
    exec = sprintf(var["plugins"][plugin], dyndir"/"script, reconfig())

    # execute plugin
    dbg(5, "dyncommand", sprintf("print \"%s\" |& \"%s\"", message, exec))
    print message |& exec
    close(exec, "to")

    # read a configured maximum output lines
    maxlines = var["config"]["dynmaxlines"] ? var["config"]["dynmaxlines"] : 3
    while ( ((exec |& getline) > 0) && (nrlines < maxlines) ) {
      nrlines++
      output[nrlines] = vsub($0)
      dbg(5, "dyncommand", sprintf("#%d \"%s\"", nrlines, output[nrlines]))
    }
    close(exec)
  }

  dbg(5, "dyncommand", sprintf("nrlines: %d", nrlines))
  return(nrlines)
}

