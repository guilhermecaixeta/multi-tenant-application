# rubocop:disable Metrics/BlockLength
# frozen_string_literal: true

require 'open-uri'
require 'uri'

namespace :dev do
  desc 'Recreate'
  task recreate: :environment do
    next if Rails.env.production?

    puts '== Recreating development environment == \n'
    puts "== Closing Connections Development ==\n#{`RAILS_ENV=development rails db:kick`}"
    puts "== Closing Connections Test ==\n#{`RAILS_ENV=test rails db:kick`}"
    puts "== Done ==\n"
    puts "== Dropping DB Development ==\n#{`RAILS_ENV=development rails db:drop`}"
    puts "== Dropping DB Test ==\n#{`RAILS_ENV=test rails db:drop`}"
    puts "== Done ==\n"
    puts "== Creating up DB Development ==\n#{`RAILS_ENV=development rails db:create`}"
    puts "== Creating up DB Test ==\n#{`RAILS_ENV=test rails db:create`}"
    puts "== Done ==\n"
    puts "== Migrating DB Development ==\n#{`RAILS_ENV=development rails db:migrate`}"
    puts "== Migrating DB Test ==\n#{`RAILS_ENV=test rails db:migrate`}"
    puts "== Done ==\n"
    puts "== Seeding DB ==\n#{`rails db:seed`}"
    puts "== Done ==\n"
    puts `rails dev:seed`
    puts '== Done ==\n'
  end

  desc 'Setup'
  task setup: :environment do
    next if Rails.env.production?

    puts "== Closing Connections Development ==\n#{`RAILS_ENV=development rails db:kick`}"
    puts "== Closing Connections Test ==\n#{`RAILS_ENV=test rails db:kick`}"
    puts "== Done ==\n"
    puts "== Setting up DB Development ==\n#{`RAILS_ENV=development rails db:setup`}"
    puts "== Setting up DB Test ==\n#{`RAILS_ENV=test rails db:setup`}"
    puts "== Done ==\n"
    puts `rails dev:seed`
  end

  desc 'Seed'
  task seed: :environment do
    next unless Rails.env.development?

    puts "== Setup authorization ==\n#{`rails authorization:setup`}"
    puts `rails dev:organization`
    puts `rails dev:admin`
    puts `rails dev:operator`
    puts `rails dev:organization_categories`
    puts `rails dev:organization_stocks`
    puts `rails dev:organization_entries`
  end

  desc 'Build and clean development environment'
  task build_and_clean: :environment do
    next unless Rails.env.development?

    puts "\n== Cleaning rails =="
    puts "Cleaning assets\n#{`rails assets:clobber`}"
    puts "Cleaning sitemap\n#{`rails sitemap:clean`}"
    puts "Cleaning logs\n#{`rails log:clear`}"
    puts "Cleaning tmp\n#{`rails tmp:clear`}"

    puts "\n== Restarting application server =="
    `bin/rails restart`
  end

  desc 'Generate admin user'
  task admin: :environment do
    return unless Rails.env.development?

    puts "\n== Adding admin user =="
    time_now = Time.zone.now
    name = Faker::Name
    admin_profile = Profile.new(first_name: name.first_name,
                                last_name: name.last_name,
                                birthdate: Faker::Date.between(from: '01-01-1950', to: '01-01-2006'))
    admin = User.create(
      access_control: AccessControl.new(active: true),
      profile: admin_profile,
      email: Rails.configuration.x.authorization.default_user_email,
      confirmed_at: time_now,
      user_roles: [UserRole.new(role_id: Role.select(:id).find_by(admin: true).id)]
    )
    admin.skip_confirmation!
    admin.skip_confirmation_notification!
    puts "\n== Done =="
  end

  desc 'Generate operator user'
  task operator: :environment do
    return unless Rails.env.development?

    current_datetime = Time.zone.now

    puts "\n== Adding operator =="
    name = Faker::Name
    operator_profile = Profile.new(first_name: name.first_name,
                                   last_name: name.last_name,
                                   birthdate: Faker::Date.between(from: '01-01-1950', to: '01-01-2006'))

    operator = User.create(
      access_control: AccessControl.new(active: true),
      profile: operator_profile,
      email: 'operator.default@acme.com',
      confirmed_at: current_datetime,
      user_roles: [UserRole.new(role_id: Role.select(:id).find_by(admin: false).id)],
      organization_users: [OrganizationUser.new(organization_id: Organization.first.id,
                                                principal: true)]
    )
    operator.skip_confirmation!
    operator.skip_confirmation_notification!
    puts "\n== Done =="
  end

  desc 'Generate organization'
  task organization: :environment do
    return unless Rails.env.development?

    puts "\n== Adding Organizations =="
    company = Faker::Company
    total = Rails.configuration.x.mock[:organization][:number]

    organization_names = []
    total.times { organization_names << company.name }

    organization_names.uniq.each_with_index do |name, index|
      puts "\n#{index}/#{total}"

      profile = OrganizationProfile.build(slogan: Faker::Lorem.paragraph(sentence_count: 5),
                                          about: Faker::Lorem.paragraph(sentence_count: 25))

      puts "\n#{Organization.model_name.human(count: 1)}: #{name}"

      organization = Organization.build name:,
                                        domain: "#{name.parameterize}.com.br",
                                        email: "naoresponda@#{name.parameterize}.com.br",
                                        code: Random.uuid,
                                        organization_profile: profile,
                                        access_control: AccessControl.new(active: true)

      organization.logo.attach(io: URI.open(company.logo),
                               filename: "#{name.tableize}.jpg",
                               content_type: 'image/jpeg')

      organization.save!
    end
    puts "\n== Done =="
  end

  desc 'Seed with mock data the organization'
  task organization_categories: :environment do
    return unless Rails.env.development?

    puts "\n== Adding organization categories =="
    total = Rails.configuration.x.mock[:catalog_category][:number]
    organization_total = Organization.count
    counter = 1
    Organization.find_each do |org|
      org.run_on_tenant proc {
                          puts "\n#{Organization.model_name.human(count: 1)}: #{counter}/#{organization_total}"
                          category_names = []
                          total.times { category_names << Faker::Food.ethnic_category }
                          category_names.uniq.each_with_index do |name, index|
                            puts "\n#{CatalogCategory.model_name.human(count: 1)}: #{index + 1}/#{total}"

                            puts "\n#{CatalogCategory.model_name.human(count: 1)}: #{name}"

                            category = CatalogCategory.build title: name,
                                                             description: Faker::Lorem.paragraph(sentence_count: 5)

                            image_url = Faker::LoremFlickr.image(search_terms: ["#{name.parameterize}-cuisine"])

                            category.default_picture.attach(io: URI.parse(image_url).open,
                                                            filename: "#{name.tableize}.jpg",
                                                            content_type: 'image/jpeg')

                            category.save!
                            counter + 1
                          end
                        }
      puts "\n== Done =="
    end
  end

  desc 'Seed with organization stock'
  task organization_stocks: :environment do
    puts "\n== Adding organization stocks =="
    total = Rails.configuration.x.mock[:stock][:number]
    organization_total = Organization.count
    counter = 1
    food = Faker::Food
    number = Faker::Number
    Organization.find_each do |org|
      org.run_on_tenant proc {
                          puts "\n#{Organization.model_name.human(count: 1)}: #{counter}/#{organization_total}"
                          units = Unit.all.to_a
                          ingredients = []
                          total.times { ingredients << food.ingredient }
                          ingredients.uniq.each_with_index do |name, index|
                            puts "\n#{Stock.model_name.human(count: 1)}: #{index}/#{total}"

                            stock = Stock.build(name:,
                                                measure: Measure.build(unit: units.shuffle.sample,
                                                                       quantity: number.positive(from: 10, to: 10_000)))

                            puts "\n#{Stock.model_name.human(count: 1)}: #{name}"

                            stock.save
                          end
                        }

      puts "\n== Done =="
    end
  end

  desc 'Seed with organization entries'
  task organization_entries: :environment do
    puts "\n== Adding organization entries =="
    organization_total = Organization.count
    counter = 1
    number = Faker::Number
    Organization.find_each do |org|
      org.run_on_tenant proc {
                          puts "\n#{Organization.model_name.human(count: 1)}: #{counter}/#{organization_total}"
                          Stock.find_each do |stock|
                            entry = Entry.build stock_id: stock.id,
                                                validity: Faker::Date.between(from: 1.year.from_now,
                                                                              to: 3.years.from_now),
                                                total_items: Faker::Number.between(from: 1, to: 10),
                                                price: Price.new(price_cents: number.positive(from: 150, to: 9999),
                                                                 category: :price)

                            puts "\n#{Entry.model_name.human(count: 1)}: #{stock.name}"
                            entry.save
                          end
                        }

      puts "\n== Done =="
    end
  end
end
# rubocop:enable Metrics/BlockLength
