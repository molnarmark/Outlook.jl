function load_folders(client::OutlookClient)
    headers = Dict(
        "Authorization"     => build_token(client),
        "Accept"            => "application/json",
        "X-AnchorMailbox"   => emailaddress(client),
    )

    response = get(API * "MailFolders", headers=headers)
    json_response = JSON.parse(readall(response))

    for (key, value) in enumerate(json_response["value"])

        folder = OutlookFolder(
            value["Id"],
            value["DisplayName"],
            value["ParentFolderId"],
            value["TotalItemCount"],
            value["UnreadItemCount"],
            value["ChildFolderCount"],
            load_messages(client, value["Id"])
        )

        push!(client.folders, folder)
    end

end

folderid(f::OutlookFolder)          = f.id
foldername(f::OutlookFolder)        = f.name
parentfolder(f::OutlookFolder)      = f.parentFolder
itemcount(f::OutlookFolder)         = f.itemCount
unreadcount(f::OutlookFolder)       = f.unreadItemCount
childfoldercount(f::OutlookFolder)  = f.childFolderCount
messages(folder::OutlookFolder)     = folder.messages