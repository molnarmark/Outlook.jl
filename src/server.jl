using HttpServer

function start_auth_server(client::OutlookClient)
    println("Starting authentication server.")

    http = HttpHandler() do req::Request, res::Response
        finish_authentication(req.resource, client)
        stop_auth_server(server)
        Response(200) # Unrelevant at this point if a respose is actually sent, but without this we get "MethodError"
    end

    server = Server(http)
    run(server, get_auth_server_port())
end

stop_auth_server(server) = close(server)