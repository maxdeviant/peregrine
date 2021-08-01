module Examples.Routing where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Peregrine (Handler, choose)
import Peregrine as Peregrine
import Peregrine.Http.Headers (staticHeaderName)
import Peregrine.Http.Method (Method(..))
import Peregrine.Response as Response
import Peregrine.Routing (header, method, path, pathPrefix)
import Type.Proxy (Proxy(..))

makeUserHandler :: String -> Handler
makeUserHandler title _req =
  pure
    $ Just
    $ Response.ok
    # Response.withBody title

listUsers :: Handler
listUsers = makeUserHandler "List Users"

createUser :: Handler
createUser = makeUserHandler "Create User"

getUser :: Handler
getUser = makeUserHandler "Get User"

updateUser :: Handler
updateUser = makeUserHandler "Update User"

deleteUser :: Handler
deleteUser = makeUserHandler "Delete User"

usersController :: Handler
usersController =
  choose
    [ path ""
        $ choose
            [ method Get listUsers
            , method Post createUser
            ]
    , path "/:id"
        $ choose
            [ method Get getUser
            , method Put updateUser
            , method Delete deleteUser
            ]
    ]

data Team
  = Red
  | Blu

instance showTeam :: Show Team where
  show Red = "RED"
  show Blu = "BLU"

secretArea :: Handler
secretArea =
  secretHeaderGuard \team _req -> do
    let
      message = "Welcome to the secret area, " <> show team <> " Spy."
    pure
      $ Just
      $ Response.ok
      # Response.withBody message
  where
  secretHeader = staticHeaderName (Proxy :: Proxy "X-Secret-Code")

  teamFromCode = case _ of
    "RED" -> Just Red
    "BLU" -> Just Blu
    _ -> Nothing

  secretHeaderGuard = header secretHeader teamFromCode

app :: Handler
app =
  choose
    [ secretArea
    , pathPrefix "/users" usersController
    ]

main :: Effect (Effect Unit -> Effect Unit)
main =
  Peregrine.fly app do
    log "Peregrine server listening at http://localhost:3000"
