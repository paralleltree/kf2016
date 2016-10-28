# 全自動画像晒し機

## Requirements
  * Ruby 2.2.2
  * PostgreSQL

## Build and Deploy

    $ bundle install --path vendor/bundle
    $ bundle exec rake db:migrate
    $ bundle exec ruby server.rb -o 0.0.0.0
