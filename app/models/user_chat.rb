class UserChat < ApplicationRecord
  belongs_to :send_user, class_name: 'User'
  belongs_to :receive_user, class_name: 'User'

  validates :content, length: {maximum: 140 }
end
