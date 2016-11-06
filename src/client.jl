function finish_authentication(params, client::OutlookClient)
    code = replace(params, "/?code=", "")
    get_tokens(client, code)
end

clientsecret(client::OutlookClient) = client.clientsecret
clientid(client::OutlookClient) = client.clientid
refreshtoken(client::OutlookClient) = client.authentication.refreshtoken
accesstoken(client::OutlookClient) = client.authentication.accesstoken