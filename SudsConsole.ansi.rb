#!/usr/bin/env ruby
require 'suds'
ANSI_CLEAR_SCREEN = "\e[H\e[2J"
ANSI_BLACK_ON_WHITE = "\e[30m\e[48m"
ANSI_WHITE_ON_BLACK = "\e[38m\e[40m"
ANSI_GREEN = "\e[32m"
ANSI_RED = "\e[31m"
ANSI_BOLD = "\e[1m"
at_exit do
    puts "\e[0m" # ensure the screen clears
end
print ANSI_WHITE_ON_BLACK
print "Suds Console (send a message to suds.console)"
print "\e[0m"
puts
Suds::App.new("suds.console") do |from, msg|
    print ANSI_WHITE_ON_BLACK
    print ANSI_BOLD
    print ANSI_GREEN
    print "#{from} @ #{Time.now.strftime("%H.%M.%S")}: "
    if msg =~ /^ERROR: (.*)$/
        print "\e[0m" << ANSI_WHITE_ON_BLACK << ANSI_BOLD << ANSI_RED
        print msg
    else
        print "\e[0m" << ANSI_WHITE_ON_BLACK
        print msg
    end
    puts "\e[0m"
end.join
