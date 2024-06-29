using Test
true || include("../src/MisskeyScheduledPost.jl")
true || include("../src/MisskeyAPIClient/MisskeyAPIClient.jl")

using DotEnv
import MisskeyOpenAPI
import MisskeyScheduledPost
import MisskeyScheduledPost.MisskeyAPIClient
DotEnv.load!()

@info "" MisskeyScheduledPost MisskeyAPIClient

@testset "Notes Create" begin
    client = MisskeyAPIClient.client(ENV["SERVER"], ENV["TOKEN"])

    resp = MisskeyAPIClient.Notes.create(client, "test")
    @test resp[1] isa MisskeyOpenAPI.NotesCreate200Response
    # @info "response" resp
end

@testset "Notes Create(Fail)" begin
    client = MisskeyAPIClient.client(ENV["SERVER"], "11111111111")

    resp = MisskeyAPIClient.Notes.create(client, "test")
    @test resp[1] isa MisskeyOpenAPI.Error
    # @info "response" resp
end
