mode = ScriptMode.Verbose

packageName   = "bearssl"
version       = "0.2.2"
author        = "Status Research & Development GmbH"
description   = "BearSSL wrapper"
license       = "MIT or Apache License 2.0"
skipDirs      = @["tests"]

requires "nim >= 1.6.0",
         "unittest2 >= 0.0.5 & <= 0.1.0"

let nimc = getEnv("NIMC", "nim") # Which nim compiler to use
let lang = getEnv("NIMLANG", "c") # Which backend (c/cpp/js)
let flags = getEnv("NIMFLAGS", "") # Extra flags for the compiler
let verbose = getEnv("V", "") notin ["", "0"]

let cfg =
  " --styleCheck:usages --styleCheck:error" &
  (if verbose: "" else: " --verbosity:0 --hints:off") &
  " --skipParentCfg --skipUserCfg --outdir:build --nimcache:build/nimcache -f"

proc build(args, path: string) =
  exec nimc & " " & lang & " " & cfg & " " & flags & " " & args & " " & path

proc run(args, path: string) =
  build args & " -r", path

import strutils

task test, "Run tests":
  for path in listFiles("tests"):
    if not path.endsWith ".nim": continue

    for args in [
      "-d:debug",
      "-d:release",
    ]: run args, path
