class User < Sequel::Model
  plugin :timestamps, create: :created_time

  def admin?
    self.is_admin
  end

  def admin!
    raise UnauthorizedError.new('Admin Only') unless admin?
  end

  def own?(user)
    self.admin? || self == user
  end

  def own!(user)
    raise UnauthorizedError.new('User NOT Allowed') unless own?(user)
  end

  def self.login(email, password)
    user = User.where(email: email)&.first
    raise(UnauthorizedError.new('User Not Exsited')) if user.nil?
    raise(UnauthorizedError.new('Password Incorrect')) unless CryptoService.verify(password, user.password)
    token = SecureRandom.uuid62
    Token.create(token: token, user_id: user.id)
    user, token
  end

  def self.auth(request)
    user = Token.find(token: request.env['HTTP_TOKEN'])&.first
    user.nil? ? nil : User.where(id: user.user_id)&.first
  end

  def self.auth!(request)
    user = self.auth(request)
    user.nil? ? raise(UnauthorizedError.new('Token NOT Verified')) : user
  end
end
