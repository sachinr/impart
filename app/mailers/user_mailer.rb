class UserMailer < ActionMailer::Base
  default from: "no-reply@nottheaverageactuary.com"

  def comment_notification_email(comment)
    @comment = comment
    post = comment.commentable
    mail(to: post.user.email, subject: "New comment on #{SiteSetting.site_name}")
  end
end
