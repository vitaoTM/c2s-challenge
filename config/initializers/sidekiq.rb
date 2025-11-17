if Rails.env.production? || Rails.env.development?
  Sidekiq.configure_server do |config|
    if File.exist?("config/schedule.yml")
      Sidekiq::Cron::Job.load_from_hash! YAML.load_file("config/schedule.yml")
    end
  end
end
