#!/usr/bin/env shoes
Shoes.setup { gem 'json' }
require 'suds'
Shoes.app :title => "Suds Console" do
    background black
    stack :width => 1.0, :height => 0.7 do
        para "Suds Console (send a message to suds.console)", :stroke => black, :fill => white, :family => 'monospace'
        @sc = stack {}
    end
    flow(:width => 1.0, :height => 0.3) { background yellow; @applist = flow {} }
    start do
        @sapp = Suds::App.new("suds.console") do |from, msg|
            @sc.prepend { flow { para "#{from} @ #{Time.now.strftime("%H.%M.%S")}:", :stroke => lime, :family => 'monospace'; if msg =~ /^ERROR: (.*)$/; para msg, :stroke => red, :family => 'monospace'; else; para msg, :stroke => white, :family => 'monospace'; end } }
        end
        Thread.start { loop { @applist.clear { @sapp.app_list.each {|a| para("#{a}\n", :stroke => darkred) } } ; sleep 1 } }
    end
end
