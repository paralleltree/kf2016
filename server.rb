require 'sinatra'
require './models/loader.rb'
require_relative 'streaming'

get '/fetch' do
  res = Status.where("id > ?", params['max_status_id'].to_i).order(:id).limit(3)
  res.to_json(include: { user: { only: [:screen_name, :name, :profile_image_url] }, media: { only: [:url] } }, except: [:user_id, :created_at, :updated_at])
end

get '/css/main.css' do
  scss :'css/main'
end
