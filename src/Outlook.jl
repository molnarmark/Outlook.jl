module Outlook

using Requests: post, statuscode
using JSON

include("types.jl")
include("config.jl")
include("server.jl")
include("message.jl")
include("folder.jl")
include("client.jl")
include("auth.jl")

export OutlookClient, refresh_tokens, build_token

const API   = "https://outlook.office.com/api/v2.0/me/"
const AUTH  = "https://login.microsoftonline.com/common/oauth2/v2.0/authorize"
const TOKEN = "https://login.microsoftonline.com/common/oauth2/v2.0/token"

end