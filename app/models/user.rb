class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts #do not destroy
  has_many :comments #do not destroy
  has_many :post_votes, dependent: :destroy

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  before_save :first_user_is_admin

  def admin?
    role == 'admin'
  end

  private
  def first_user_is_admin
    if User.count == 0
      self.role = 'admin'
      self.confirmed = true
    end
  end

end
