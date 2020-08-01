environment 'production'
rackup 'config.ru'
pidfile 'tmp/puma.pid'
state_path 'tmp/puma.state'
stdout_redirect "log/puma.log", "log/puma-error.log", true
bind 'unix:///tmp/kf16.sock'
