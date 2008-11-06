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
                sock = @server.accept
                @apps << App.new(sock, @apps)
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
    class App
        attr_accessor :name
        def initialize(socket, appcol, appname=nil)
            @name = appname
            @sock = socket
            @lock = Mutex.new
            @thrd = Thread.start { loop { @
        end
        def lock(&blk)
            @lock.synchronize &blk
        end
    end
end

