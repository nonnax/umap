#!/usr/bin/env ruby
# Id$ nonnax 2022-04-04 18:34:08 +0800
require_relative 'lib/umap'
require 'pp'

get '/' do |param|
  erb :template, locals: param
end

get '/hi' do |param|
  erb "hey #{param}"
end

get '/mark' do |param|
  md "# hey #{param}"
end

post '/', 'Content-type': 'application/json' do |params, data|
  erb ['params: '+params.inspect,   'data: '+data.inspect].join(","), locals: {partial: true}
end

get '/r' do |params, data|
  res.redirect '/'
end

get '/halt' do |params, data|  
  halt [401, {}, ['Halting...']]
end

pp Mapu.map
run Mapu
