class Post < ActiveRecord::Base
  belongs_to :user

  has_many :comments, as: :commentable
  has_many :post_votes, dependent: :destroy

  attr_accessible :title, :description, :url, :user_id

  validates :title, presence: true
  validates :url,   presence: true
  validates :user,  presence: true

  after_create :initial_post_vote

  def self.all_ranked
    all.sort { |a, b| b.rank <=> a.rank }
  end

  def upvote
    self.votes ||= 0
    self.votes += 1

    self.save!
  end

  def rank(gravity = 1.8)
    (votes - 1) / ((item_hour_age+2) ** gravity)
  end

  def comment_count
    total = comments.count
    total += comments.map{ |c| c.comments.count }.inject(:+)[0]
  end

  private
  def initial_post_vote
    post_vote = self.post_votes.new(user_id: user_id)
    post_vote.save!
  end

  def item_hour_age
    (Time.now - created_at) / 60 / 60
  end
end
