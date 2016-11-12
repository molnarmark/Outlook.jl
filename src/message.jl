function load_messages(client::OutlookClient, folderId::AbstractString)
    msgs = Array{OutlookMessage, 1}()

    headers = Dict(
        "Authorization"     => build_token(client),
        "Accept"            => "application/json",
        "X-AnchorMailbox"   => emailaddress(client),
    )

    response = get(API * "MailFolders/$folderId/messages", headers=headers)
    json_response = JSON.parse(readall(response))

    for (key, value) in enumerate(json_response["value"])
        msg = OutlookMessage(
            value["Id"],
            value["Subject"],
            value["IsDraft"],
            value["HasAttachments"],
            haskey(value["From"]["EmailAddress"], "Address") ? value["From"]["EmailAddress"]["Address"] : "Email Address was not found.",
            value["From"]["EmailAddress"]["Name"],
            value["Body"]["Content"],
            value["IsRead"],
            value["Importance"],
        )

        push!(msgs, msg)
    end

    msgs
end

messageid(msg::OutlookMessage)      = msg.id
subject(msg::OutlookMessage)        = msg.subject
isdraft(msg::OutlookMessage)        = msg.draft
hasattachments(msg::OutlookMessage) = msg.hasAttachments
fromaddress(msg::OutlookMessage)    = msg.fromAddress
fromname(msg::OutlookMessage)       = msg.fromName
body(msg::OutlookMessage)           = msg.body
isread(msg::OutlookMessage)         = msg.isread
importance(msg::OutlookMessage)     = msg.importance