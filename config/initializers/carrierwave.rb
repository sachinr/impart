CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAILAELSVCLYGCTQYA',
    :aws_secret_access_key  => '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'
  }
  config.fog_directory  = 'impart-assets'
  config.fog_public     = true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
end
