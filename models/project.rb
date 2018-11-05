class Project < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_one :user
  one_to_many :cards

  def challenge
    sql = self.cards_dataset
    raise NotFoundError.new('No Cards for challenge') if sql.count == 0
    
    # Contains not-attempted card
    res = sql.where(attempts: 0)&.first
    return res unless res.nil?
    
    # Calculate UCB (Upper Confidence Bound)
    total_attempts = sql.sum(:attempts)
    sql.select_append {
      (failures / attempts + (SQRT(2 * LOG(2.0, total_attempts) / attempts))).as(ucb)
    }.order(Sequel.desc(:ucb)).first
  end
end
