class PostVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  attr_accessible :post_id, :user_id
  validates_uniqueness_of :user_id, scope: :post_id
end
