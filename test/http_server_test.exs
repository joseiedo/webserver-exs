defmodule HttpServerTest do
  use ExUnit.Case

  test "server receives and responds to HTTP message" do
    task = Task.async(fn -> HttpServer.start() end)
    :timer.sleep(100)
    {:ok, socket} = :gen_tcp.connect(~c"localhost", 4040, [:binary, active: false])

    :ok = :gen_tcp.send(socket, "GET / HTTP/1.1\r\n\r\nHello World")

    {:ok, response} = :gen_tcp.recv(socket, 0)
    IO.puts("Response: #{response}")
    assert response == "HTTP/1.1 200 OK\r\n"

    # Cleanup
    :gen_tcp.close(socket)
    Task.shutdown(task, :brutal_kill)
  end
end
