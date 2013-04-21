class SiteSetting < ActiveRecord::Base

  attr_accessible :name, :value

  validates :name, presence: true
  validates :name, uniqueness: true

  after_save :refresh_cache

  def self.cache
    @settings ||= all
  end

  def self.refresh_cache
    @settings = SiteSetting.all
  end

  def self.find_cached(name)
    cache.select { |ss| ss.name == name }.first
  end

  def self.defaults
    HashWithIndifferentAccess.new(
      YAML.load_file(
        Rails.root.join('config', 'site_settings.yml')
      )
    )
  end

  def self.keys
    defaults.keys
  end

  def self.method_missing(name, *args)
    name = name.to_s
    stripped_name = name.to_s.sub(/[\?=]$/, '')
    if keys.include? stripped_name
      if name.end_with?('=')
        find_by_name(stripped_name).update_attribute(:value, args.first)
      else
        find_cached(name).value
      end
    else
      super
    end
  end

  private

  def refresh_cache
    SiteSetting.refresh_cache
  end
end
