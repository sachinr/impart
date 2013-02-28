class CommentVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  attr_accessible :comment_id, :user_id, :value
  validates_uniqueness_of :user_id, scope: :comment_id

  VALUES = {
    up: 1,
    down: -1
  }

  def set_direction(new_direction)
    new_value = VALUES[new_direction.to_sym]
    if new_record? || value == new_value*-1
      self.value = new_value
      return self.save!
    end
  end
end
