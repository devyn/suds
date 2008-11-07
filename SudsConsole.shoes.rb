#!/usr/bin/env shoes
require 'suds'
Shoes.app do
    background black
    $sc = stack {}
    start do
        Suds::App.new("suds.console") do |from, msg|
            $sc.append { flow { para "#{from} @ #{Time.now}:", :stroke => lime; para msg, :stroke => white } }
        end
    end
end
