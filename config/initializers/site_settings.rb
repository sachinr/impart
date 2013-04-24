begin
  puts 'setting up site settings'
  SiteSetting.defaults.each do |name, values|
    if SiteSetting.find_by_name(name).nil?
      setting = SiteSetting.new(name: name, value: values["value"], value_type: values["type"])
      setting.save
    end
  end
rescue
  puts 'ERROR configuring settings - please run migrations'
end
