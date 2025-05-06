# frozen_string_literal: true

namespace :db do
  desc 'Fix db sequence'
  task fix_sequence: :environment do
    puts "== Fixing DB Sequence ==\n"
    ActiveRecord::Base.connection.tables.each do |table_name|
      ActiveRecord::Base.connection.reset_pk_sequence!(table_name)
    end
    puts "== Done ==\n"
  end

  desc 'Kick out PostgreSQL users from the database.'
  task kick: [:environment] do
    ActiveRecord::Base.connection.execute <<-SQL.squish
        SELECT pg_terminate_backend(pg_stat_activity.pid)
        FROM pg_stat_activity
        WHERE pg_stat_activity.datname = '#{ActiveRecord::Base.connection.current_database}';
    SQL
  rescue ActiveRecord::StatementInvalid
    puts 'All connections killed.'
  end
end
