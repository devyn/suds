require 'socket'
module Suds
    class App
        def initialize(appname, &receiver)
            @appname = appname
            @receiver = receiver
            @sock = TCPSocket.new('localhost', 42854)
            @sock.puts "logon: #@appname"
            @thread = Thread.start{loop{sr = @sock.readline.scan(/^from ([A-Za-z0-9.-_]+): (.*)/)[0];receiver.call(sr[0], sr[1])}}
        end
        def send(appname, msg) # You can also use "SYSWIDE" as the appname.
            @sock.puts "to #{appname}: #{msg}"
        end
        def disconnect
            @thread.kill
            @sock.close
        end
    end
end

