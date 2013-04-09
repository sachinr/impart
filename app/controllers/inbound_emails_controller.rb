class InboundEmailsController < ApplicationController
  def index
    render nothing: true
  end

  def create
    File.open('incoming_email.txt', 'w') { |file| file.write(params['mandrill_events']) }
    render nothing: true
  end
end
