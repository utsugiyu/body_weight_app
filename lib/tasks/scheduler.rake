namespace :schedule do

  desc "This task is called by the Heroku scheduler add-on"

  task :get_data => :environment do
    users = User.where.not(acccess_token: nil)
    secret = ENV['SECRET']
    encryptor = ::ActiveSupport::MessageEncryptor.new(secret, cipher: 'aes-256-cbc')
    client = OAuth2::Client.new(ENV["API_ID"], ENV["API_SECRET"],
    {
      site: 'https://www.healthplanet.jp/',
    }
    )

    users.each do |user|
      decrypt_access_token = encryptor.decrypt_and_verify(user.access_token)
      access_token = OAuth::AccessToken.new(client, decrypt_access_token)
      resource_data = access_token.get('https://www.healthplanet.jp', :params => { 'tag' => '6021', 'date' => '0', 'from' => "#{Time.now - 60 * 10}", 'to' => "#{Time.now}" })
      data = JSON.parse(resource_data)
      puts data
    end
  end
end
