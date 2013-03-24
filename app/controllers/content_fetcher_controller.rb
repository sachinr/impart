class ContentFetcherController < ApplicationController
  def index
    fetcher = ContentFetcher.new(params['url'])
    render json: { title: fetcher.get_title }
  end
end
