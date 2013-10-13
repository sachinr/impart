class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts #do not destroy
  has_many :comments #do not destroy
  has_many :post_votes, dependent: :destroy
  validate :valid_url

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :username, :email, :password, :password_confirmation,
    :remember_me, :avatar, :avatar_cache, :url, :bio

  before_save :first_user_is_admin

  def admin?
    role == 'admin'
  end

  def post_karma
    @post_karma ||= PostVote.joins(post: :user).where('users.id = ?', id).count
  end

  def comment_karma
    @comment_karma ||= calculate_comment_karma
  end

  private
  def first_user_is_admin
    if User.count == 0
      self.role = 'admin'
      self.confirmed = true
    end
  end

  def calculate_comment_karma
    votes = Comment.select('ups, downs').where('user_id = ?', 2)
    votes.inject(0) { |total, comment| total + comment.ups - comment.downs }
  end

  def valid_url
    return true if (url.blank? || url =~ URI::regexp)
    errors.add(:url, 'not a valid url')
    false
  end


end
