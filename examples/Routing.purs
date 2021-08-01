module Examples.Routing where

import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Peregrine (Handler, choose)
import Peregrine as Peregrine
import Peregrine.Http.Headers as Headers
import Peregrine.Http.Method (Method(..))
import Peregrine.Http.Status as Status
import Peregrine.Response.Body as Body
import Peregrine.Routing (method, path, pathPrefix)

makeUserHandler :: String -> Handler
makeUserHandler title _req =
  pure
    $ Just
        { status: Just Status.ok
        , headers: Headers.empty
        , writeBody: Just $ Body.write title
        }

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

app :: Handler
app =
  choose
    [ pathPrefix "/users" usersController
    ]

main :: Effect (Effect Unit -> Effect Unit)
main =
  Peregrine.fly app do
    log "Peregrine server listening at http://localhost:3000"
