# frozen_string_literal: true

require 'random/formatter'

namespace :test do
  desc 'Recreate'
  task recreate: :environment do
    next unless Rails.env.test?

    puts "== Closing Connections ==\n#{`RAILS_ENV=test rails db:kick`}"
    puts "== Done ==\n"
    puts "== Dropping DB ==\n#{`RAILS_ENV=test rails db:drop`}"
    puts "== Done ==\n"
    puts "== Creating up DB ==\n#{`RAILS_ENV=test rails db:create`}"
    puts "== Done ==\n"
    puts "== Migrating DB ==\n#{`RAILS_ENV=test rails db:migrate`}"
    puts "== Done ==\n"
  end
end
