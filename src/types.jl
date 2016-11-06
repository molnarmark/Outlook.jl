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
        if isfile("credentials.json")

            open("credentials.json", "r") do file
                creds = JSON.parse(readstring(file))
                auth = OutlookAuthentication(creds["access_token"], creds["refresh_token"])
                close(file)
                client = new(email, id, secret, auth)
                refresh_tokens(client)
                client
            end

        else

            println("Please open $(authurl(id)) in your browser to authenticate this application.")
            client = new(email, id, secret)
            start_auth_server(client)
            client
        end
    end
end