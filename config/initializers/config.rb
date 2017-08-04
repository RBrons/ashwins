if Rails.env.development?
  require 'rack-mini-profiler'
  Rack::MiniProfilerRails.initialize!(Rails.application)
  Rack::MiniProfiler.config.position = 'right'
end

HOST = Rails.env.production? ? 'http://amazme.net' : 'http://localhost:3000'
