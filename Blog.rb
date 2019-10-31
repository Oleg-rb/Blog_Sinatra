#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

before do
	init_db
end

def init_db
	@db = SQLite3::Database.new 'blog.db'
	@db.results_as_hash = true
end

get '/' do
	erb "Hello! <a href=\"https://github.com/Oleg-rb/Template/\">Original</a> pattern has been modified for <a href=\"https://github.com/Oleg-rb/Template/\">Template</a>"			
end

get '/new' do
  erb :new
end

post '/new' do
	content = params[:content]
	erb "You typed #{content}"
end
