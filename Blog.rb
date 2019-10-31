#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

get '/' do
	erb "Hello! <a href=\"https://github.com/Oleg-rb/Template/\">Original</a> pattern has been modified for <a href=\"https://github.com/Oleg-rb/Template/\">Template</a>"			
end
