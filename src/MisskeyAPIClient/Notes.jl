"""
`notes/` APIs.
"""
module Notes

using Misskey: notes_params
import OpenAPI
import MisskeyOpenAPI
using MisskeyOpenAPI: NotesCreateRequest, NotesCreateRequestPoll
using Misskey

function create(
    client::OpenAPI.Clients.Client,
    text::AbstractString;
    visibility::Symbol = :public,
    visible_user_ids = String[],
    cw::Union{Nothing, AbstractString} = nothing,
    local_only::Bool = false,
    reaction_acceptance::Union{Nothing, Symbol} = nothing,
    no_extract_mentions::Bool = false,
    no_extract_hashtags::Bool = false,
    no_extract_emojis::Bool = false,
    reply_id::Union{Nothing, AbstractString} = nothing,
    renote_id = nothing,
    channel_id = nothing,
    file_ids = nothing,
    media_ids = nothing,
)::Tuple{
    Union{Nothing, MisskeyOpenAPI.Error, MisskeyOpenAPI.NotesCreate200Response},
    OpenAPI.Clients.ApiResponse,
}
    req = MisskeyOpenAPI.NotesCreateRequest(;
        visibility = String(visibility),
        visibleUserIds = visible_user_ids,
        cw,
        localOnly = local_only,
        reactionAcceptance = reaction_acceptance,
        noExtractMentions = no_extract_mentions,
        noExtractHashtags = no_extract_hashtags,
        noExtractEmojis = no_extract_emojis,
        replyId = reply_id,
        renoteId = renote_id,
        channelId = channel_id,
        text,
        fileIds = file_ids,
        mediaIds = media_ids,
        poll = nothing,
    )
    @debug "Request" req
    MisskeyOpenAPI.notes_create(MisskeyOpenAPI.NotesApi(client), req)
end

function create2(client::OpenAPI.Clients.Client; kw...)
    @info "kw" kw
    @info kw
    kw = Dict(kw)
    if haskey(kw, :visibility)
        kw[:visibility] = String(kw[:visibility])
    end
    if !haskey(kw, :reactionAcceptance)
        kw[:reactionAcceptance] = nothing
    end
    req = MisskeyOpenAPI.NotesCreateRequest(; kw...)
    @info "req" req
    return MisskeyOpenAPI.notes_create(MisskeyOpenAPI.NotesApi(client), req)
end

function create3(server, token; kw...)
    @info "kw" kw kw[:text]
    req = Misskey.Notes.create_params(
        Text = kw[:text],
        Visibility = String(kw[:visibility]),
        i = token,
    )
    Misskey.Notes.create(server, req)
end

function create(
    client::OpenAPI.Clients.Client,
    poll::NotesCreateRequestPoll;
    visibility::Symbol = :public,
    visible_user_ids = String[],
    cw::Union{Nothing, AbstractString} = nothing,
    local_only::Bool = false,
    reaction_acceptance::Union{Nothing, Symbol} = nothing,
    no_extract_mentions::Bool = false,
    no_extract_hashtags::Bool = false,
    no_extract_emojis::Bool = false,
    reply_id::Union{Nothing, AbstractString} = nothing,
    renote_id = nothing,
    channel_id = nothing,
    text = nothing,
    file_ids = String[],
    media_ids = String[],
)::Tuple{
    Union{Nothing, MisskeyOpenAPI.Error, MisskeyOpenAPI.NotesCreate200Response},
    OpenAPI.Clients.ApiResponse,
}
    MisskeyOpenAPI.notes_create(
        MisskeyOpenAPI.NotesApi(client),
        MisskeyOpenAPI.NotesCreateRequest(;
            visibility,
            visibleUserIds = visible_user_ids,
            cw,
            localOnly = local_only,
            reactionAcceptance = reaction_acceptance,
            noExtractMentions = no_extract_mentions,
            noExtractHashtags = no_extract_hashtags,
            noExtractEmojis = no_extract_emojis,
            replyId = reply_id,
            renoteId = renote_id,
            channelId = channel_id,
            text,
            fileIds = file_ids,
            mediaIds = media_ids,
            poll,
        ),
    )
end
end # module Notes
