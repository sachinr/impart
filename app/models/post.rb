class Post < ActiveRecord::Base
  belongs_to :user

  has_many :comments, as: :commentable
  has_many :post_votes, dependent: :destroy

  attr_accessible :title, :description, :url, :user_id

  validates :title, presence: true
  validates :url,   presence: true

  after_create :initial_post_vote

  def user_name
    if user
      user.email
    else
      '[delete]'
    end
  end

  def self.all_with_user_votes(user)
    posts = Post.joins("LEFT OUTER JOIN post_votes
               ON post_votes.post_id = posts.id
               AND post_votes.user_id = #{user.id}").all

    sort_collection_by_rank(posts)
  end

  def self.sort_by_rank
    sort_collection_by_rank(all)
  end

  def self.sort_collection_by_rank(collection)
    collection.sort { |a, b| b.rank <=> a.rank }
  end

  def upvote(user)
    post_vote = PostVote.find_or_initialize_by_post_id_and_user_id(id, user.id)
    if post_vote.new_record?
      self.votes ||= 0
      self.votes += 1
      return post_vote.save! && self.save!
    else
      self.votes -= 1
      return post_vote.delete && self.save!
    end
  end

  def rank(gravity = 1.8)
    (votes - 1) / ((item_hour_age+2) ** gravity)
  end

  def comment_count
    total = comments.count
    if total > 0
      total += comments.map{ |c| c.comment_count }.inject(:+)
    end

    total
  end

  def can_be_edited_by(editor)
    editor && (editor == user || editor.admin?)
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
