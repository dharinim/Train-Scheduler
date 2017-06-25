host = ENV['statsd_host'] || Rails.application.config.statsd[:host]
port = ENV['statsd_port'] || Rails.application.config.statsd[:port]

$statsd = Statsd.new host, port