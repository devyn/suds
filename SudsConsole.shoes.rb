#!/usr/bin/env shoes
Shoes.setup { gem 'json' }
require 'suds'
Shoes.app do
    background black
    stack do
        para "Suds Console (send a message to suds.console)", :stroke => black, :fill => white, :family => 'monospace'
        $sc = stack {}
    end
    start do
        Suds::App.new("suds.console") do |from, msg|
            $sc.prepend { flow { para "#{from} @ #{Time.now.strftime("%H.%M.%S")}:", :stroke => lime, :family => 'monospace'; if msg =~ /^ERROR: (.*)$/; para msg, :stroke => red, :family => 'monospace'; else; para msg, :stroke => white, :family => 'monospace'; end } }
        end
    end
end
