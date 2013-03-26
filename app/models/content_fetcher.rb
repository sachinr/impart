require 'open-uri'

class ContentFetcher
  attr_reader :document

  def initialize(url)
    @document = Nokogiri::HTML(open url)
  end

  def get_title
    @document.css('title').text
  end

  def get_description
    @document.css("meta[name='description']")[0]['content']
  end
end
