namespace :schedule do

  desc "This task is called by the Heroku scheduler add-on"

  task :get_data => :environment do
    users = User.where.not(access_token: nil)
    secret = ENV['SECRET']
    encryptor = ::ActiveSupport::MessageEncryptor.new(secret, cipher: 'aes-256-cbc')
    client = OAuth2::Client.new(ENV["API_ID"], ENV["API_SECRET"],
    {
      site: 'https://www.healthplanet.jp/',
    }
    )

    users.each do |user|
      decrypt_access_token = encryptor.decrypt_and_verify(user.access_token)
      access_token = OAuth2::AccessToken.new(client, decrypt_access_token)
      from = Time.now - 60 * 10
      to = Time.now
      resource_data = access_token.get('https://www.healthplanet.jp/status/innerscan.json', :params => { 'access_token' => access_token.token,  'tag' => '6021', 'date' => '0', 'from' => from.strftime('%Y%m%d%H%M%S'), 'to' => to.strftime('%Y%m%d%H%M%S') })
      puts resource_data.parsed
    end
  end
end
