#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2022-04-04 18:16:46 +0800
require 'tilt'

module Mapu
  D, Fx, routes = Object.method(:define_method), File.method(:expand_path), {}
  D[:map] { routes }
  D[:res] { @res }
  D[:req] { @req }
  D[:halt] { |r| throw :halt, r }
  D[:[]] { |k| routes.fetch(k, nil) }

  %w[GET POST PUT DELETE].map do |m| D[m.downcase]{|u, **opts, &block| { opts:, block: }.then{|r| routes[[m,u]] = r } } end

  def self.call(env)
    catch(:halt) do
      @req, @res = Rack::Request.new(env), Rack::Response.new
      res.headers['Content-type'] = 'text/html; charset=utf-8'
      if x = self[env.values_at('REQUEST_METHOD', 'PATH_INFO')]
        res.headers.merge!(x[:opts].transform_keys(&:to_s))
        res.write instance_exec(req.params, x[:opts], &x[:block])
        return res.finish
      end
      [404, {}, ['Oops!']]
    end
  end
   
  Tilt.lazy_map.map do |ext, eng|
    D[ext] do |arg, *args|
      opts = args.grep(Hash).pop[:locals] rescue {}
      engine = ['md', 'markdown'].include?(ext) ? Tilt::KramdownTemplate : Tilt.template_for(ext) 
      lout = IO.read(Fx.("../views/layout.erb", __dir__)).then{|l| Tilt.template_for('erb').new(*args){l} } 
      arg  = IO.read(Fx.("../views/#{arg}.erb", __dir__)) if arg.is_a?(Symbol)      
            
      engine.new(*args){ arg }
      .then{|t| t.render(self, opts) }.tap{|t| return t if opts[:partial] }
      .then{|doc| lout.render(self, opts){ doc } }
    end
  end
end
