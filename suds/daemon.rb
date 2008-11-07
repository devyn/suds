require 'socket'
require 'thread'
module Suds
    class AppCollection < Array
        def find appname
            select {|app| app.name == appname}.first
        end
    end
    class Daemon
        attr_reader :thread
        def initialize
            @server = TCPServer.new("localhost", 42854) # The Suds port is always 42854
            @apps   = AppCollection.new
        end
        def start
            @thread = Thread.start do
                loop do
                    sock = @server.accept
                    @apps << SrvApp.new(sock, @apps)
                end
            end
        end
        def stop
            @thread.kill
            @apps.each do |app|
                app.kill_thread
            end
            @apps = AppCollection.new; GC.start # clears the apps
        end
    end
    class SrvApp
        attr_accessor :name
        def initialize(socket, appcol, appname=nil)
            @name = appname
            @sock = socket
            @lock = Mutex.new
            @thrd = Thread.start { until @sock.closed?
                line = @sock.readline rescue next
                if line =~ /^logon: ([A-Za-z0-9.-_]+)$/
                    @name = $1
                elsif line =~ /^to ([A-Za-z0-9.-_]+): (.*)$/
                    appcol.find($1).give_message(@name, $2) rescue puts $!
                end
            end; appcol.delete self }
        end
        def lock(&blk)
            @lock.synchronize &blk
        end
        def give_message(from, msg)
            @sock.puts("from #{from}: #{msg}")
        end
    end
end

