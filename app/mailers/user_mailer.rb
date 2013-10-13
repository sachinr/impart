class UserMailer < ActionMailer::Base
  default from: "no-reply@nottheaverageactuary.com"

  def comment_notification_email(comment)
    @comment = comment
    post = comment.commentable
    users = post.comments.inject([post.user]) { |u, c|  u << c.user }
    users.uniq.each do |user|
      if @comment.user != user
        mail(to: user.email, subject: "New comment on '#{SiteSetting.site_name}'").deliver
      end
    end
  end
end
