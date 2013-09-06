require 'uri'
module ApplicationHelper
  def url_host(url)
    if url.present?
      begin
        uri = URI.parse(url)
        host = if uri.scheme
          uri.host
        else
          URI.parse("http://#{url}").host
        end

        host.sub('www.', '')
      rescue URI::InvalidURIError
        url
      end
    end
  end

  def admin_user?
    current_user && current_user.admin?
  end

  def active_class(cont, action)
    if controller.controller_path == cont && controller.action_name == action
      'active'
    else
      ''
    end
  end
end
