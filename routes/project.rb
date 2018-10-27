PROJECT_ROUTE = proc do
  # Cardhub Query
  get '' do
    page = (params[:page] || 1).to_i
    size = (params[:size] || 10).to_i
    sql = Project.where(is_public: true)

    yajl :projects, locals: {
      count: sql.count,
      page: page,
      size: size,
      projects: sql.paginate(page, size),
    }
  end

  # Get Project Cards By Id
  get '/:id' do |id|
    project = Project.where(id: id)&.first
    raise NotFoundError.new("User: #{id}", 'User Not Existed') if user.nil?
    raise UnauthorizedError.new('User NOT Allowed') unless project.is_public || User.auth(request)&.own?(project.user)
    
    page = (params[:page] || 1).to_i
    size = (params[:size] || 10).to_i
    yajl :cards, locals: {
      page: page,
      size: size,
      project: project,
    }
  end
end
