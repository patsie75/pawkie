<?php
if (!empty($_GET)) {
  //$fname = basename(key($_GET), '.awk');

  if (in_array(pathinfo(key($_GET), PATHINFO_DIRNAME), array('.', 'config', 'commands', 'lib')))
    //$fname = pathinfo(key($_GET), PATHINFO_DIRNAME) . "/" . pathinfo(key($_GET), PATHINFO_FILENAME);
    $fname = pathinfo(key($_GET), PATHINFO_DIRNAME) . "/" . pathinfo(key($_GET), PATHINFO_BASENAME);
    $fname = str_replace("_", ".", $fname);

  echo <<< EOT1
<!DOCTYPE html>
<html lang="en">
<head>
 <meta charset="utf-8"/>
 <title>$fname</title>
 <style type="text/css" media="screen">
    #editor { 
        position: absolute;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;
    }
 </style>
</head>

<body>
 <script src="https://ace.patsie.nl/ace.js" type="text/javascript" charset="utf-8"></script>
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
 <div id="editor"></div>
 <script>
    var editor = ace.edit("editor");
    editor.setTheme("ace/theme/monokai");
    editor.getSession().setMode("ace/mode/sh");
    $.get('$fname', function(data) {
        editor.setValue(data);
        editor.gotoLine(0, 0);
        editor.setReadOnly(true);
    });
 </script>
</body>
</html>
EOT1;
} else {
  foreach (glob("{,config/,commands/,lib/}*.{awk,cfg}", GLOB_BRACE) as $filename) {
    //$bname = basename($filename, '.awk');
    //$bname = str_replace("./", "", pathinfo($filename, PATHINFO_DIRNAME) . "/" . pathinfo($filename, PATHINFO_FILENAME));
    $bname = str_replace("./", "", pathinfo($filename, PATHINFO_DIRNAME) . "/" . pathinfo($filename, PATHINFO_BASENAME));
    $list = $list .  "\n <li><a href=\"?" . $bname . "\">" . $bname . "</a><br>";
  }
  echo <<< EOT2
<!DOCTYPE html>
<html lang="en">
<head>
 <meta charset="utf-8"/>
 <title>Scripts</title>
</head>

<body>
 <h4>List of scripts</h4>
 <ul>$list
</ul>
</body>
</html>
EOT2;
}

