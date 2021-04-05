This project could help in figuring out best practices for architecting
an API with [Trailblazer][trailblazer] and [Hobby][hobby].
Please feel free to open an issue if you would like to discuss
anything related.

To install the dependencies: `bundle`.
To start all the services: `bundle exec foreman start`.

## Services

Entry points for services are defined in `Procfile`:

  - db:
    - sessions(6379)
    - capabilities(6380)
    - store(6381)
  - api:
    - clients(8080)
    - projects(8081)


### sessions

A Redis server which maps an active session(`token`) to
a client(`client_id`, a Redis String).


### capabilities

A Redis server which maps a client(`client_id`) to
its `capabilities`(a Redis Set)
inside of a namespace("Clients" or "Projects").
It determines what a client can call inside of this namespace.

Full `capabilities`:

    {
      "#{client_id}.Clients"  => { "Create", "Read", "Update", "Delete" },
      "#{client_id}.Projects" => { "Create", "Read", "Update", "Delete" },
    }

### store

A Redis server which stores the user data of Clients and Projects.

### clients

A CRUD API for Clients. The entry point is at [services/clients.rb](services/clients.rb).

### projects

A CRUD API for Projects. The entry point is at [services/projects.rb](services/projects.rb).


## RPC Protocol

The APIs work via a simple request-response RPC protocol providing access to
Trailblazer functions over HTTP POST requests.
It is defined in [lib/rpc.rb](lib/rpc.rb).

The client must make a request with `ns`(namespace), `fn`(function), and `in`(input).
For example, to call `Clients::Create` with curl:

    curl -H "Content-Type: application/json" -H "Authorization: root token" -X POST -d '{"ns":"Clients","fn":"Create","in":{"name":"Alice"}}' http://localhost:8080

Or the same with Ruby:

```
require_relative 'spec/rpc_client'

rpc = RPCClient.new 'http://localhost:8080', token: 'root token'
rpc['Clients::Create', name: 'Alice']
```

The server can respond with:
  - 200: OK
      A Hash from `ctx[:output]`. For example:
          
          {
            id: some_id,
            name: 'Alice',
          }

  - 400: Bad Request
  - 403: Forbidden

The authorization logic is defined in [lib/roles/client.rb](lib/roles/client.rb) and [lib/act.rb](lib/act.rb).

## Specs

To run the specs: `bundle exec rspec`.

The specs expect to find all the services listening(after `bundle exec foreman start` spinned them up).

[trailblazer]: https://trailblazer.to
[hobby]: https://github.com/ch1c0t/hobby
