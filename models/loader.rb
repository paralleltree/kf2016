require 'active_record'
require_relative 'user'
require_relative 'status'
require_relative 'medium'

ActiveRecord::Base.configurations = YAML.load_file('db/database.yml')
ActiveRecord::Base.establish_connection((ENV['RACK_ENV'] || 'development').to_sym)
