class Project < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_one :user
  one_to_many :cards
end
