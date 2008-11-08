require 'rubygems' rescue nil
require 'suds/daemon'
require 'suds/app'

if __FILE__ == $0
    d = Suds::Daemon.new
    %w{INT TERM}.each{|sig|trap(sig){abort}}
    d.start
    d.thread.join
end

