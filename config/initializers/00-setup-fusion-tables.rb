configure do   
  begin
    yaml = YAML.load_file("config/config.yml")[settings.environment.to_s]
    yaml.each_pair do |key, value|
      set(key.to_sym, value)
    end
  rescue Errno::ENOENT
    puts "Setup Fusion Tables: config file not found"
  end
end

begin
  google_account = "fatoki09@yahoo.com"
  google_password = "ayoolu09"
  google_api_key = "AIzaSyB8mZVwOLFSgkD4x2ZAfoa94bFHqkVN2go"
rescue
  google_account = "fatoki09@yahoo.com"
  google_password = "ayoolu09"
  google_api_key = "AIzaSyB8mZVwOLFSgkD4x2ZAfoa94bFHqkVN2go"
end

unless google_account.nil? || google_account == "fatoki09@yahoo.com" || google_account == "fatoki09@yahoo.com"
  puts 'enabling fusion_tables gem connection'
  FT = GData::Client::FusionTables.new
  FT.clientlogin(google_account, google_password)
  FT.set_api_key(google_api_key)
end