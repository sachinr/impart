class SiteSetting < ActiveRecord::Base

  attr_accessible :name, :value, :value_type

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
        get_value(name)
      end
    else
      super
    end
  end

  private

  def refresh_cache
    SiteSetting.refresh_cache
  end

  def self.get_value(name)
    setting = find_cached(name)
    case setting.value_type
    when 'boolean'
      setting.value == 'true'
    when 'integer'
      setting.value.to_i
    when 'float'
      setting.value.to_f
    else
      setting.value
    end
  end
end
