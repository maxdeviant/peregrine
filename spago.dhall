{ name = "peregrine"
, license = "MIT"
, repository = "https://github.com/maxdeviant/peregrine"
, dependencies =
  [ "console", "effect", "maybe", "node-http", "prelude", "psci-support" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
