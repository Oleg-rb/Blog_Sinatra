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

configure do
	init_db

	@db.execute 'create table if not exists Posts 
	(
	id integer primary key autoincrement,
	created_date date,
	content text
	)'
end

get '/' do
	@results = @db.execute 'select * from Posts order by id desc'

	erb :index		
end

get '/new' do
  erb :new
end

post '/new' do
	content = params[:content]

	@db.execute 'insert into Posts (content, created_date) values (?, datetime())', [content]

	if content.length < 1
		@error = 'Type post text'
		return erb :new
	end

	erb "You typed #{content}"
end
