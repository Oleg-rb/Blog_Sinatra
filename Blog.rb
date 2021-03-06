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
	content text,
	your_name text
	)'

	@db.execute 'create table if not exists Comments 
	(
	id integer primary key autoincrement,
	created_date date,
	content text,
	post_id
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
	your_name = params[:your_name]

	if content.length < 1
		@error = 'Type post text'
		return erb :new
	end

	if your_name.length < 1
		@error = 'Type your_name text'
		return erb :new
	end

	@db.execute 'insert into Posts (content, created_date, your_name) values (?, datetime(), ?)', [content, your_name]

	erb redirect '/'
end

get '/details/:post_id' do
	post_id = params[:post_id]
	results = @db.execute 'select * from Posts where id = ?', [post_id]
	@row = results[0]

	@comments = @db.execute 'select * from Comments where post_id = ? order by id', [post_id]

	erb :details
end

post '/details/:post_id' do
	post_id = params[:post_id]
	content = params[:content]

	if content.length < 1
		return erb redirect('/details/' + post_id)
		@error = 'Type content text'
	end

	@db.execute 'insert into Comments 
		(
			content, 
			created_date, 
			post_id
		) 
			values 
		(
			?, 
			datetime(), 
			?
		)', [content, post_id]

	erb redirect('/details/' + post_id)
end
