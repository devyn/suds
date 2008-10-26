require 'socket'
module Suds
    class App
        def initialize(appname, &receiver)
            @appname = appname
            @receiver = receiver
            @sock = TCPSocket.new('localhost', 42854)
            @sock.puts "I am #@appname"
            @thread = Thread.start{loop{receiver.call(@sock.readline)}}
        end
        def send(appname, msg)
            @sock.puts "to #{appname}: #{msg}"
        end
        def disconnect
            @thread.kill
            @sock.close
        end
    end
end

