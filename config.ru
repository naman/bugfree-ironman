require 'rubygems'
require 'bundler'
Bundler.require

require './parse.rb'
run Sinatra::Application
