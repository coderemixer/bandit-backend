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
    raise NotFoundError.new("Project: #{id}", 'Project Not Existed') if project.nil?
    raise UnauthorizedError.new('User NOT Allowed') unless project.is_public || User.auth(request)&.own?(project.user)

    page = (params[:page] || 1).to_i
    size = (params[:size] || 10).to_i
    yajl :cards, locals: {
      page: page,
      size: size,
      project: project,
    }
  end

  # Delete Project
  delete '/:id' do |id|
    project = Project.where(id: id)&.first
    raise NotFoundError.new("Project: #{id}", 'Project Not Existed') if project.nil?
    raise UnauthorizedError.new('User NOT Allowed') unless User.auth(request)&.own?(project.user)
    project.cards_dataset.delete
    project.delete

    yajl :empty
  end

  # Create Card
  post '/:id/cards' do |id|
    project = Project.where(id: id)&.first
    raise UnauthorizedError.new('User NOT Allowed') unless User.auth!(request).own?(project.user)

    req = JSON.parse(request.body.read)
    card = Card.create(
      question: req['question'],
      answer: req['answer'],
      project: project,
    )

    yajl :card, locals: { card: card }
  end

  # Challenge Card
  get '/:id/challenge' do |id|
    project = Project.where(id: id)&.first
    raise NotFoundError.new("Project: #{id}", 'Project Not Existed') if project.nil?
    raise UnauthorizedError.new('User NOT Allowed') unless User.auth(request)&.own?(project.user)
    yajl :card, locals: { card: project.challenge }
  end
end
