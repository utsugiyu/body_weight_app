desc "This task is called by the Heroku scheduler add-on"

task :delete_last_user => :environment do
  User.last.delete
end
