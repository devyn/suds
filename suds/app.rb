require 'socket'
require 'json'
module Suds
    def self.gen_instance_num
        rand(16**8).to_s(16) # should be unique enough for one system
    end
    class App
        def name
            @appname.dup
        end
        def initialize(appname, &reciever)
            @appname = appname
            @reciever = (reciever.nil? ? proc{} : reciever)
            @sock = TCPSocket.new('localhost', 42854)
            @sock.puts "logon: #@appname"
            @thread = Thread.start{loop{decide @sock.readline}}
            @temp = {}
        end
        def self.new_instance_of(appname, &reciever)
            new "#{appname}##{Suds.gen_instance_num}", &reciever
        end
        def send(appname, msg)
            @sock.puts "to #{appname}: #{msg}"
        end
        def disconnect
            @thread.kill
            @sock.close
        end
        def join
            %w(INT TERM).each{|s|trap(s){disconnect}}
            @thread.value
        end
        def app_list
            @sock.puts "list of apps?"
            until @temp['applist']; end
            return @temp.delete 'applist'
        end
        def set_reciever(&blk)
            @reciever = blk
        end
        private
        def decide str
            if str =~ /^from ([A-Za-z0-9.-_#]+): (.*)$/
                @reciever.call $1, $2 rescue puts($!)
            elsif str =~ /^app list: (.*)$/
                @temp['applist'] = JSON.parse($1)
            else
                puts "!malformed: #{str}"
            end
        end
    end
end

