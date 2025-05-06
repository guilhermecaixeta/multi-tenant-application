# frozen_string_literal: true
# typed: true

# Learn more: http://github.com/javan/whenever
if ENV.fetch('RAILS_ENV', 'development') == 'development'
  every 10.minutes do
    rake '-s sitemap:refresh'
  end
else
  every 1.day, at: '00:00 am' do
    rake '-s sitemap:refresh'
  end
end
