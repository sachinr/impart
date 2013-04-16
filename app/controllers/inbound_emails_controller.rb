class InboundEmailsController < ApplicationController
  def index
    render nothing: true
  end

  def create
    mitt = Postmark::Mitt.new(request.body.read)
    Post.create_from_postmark(mitt)
    render nothing: true
  end
end
