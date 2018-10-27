USER_ROUTE = proc do
  # Login
  post '/login' do
    req = JSON.parse(request.body.read)
    user, token = User.login(req['username'], req['password'])
    yajl :login, locals: { token: token, user: user }
  end

  # Register
  post '/register' do
    req = JSON.parse(request.body.read)
    user = User.create(
      username: req['username'],
      password: CryptoService.generate(req['password']),
      nickname: req['nickname'],
      is_admin: false,
    )
    yajl :empty
  rescue Sequel::UniqueConstraintViolation => _e
    raise UnauthorizedError.new('User Existed')
  end

  # Get all users
  get '' do
    User.auth!(request).admin! 
    page = (params[:page] || 1).to_i
    size = (params[:size] || 10).to_i

    yajl :users, locals: {
      count: User.count,
      page: page,
      size: size,
      users: User.dataset.paginate(page, size),
    }
  end

  # View profile
  get '/:id' do |id|
    User.auth!(request)
    user = User.where(id: id)&.first
    raise NotFoundError.new("User: #{id}", 'User Not Existed') if user.nil?
    yajl :profile, locals: { user: user }
  end

  # Edit profile
  put '/:id' do |id|
    user = User.auth!(request)
    entity = User.where(id: id)&.first
    raise NotFoundError.new("User: #{id}", 'User Not Existed') if user.nil?
    user.own!(entity)

    req = JSON.parse(request.body.read)
    entity.password = CryptoService.generate(req['password']) unless req['password'].nil?
    entity.nickname = req['nickname'] unless req['nickname'].nil?
    entity.is_admin = req['is_admin'] if user.admin? && !req['is_admin'].nil?
    entity.save

    yajl :profile, locals: { user: entity }
  end

  get '/:id/projects' do |id|
    user = User.auth!(request)
    entity = User.where(id: id)&.first
    raise NotFoundError.new("User: #{id}", 'User Not Existed') if user.nil?
    sql = entity.projects_dataset
    sql = sql.where(is_public: true) unless user.own?(entity)

    page = (params[:page] || 1).to_i
    size = (params[:size] || 10).to_i
    yajl :projects, locals: {
      count: sql.count,
      page: page,
      size: size,
      projects: sql.paginate(page, size),
    }
  end

  # Create Project
  post '/:id/projects' do |id|
    user = User.auth!(request)
    entity = User.where(id: id)&.first
    raise NotFoundError.new("User: #{id}", 'User Not Existed') if user.nil?
    req = JSON.parse(request.body.read)
    project = Project.create(
      name: req['name'],
      description: req['description'],
      is_public: req['is_public'],
      user: entity,
    )
    yajl :project, locals: { project: project }
  end
end
