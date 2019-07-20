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
      #heorku schedulerの走る間隔が最短8分、最長12分と不正確なため長めに取ってcreated_atで重複がない場合に保存する。
      from = Time.now - 60 * 12
      to = Time.now
      resource_data = access_token.get('https://www.healthplanet.jp/status/innerscan.json', :params => { 'access_token' => access_token.token,  'tag' => '6021', 'date' => '0', 'from' => from.strftime('%Y%m%d%H%M%S'), 'to' => to.strftime('%Y%m%d%H%M%S') })

      resource_data.parsed["data"].each do |data|
        date = data["date"].insert(4, "-").insert(7, "-").insert(10, " ").insert(13, ":").insert(16, ":00")
        if user.records.where(created_at: date).count == 0
          record = user.records.create(weight: data["keydata"].to_f)
          record.update_attribute(:created_at, date)
        end
      end
    end
  end

  task :token_refresh => :environment do
    users = User.where.not(access_token: nil)
    secret = ENV['SECRET']
    encryptor = ::ActiveSupport::MessageEncryptor.new(secret, cipher: 'aes-256-cbc')
    client = OAuth2::Client.new(ENV["API_ID"], ENV["API_SECRET"],
    {
      site: 'https://www.healthplanet.jp/',
      token_url: 'oauth/token',
    }
    )

    users.each do |user|
      decrypt_refresh_token = encryptor.decrypt_and_verify(user.refresh_token)
      new_access_token_object = client.get_token(
      {:redirect_uri => 'https://www.healthplanet.jp/success.html',
      :grant_type => "refresh_token",
      :refresh_token => decrypt_refresh_token
      }
      )

      encrypt_access_token = encryptor.encrypt_and_sign(new_access_token_object.token)
      encrypt_refresh_token = encryptor.encrypt_and_sign(new_access_token_object.refresh_token)
      user.update_attributes(access_token: encrypt_access_token, refresh_token: encrypt_refresh_token)
    end
  end

end
