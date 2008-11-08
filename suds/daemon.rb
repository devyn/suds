require 'socket'
require 'thread'
require 'json'
module Suds
    class AppCollection < Array
        def find appname
            select {|app| app.name =~ /^#{Regexp.escape(appname)}(\#[A-Fa-f0-9]{8,16})?$/ }
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
            @thrd = Thread.start { catch(:e_loop) { until @sock.closed?
                line = @sock.readline rescue throw(:e_loop)
                if line =~ /^logon: ([A-Za-z0-9.-_#]+)$/
                    @name = $1
                elsif line =~ /^to ([A-Za-z0-9.-_#]+): (.*)$/
                    appcol.find($1).each{|a|a.give_message(@name, $2) rescue puts($!)}
                elsif line =~ /^list of apps\?$/
                    @sock.puts("app list: #{JSON.generate(appcol.collect{|a|a.name})}")
                end
            end }; appcol.delete self }
        end
        def lock(&blk)
            @lock.synchronize &blk
        end
        def give_message(from, msg)
            @sock.puts("from #{from}: #{msg}")
        end
    end
end

