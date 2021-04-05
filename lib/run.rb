require 'puma'

Run = -> app, port: 8080 do
  server = Puma::Server.new app
  server.add_tcp_listener '127.0.0.1', port
  server.run
  sleep
end
