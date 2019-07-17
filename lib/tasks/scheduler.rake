namespace :schedule do

  desc "This task is called by the Heroku scheduler add-on"

  task :get_data => :environment do
    User.last.delete
  end
end
