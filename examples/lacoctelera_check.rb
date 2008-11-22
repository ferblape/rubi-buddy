require 'rubygems'
require 'curb'
require 'ibuddy'

i = IBuddy.new

while true

  c = Curl::Easy.perform("http://www.lacoctelera.com")
  c.header_str.split("\n").each do |line|
    if line =~ /^HTTP/
      if line.strip == "HTTP/1.1 200 OK"
        i.color(0,1,0)
      else
        i.color(1,0,0)
      end
    end
  end
  sleep 5
  i.reset
  sleep 5
  
end

