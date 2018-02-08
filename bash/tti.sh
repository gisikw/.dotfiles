function fids() {
  export RAILS_ENV=test 
  export RUBYOPT=W0 
  export REDIS_URL="redis://localhost:6379/1" 
  bundle exec rake db:init && 
  bundle exec rake test:units && 
  bundle exec rspec spec && 
  bundle exec ruby test/integration/admin/admin_all.rb
}

function ids() {
  export RAILS_ENV=test 
  export RUBYOPT=W0 
  export REDIS_URL="redis://localhost:6379/1" 
  bundle exec rake db:init && 
  bundle exec rake test:units && 
  bundle exec rspec spec && 
  bundle exec ruby test/integration/admin/admin_all.rb && 
  bundle exec cucumber features
}

function rids() {
  export RAILS_ENV=test 
  export RUBYOPT=W0 
  export REDIS_URL="redis://vger:6379/1" 
  bundle exec rake db:init && 
  bundle exec rake test:units && 
  bundle exec rspec spec && 
  bundle exec ruby test/integration/admin/admin_all.rb && 
  bundle exec cucumber features
}
