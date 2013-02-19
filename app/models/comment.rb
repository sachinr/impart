class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :comments, as: :commentable

  attr_accessible :content, :user_id, :commentable_type, :commentable_id

  def confidence(ups, downs)
    n = ups + downs

    if n == 0
      return 0
    end

    z = 1.0
    phat = 1.0 * pos/n
    (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)
  end
end
