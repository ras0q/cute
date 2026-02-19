# cute as standalone script
{
  writeScriptBin,
  gawk,
  gnused,
  ...
}:
writeScriptBin
"cute"
''
  #!/bin/sh -eu
  PATH="${gawk}/bin:${gnused}/bin:$PATH"
  . ${../cute} && cute $@
''
