class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :profile

  validates :score, inclusion: { in: 1..5, message: "should be between 1 to 5" }
end
