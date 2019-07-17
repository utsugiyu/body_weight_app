module ApplicationHelper

  def full_title(title)
    if !title.empty?
      return "#{title} | Body Weight App"
    else
      return "Body Weight App"
    end
  end

  def create_encriptor
    secret = ENV['SECRET']
    encryptor = ::ActiveSupport::MessageEncryptor.new(secret, cipher: 'aes-256-cbc')
  end
end
