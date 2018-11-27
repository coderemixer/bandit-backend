CARD_ROUTE = proc do
  # Edit card
  put '/:id' do |id|
    card = Card.where(id: id)&.first
    raise NotFoundError.new("Card: #{id}", 'Card Not Existed') if card.nil?
    project = card.project
    raise UnauthorizedError.new('User NOT Allowed') unless User.auth(request)&.own?(project.user)

    # Edit
    req = JSON.parse(request.body.read)
    card.question = req['question']
    card.answer = req['answer']
    card.save

    yajl :card, locals: { card: card }
  end

   # Delete card
   delete '/:id' do |id|
     card = Card.where(id: id)&.first
     raise NotFoundError.new("Card: #{id}", 'Card Not Existed') if card.nil?
     project = card.project
     raise UnauthorizedError.new('User NOT Allowed') unless User.auth(request)&.own?(project.user)
     card.delete

     yajl :empty
   end

  # Challenge Card
  put '/:id/challenge/:score' do |id, score|
    card = Card.where(id: id)&.first
    raise NotFoundError.new("Card: #{id}", 'Card Not Existed') if card.nil?
    project = card.project
    raise UnauthorizedError.new('User NOT Allowed') unless User.auth(request)&.own?(project.user)

    score = score.to_i
    raise BadRequestError.new('Score NOT in range') unless score >= 0 && score <= 1
    card.attempts += 1
    card.failures += score
    card.save

    yajl :card, locals: { card: project.challenge }
  end
end
