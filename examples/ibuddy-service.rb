#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'rubi-buddy'

@@i = RubiBuddy.new

get '/' do
end

get '/colors/red' do
  @@i.color(1,0,0)
end

get '/colors/green' do
  @@i.color(0,1,0)
end

get '/colors/blue' do
  @@i.color(0,0,1)
end

get '/colors/white' do
  @@i.color(1,1,1)
end

get '/colors/yellow' do
  @@i.color(1,1,0)
end

get '/colors/light_blue' do
  @@i.color(0,1,1)
end

get '/hearth' do
  @@i.activate_hearth
end

get '/turn/left' do
  @@i.turn(0)
end

get '/turn/right' do
  @@i.turn(1)
end

get '/flaps/:times' do
  @@i.flaps(params[:times].to_i)
end