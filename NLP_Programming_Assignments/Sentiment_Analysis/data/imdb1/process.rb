#!/usr/bin/env ruby

posFile = File.open("posFile.txt","w") do |pos|
  Dir.entries("pos").each do |filename|
    unless filename=='.'||filename=='..'
      File.open("pos/#{filename}").each do |line|
        pos.puts(line)
      end
      pos.puts('#*#*#*#*#')
    end
  end
end

negFile = File.open("negFile.txt","w") do |pos|
  Dir.entries("neg").each do |filename|
    unless filename=='.'||filename=='..'
      File.open("neg/#{filename}").each do |line|
        pos.puts(line)
      end
      pos.puts('#*#*#*#*#')
    end
  end
end