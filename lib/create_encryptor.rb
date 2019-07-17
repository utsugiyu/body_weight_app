module CreateEncryptor

  def create_encriptor
    secret = ENV['SECRET']
    encryptor = ::ActiveSupport::MessageEncryptor.new(secret, cipher: 'aes-256-cbc')
  end

end
