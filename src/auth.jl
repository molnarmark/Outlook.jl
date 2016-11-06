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
    tokens = JSON.parse(readall(response))
    dump(tokens)
end