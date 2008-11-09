#!/usr/bin/env ruby
require 'suds'
require 'yaml'
require 'json'
def SystemConfigParse(sc)
    if sc =~ /^(\d+)$/
        sc.to_i
    elsif sc =~ /^"(.*)"$/
        sc.gsub(/^"|"$/, '')
    elsif sc =~ /^null$/
        nil
    else
        JSON.parse(sc)
    end
end
if __FILE__ == $0
    config = (YAML.load_file(ARGV[0]) rescue nil) or {}
    app = Suds::App.new('system.config') do |from, msg|
        next unless msg =~ /^set|^get/i
        afrom = from.gsub(/\#[A-Fa-f0-9]{8,16}$/, '')
        config[afrom] = {} unless config[from]
        if msg =~ /^set ([A-Za-z0-9.-_]+) (.*)$/
            app.send "suds.console", "Setting #{afrom}/#{$1} for #{from}" # for debug
            config[afrom][$1] = SystemConfigParse $2
            File.open(ARGV[0], 'w'){|f| f.write config.to_yaml}
        elsif msg =~ /^get ([A-Za-z0-9.-_]+)$/
            app.send "suds.console", "Getting #{afrom}/#{$1} for #{from}" # for debug
            app.send from, JSON.generate(config[afrom][$1])
        end
    end
    app.join
end
