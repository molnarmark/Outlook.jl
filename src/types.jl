# Declaration order is important here, some types depend on eachother

type OutlookAuthentication
    accesstoken::AbstractString
    refreshtoken::AbstractString

    OutlookAuthentication(accesstoken) = new(accesstoken)
    OutlookAuthentication(accesstoken, refreshtoken) = new(accesstoken, refreshtoken)
end

type OutlookMessage
    id::AbstractString
    subject::AbstractString
    draft::Bool
    hasAttachments::Bool
    fromAddress::AbstractString
    fromName::AbstractString
    body::AbstractString
    isread::Bool
    importance::AbstractString
end

type OutlookFolder
    id::AbstractString
    name::AbstractString
    parentFolder::AbstractString
    itemCount::Integer
    unreadItemCount::Integer
    childFolderCount::Integer
    messages::Array{OutlookMessage, 1}
end

type OutlookClient
    email::AbstractString
    clientid::AbstractString
    clientsecret::AbstractString
    authentication::OutlookAuthentication
    folders::Array{OutlookFolder, 1}
end

immutable OutlookException <: Exception
    msg::AbstractString
end