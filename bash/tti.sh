function fids() {
  RAILS_ENV=test 
  RUBYOPT=W0 
  REDIS_URL="redis://localhost:6379/1" 
  bundle exec rake db:init && 
  bundle exec rake test:units && 
  bundle exec rspec spec && 
  bundle exec ruby test/integration/admin/admin_all.rb
}

function ids() {
  RAILS_ENV=test 
  RUBYOPT=W0 
  REDIS_URL="redis://localhost:6379/1" 
  bundle exec rake db:init && 
  bundle exec rake test:units && 
  bundle exec rspec spec && 
  bundle exec ruby test/integration/admin/admin_all.rb && 
  bundle exec cucumber features
}
