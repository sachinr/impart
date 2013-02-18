class Post < ActiveRecord::Base
  belongs_to :user

  has_many :comments
  has_many :post_votes

  attr_accessible :title, :description, :url

  def upvote
    self.votes ||= 0
    self.votes += 1

    self.save!
  end
end
