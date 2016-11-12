""" This function generates an authentication url needed to get the tokens """
function authurl(id::AbstractString)
    AUTH * "?client_id=$id&response_type=code&redirect_uri=$(get_redirect_uri())&scope=https://outlook.office.com/mail.read%20offline_access"
end

""" This function sends a request that gets us the access & refresh tokens """
function get_tokens(client::OutlookClient, authcode::AbstractString)
    data = Dict(
        "client_id"     => clientid(client),
        "scope"         => "https://outlook.office.com/mail.read offline_access",
        "code"          => authcode,
        "redirect_uri"  => get_redirect_uri(),
        "grant_type"    => "authorization_code",
        "client_secret" => clientsecret(client),
    )

    response = post(TOKEN, data=data)
    tokens = readall(response)
    tokens_parsed = JSON.parse(tokens)

    open("credentials.json", "w+") do file
        write(file, tokens)
        close(file)
    end

    access_token = tokens_parsed["access_token"]
    refresh_token = tokens_parsed["refresh_token"]

    auth = OutlookAuthentication(access_token, refresh_token)
    client.authentication = auth
    auth
end

function refresh_tokens(client::OutlookClient)
    data = Dict(
        "client_id"     => clientid(client),
        "redirect_uri"  => get_redirect_uri(),
        "grant_type"    => "refresh_token",
        "client_secret" => clientsecret(client),
        "refresh_token" => refreshtoken(client)
    )

    response = post(TOKEN, data=data)
    if statuscode(response) != 200
        println("Couldn't authenticate. I removed your credentials.json file, restart your application and authenticate again!")
        rm("credentials.json", force=true)
        exit()
    else
        tokens = readall(response)
        tokens_parsed = JSON.parse(tokens)

        open("credentials.json", "w+") do file
            write(file, tokens)
            close(file)
        end

        access_token = tokens_parsed["access_token"]
        refresh_token = tokens_parsed["refresh_token"]

        auth = OutlookAuthentication(access_token, refresh_token)
        client.authentication = auth
    end
end

build_token(client::OutlookClient) = "Bearer " * accesstoken(client)