module MisskeyScheduledPost

using DotEnv
using Dates
using Oxygen
import Oxygen: validate
using HTTP
using StructTypes
using JobSchedulers

include("MisskeyAPIClient/MisskeyAPIClient.jl")

@kwdef struct PostRequest
    text::String
    visibility::Symbol = :public
end

StructTypes.StructType(::Type{PostRequest}) = StructTypes.Struct()
Oxygen.validate(req::PostRequest) =
    req.visibility in [:public, :home, :followers, :specified]

@kwdef struct SchedulePostRequest
    datetimestr::String
    text::String
    visibility::Symbol = :public
end

StructTypes.StructType(::Type{SchedulePostRequest}) = StructTypes.Struct()
Oxygen.validate(req::SchedulePostRequest) = begin
    if !(req.visibility in [:public, :home, :followers, :specified])
        return false
    end
    try
        datetime = parse(DateTime, req.datetimestr)
        if datetime < now()
            return false
        end
    catch e
        throw(e)
    end
    true
end

"""
Entry
"""
function serve()
    DotEnv.load!()
    client = MisskeyAPIClient.client(ENV["SERVER"], ENV["TOKEN"])
    # JobSchedulers.scheduler_start()
    # JobSchedulers.set_scheduler_while_loop(false)

    @get "/greet" function (req::HTTP.Request)
        return "Hello world!"
    end

    @post "/post" function (req::HTTP.Request, postrequest::Json{PostRequest})
        # postrequest = json(req, PostRequest)
        # @assert validate(postrequest)
        @info "parsed" postrequest
        job = Job(
            # @task MisskeyAPIClient.Notes.create2(
            #     client;
            #     text = postrequest.payload.text,
            #     visibility = postrequest.payload.visibility,
            # )
            @task MisskeyAPIClient.Notes.create3(
                ENV["SERVER"],
                ENV["TOKEN"];
                text = postrequest.payload.text,
                visibility = postrequest.payload.visibility,
            )
        )
        submit!(job)
        return postrequest
    end

    @post "/schedule" function (
        req::HTTP.Request,
        schedulerequest::Json{SchedulePostRequest},
    )
        @info "parsed" schedulerequest
        job = Job(
            @task(
                MisskeyAPIClient.Notes.create3(
                    ENV["SERVER"],
                    ENV["TOKEN"],
                    text = schedulerequest.payload.text,
                    visibility = schedulerequest.payload.visibility,
                )
            );
            name = "scheduled post",
            schedule_time = parse(DateTime, schedulerequest.payload.datetimestr),
        )
        submit!(job)
        return job.id
    end

    # @post "/schedule" function (req::HTTP.Request, sec::Int, text::String, date::DateTime)
    #     @info "date" day(date)
    #     return json(Dict(:sec => sec, :text => text, :date => date))
    # end
    #
    # @post "/schedule2" function (req::HTTP.Request)
    #     schedulerequest = json(req, SchedulePostRequest)
    #     @info "parsed" schedulerequest
    #     return schedulerequest
    # end

    job_server = Job(Oxygen.serve)
    submit!(job_server)
end

end # module MisskeyScheduledPost
