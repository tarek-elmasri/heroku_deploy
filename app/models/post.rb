class Post < ApplicationRecord
  belongs_to :user

  validates :title , presence: true
  validates :body,  presence: true

  def accessable_by?(user)
    self.user_id == user.id
  end
end
