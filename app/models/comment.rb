class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :comments, as: :commentable
  has_many :comment_votes

  attr_accessible :content, :user, :commentable_type, :commentable_id

  validates :user, presence: true
  validates :content, presence: true

  def self.sort_by_score
    all.sort { |a, b| b.score <=> a.score }
  end

  def deleted?
    deleted
  end

  def delete!
    self.deleted = true
    self.save!
  end

  def score
    confidence(ups, downs)
  end

  def confidence(ups, downs)
    return -downs if ups == 0
    n = ups + downs
    z = 1.64485 #1.0 = 85%, 1.6 = 95%
    phat = 1.0 * ups/n
    return (phat+z*z/(2*n)-z*Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)
  end

  #def confidence(ups, downs)

    #n = ups + downs
    #return 0 if n == 0

    #z = 1.0
    #phat = 1.0 * ups/n

    #Math.sqrt(phat+z*z/(2*n)-z*((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)
  #end

  def comment_count
    total = comments.count
    if total > 0
      total += comments.map{ |c| c.comment_count }.inject(:+)
    end

    total
  end

  def vote(direction, user)
    case direction
    when 'up'
      return upvote(user)
    when 'down'
      return downvote(user)
    else
      return false
    end
  end

  def upvote(user)
    vote = comment_votes.find_or_initialize_by_user_id(user.id)
    was_downvote = vote.value == -1
    if vote.set_direction('up')
      self.downs -= 1 if was_downvote
      self.ups += 1
    else
      self.ups -= 1
      vote.delete
    end

    self.save
  end

  def downvote(user)
    vote = comment_votes.find_or_initialize_by_user_id(user.id)
    was_upvote = vote.value == 1

    if vote.set_direction('down')
      self.ups -= 1 if was_upvote
      self.downs += 1
    else
      self.downs -= 1
      vote.delete
    end

    self.save
  end
end
