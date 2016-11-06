# Declaration order is important here, some types depend on eachother

type OutlookAuthentication
    authtoken::AbstractString
    refreshtoken::AbstractString

    OutlookAuthentication(authtoken) = new(authtoken)
    OutlookAuthentication(authtoken, refreshtoken) = new(authtoken, refreshtoken)
end

type OutlookMessage
    # Todo
end

type OutlookFolder
    id::Integer
    name::AbstractString
    messages::Dict{OutlookMessage}
end

type OutlookClient
    email::AbstractString
    clientid::AbstractString
    clientsecret::AbstractString
    authentication::OutlookAuthentication

    function OutlookClient(email, id, secret)
        println("Please open $(authurl(id)) in your browser to authenticate this application.")
        client = new(email, id, secret)
        start_auth_server(client)
        client
    end
end