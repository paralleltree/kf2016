require 'sinatra'
require './models/loader.rb'
require_relative 'streaming'

get '/' do
  erb :index
end

get '/fetch' do
  limit = 8
  if params["max_status_id"]
    res = Status.where("id > ?", params['max_status_id'].to_i).order(:id).limit(limit)
  else
    res = Status.order("id DESC").limit(limit).reverse
  end

  headers "Content-Type" => "application/json"
  res.to_json(include: { user: { only: [:screen_name, :name, :profile_image_url] }, media: { only: [:url] } }, except: [:user_id, :created_at, :updated_at])
end

get '/js/script.js' do
  coffee :'js/script'
end

get '/css/main.css' do
  scss :'css/main'
end
