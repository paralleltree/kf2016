require 'sinatra'
require './models/loader.rb'
require_relative 'streaming'


blacklist_ids = open('blacklist_ids.txt') { |f| f.read.split("\n").map { |s| s.to_i } }
filtered_words = open('filtered_words.txt') { |f| f.read.split("\n") }

get '/' do
  erb :index
end

get '/fetch' do
  limit = params[:limit].present? ? params[:limit] : 8
  res = Status.valid_statuses(blacklist_ids, filtered_words).tap do |rel|
    if params["max_status_id"].present?
      break rel.where(id: (params['max_status_id'].to_i + 1)..Float::INFINITY).order(:id).limit(limit)
    else
      break rel.order(id: :desc).limit(limit).reverse
    end
  end

  headers "Content-Type" => "application/json"
  res.as_json(include: { user: { only: [:screen_name, :name, :profile_image_url] }, media: { only: [:url] } }, except: [:user_id, :created_at, :updated_at])
    .tap { |arr| arr.each { |st| st["id"] = st["id"].to_s } }.to_json
end

get '/js/script.js' do
  coffee :'js/script'
end

get '/css/main.css' do
  scss :'css/main'
end
