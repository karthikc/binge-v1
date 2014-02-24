class School < ActiveRecord::Base
  validates :name, :city, presence: true
end
