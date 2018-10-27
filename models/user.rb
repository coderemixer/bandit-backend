class User < Sequel::Model
  plugin :timestamps, update_on_create: true
  one_to_many :projects

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

  def self.login(username, password)
    user = User.where(username: username)&.first
    raise(UnauthorizedError.new('User Not Exsited')) if user.nil?
    raise(UnauthorizedError.new('Password Incorrect')) unless CryptoService.verify(password, user.password)
    token = SecureRandom.uuid62
    Token.create(token: token, user_id: user.id)
    return user, token
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
