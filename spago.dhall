{ name = "peregrine"
, license = "MIT"
, repository = "https://github.com/maxdeviant/peregrine"
, dependencies =
  [ "aff"
  , "console"
  , "effect"
  , "either"
  , "foldable-traversable"
  , "maybe"
  , "newtype"
  , "node-buffer"
  , "node-http"
  , "node-streams"
  , "ordered-collections"
  , "prelude"
  , "psci-support"
  , "strings"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
