class Post < ActiveRecord::Base
  belongs_to :user

  has_many :comments, as: :commentable
  has_many :post_votes, dependent: :destroy

  attr_accessible :title, :description, :url, :user_id

  validates :title, presence: true
  validate :valid_url
  validates :message_id, uniqueness: true

  after_create :initial_post_vote

  def self.create_from_postmark(mitt)
    author = User.find_by_email(mitt.from)
    if author
      post = author.posts.new(title: mitt.subject)
      coder = HTMLEntities.new
      post.description = Sanitize.clean(coder.decode(mitt.html_body),
                                        Sanitize::Config::RELAXED)
      #post.photo = mitt.attachments.first.read
      post.message_id = mitt.message_id
      post.save
      post
    end
  end

  def user_name
    if user
      user.username
    else
      '[delete]'
    end
  end

  def self.all_with_user_votes(user)
    posts = with_user_votes(user).all
    sort_collection_by_rank(posts)
  end

  def self.latest_with_user_votes(user)
    posts = with_user_votes(user)
    posts.order('posts.created_at DESC').all
  end

  def self.top_with_user_votes(user, period = nil)
    posts = with_user_votes(user)

    if period && period != 'all'
      min_created_at = case period
      when 'today'
        1.day.ago
      when 'week'
        1.week.ago
      when 'month'
        1.month.ago
      end
      posts = posts.where('posts.created_at >= ?', min_created_at)
    end

    posts.order('posts.votes DESC').all
  end

  def self.with_user_votes(user)
    if user
      joins("LEFT JOIN post_votes
             ON post_votes.post_id = posts.id
             AND post_votes.user_id = #{user.id}").
      select('posts.*, post_votes.user_id AS user_post_vote')
    else
      self
    end
  end

  def self.find_with_user_vote(id, user)
    with_user_votes(user).where('posts.id = ?', id).first
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
    votes / ((item_hour_age+2) ** gravity)
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

  def check_http_on_url
    if url.present?
      self.url = "http://#{url}" unless url.match(/https?:\/\/.*$/i)
    end

    true
  end

  def valid_url
    return true if (url.blank? || url =~ URI::regexp)
    errors.add(:url, 'not a valid url')
    false
  end

end
