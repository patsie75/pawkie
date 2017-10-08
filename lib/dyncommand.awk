# tries to execute a script and return the results
function dyncommand(plugin, script, message, output,   nrlines, dyndir, exec, maxlines) {
  nrlines = 0;
  # is dyndir absolute or relative
  dyndir = config["dyndir"] ? config["dyndir"] : "./dyn"

  dbg(4, "dyncommand", sprintf("plugin: \"%s\", script: \"%s\", message: \"%s\"", plugin, script, message))
  # check if plugin and script are configured and exist
  if ( (plugin in plugins) && exists(dyndir"/"script) ) {
    exec = sprintf(plugins[plugin], dyndir"/"script, reconfig())

    # execute plugin
    dbg(5, "dyncommand", sprintf("print \"%s\" |& \"%s\"", message, exec))
    print message |& exec
    close(exec, "to")

    # read a configured maximum output lines
    maxlines = config["dynmaxlines"] ? config["dynmaxlines"] : 3
    while ( ((exec |& getline) > 0) && (nrlines < maxlines) ) {
      nrlines++
      output[nrlines] = $0
      dbg(5, "dyncommand", sprintf("#%d \"%s\"", nrlines, output[nrlines]))
    }
    close(exec)
  }

  dbg(4, "dyncommand", sprintf("nrlines: %d", nrlines))
  return(nrlines)
}

