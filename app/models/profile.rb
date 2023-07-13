class Profile < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :ratings
end
