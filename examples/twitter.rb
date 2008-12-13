#!/usr/bin/env ruby

# A more comple example:
# You have to create an account in Twitter, and then, the script parses all
# direct messages received to this account.
# If found any of the keywords, send the action to the iBuddy

require 'rubygems'
require 'hpricot'
require 'httparty'
require 'rubi-buddy'

i = RubiBuddy.new

USER = 'xxx'
PASSWORD = 'xxx'

URL = 'http://twitter.com/direct_messages.xml'
options = { :query => {}, :basic_auth => { :username => USER, :password => PASSWORD }  }

while true do

  begin
    doc = Hpricot.XML( HTTParty.get(URL, options) )
    dm = (doc/"direct-messages"/"direct_message").first
    text = (dm/'text').inner_text.strip
    case text
    when 'hearth'
      4.times { i.activate_hearth }
    when 'white'
      4.times { i.color(1,1,1) }
    when 'red'
      4.times { i.color(1,0,0) }
    when 'green'
      4.times { i.color(0,1,0) }
    when 'blue'
      4.times { i.color(0,0,1) }
    when 'yellow'
      4.times { i.color(1,1,0) }
    when 'light_blue'
      4.times { i.color(0,1,1) }
    when 'turn/left'
      4.times { i.turn(0) }
    when 'turn/right'
      4.times { i.turn(1) }
    when 'flaps'
      4.times { i.flaps(4) }
    end
    
    sleep 50
    
  rescue Net::HTTPServerException
    
    puts "Waiting for 2 minutes"
    sleep 120
    
  end
  
end
