# Structure

## not working
Api client => Middle Server => Misskey

Api client ==HTTP=> Oxygen.jl(HTTP.jl) -> MisskeyAPIClient --> MisskeyOpenAPI.jl(Downloads.jl) ==HTTP==> Misskey
< 1min --> error "select/poll returned error"

## working
Julia REPL ==> MisskeyAPIClient --> MisskeyOpenAPI.jl(Downloads.jl) ==HTTP==> Misskey
Oxygen.jl not serving

## components
Downloads.jl => wrapper of libcurl
HTTP.jl => pure julia (i.e. on libuv in julia)

HTTP.jl > Downloads.jl


# Possible solutions:
1. Replace Downloads.jl => HTTP.jl
  - change client package
  - MisskeyOpenAPI.jl: generated with openapi-generator-cli
    - coverage
    - validation
    - document
  - Misskey.jl
    - PEG: parser generator
    - generate parser for JSONC
    - parse api.json
    - generate codes with macro
    - HTTP.jl
  1. MisskeyOpenAPI.jl => Misskey.jl
  2. Replace Downloads.jl => HTTP.jl in MisskeyOpenAPI.jl
2. Separate frontend backend
  - frontend: receive request; i.e. server Oxygen.jl
  - backend: post request to Misskey: i.e. MisskeyOpenAPI.jl
  1. process
    - separated memory
    - IPC:
      - Channel
    - cons:
      - performance issue?
      - Channel
  2. thread
    - shared memory

# Additional things to consider...
frontend: push to Job queue
backend: handle job queue

## how to implement job queue...
=> JobSchedulers.jl https://cihga39871.github.io/JobSchedulers.jl/stable/manual/
Job
- process spawn
- thread spawn
- async; coroutine
