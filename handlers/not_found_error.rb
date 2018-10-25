class NotFoundError < BaseError
  def initialize(resource, reason)
    super(404, {
      resource: resource,
      reason: reason,
    })
  end
end
