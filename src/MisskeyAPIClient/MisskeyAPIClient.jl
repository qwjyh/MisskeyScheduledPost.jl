module MisskeyAPIClient

import MisskeyOpenAPI.API_VERSION
using OpenAPI

# TODO: make this constant
"""
Based Misskey version
"""
MISSKEY_VERSION = @eval(@v_str $API_VERSION)

function client(server::AbstractString, token::AbstractString)::OpenAPI.Clients.Client
    OpenAPI.Clients.Client(
        server,
        headers = Dict(
            "Authorization" => "Bearer $(token)",
            "Content-Type" => "application/json",
        ),
    )
end

include("Notes.jl")

function __init__()
    @info "Misskey Version" MISSKEY_VERSION
    if !(MISSKEY_VERSION ≥ v"2024.5.0")
        InitError(@__MODULE__, "Incompatible Misskey version") |> throw
    end
end

end # module MisskeyAPIClient
