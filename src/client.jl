function OutlookClient(email, id, secret)
    if isfile("credentials.json")

        open("credentials.json", "r") do file
            creds = JSON.parse(readstring(file))
            auth = OutlookAuthentication(creds["access_token"], creds["refresh_token"])
            close(file)
            client = OutlookClient(email, id, secret, auth, Array{OutlookFolder, 1}())
            refresh_tokens(client)
            load_folders(client)
            client
        end

    else

        println("Please open $(authurl(id)) in your browser to authenticate this application.")
        client = OutlookClient(email, id, secret)
        start_auth_server(client)
        load_folders(client)
        client
    end
end

function finish_authentication(params, client::OutlookClient)
    code = replace(params, "/?code=", "")
    get_tokens(client, code)
end

clientsecret(client::OutlookClient) = client.clientsecret
clientid(client::OutlookClient)     = client.clientid
refreshtoken(client::OutlookClient) = client.authentication.refreshtoken
accesstoken(client::OutlookClient)  = client.authentication.accesstoken
emailaddress(client::OutlookClient) = client.email
folders(client::OutlookClient)      = client.folders