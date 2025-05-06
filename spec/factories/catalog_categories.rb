# frozen_string_literal: true

FactoryBot.define do
  factory :catalog_category do
    title { Faker::Food.ethnic_category }
    description { Faker::Lorem.sentence(word_count: 10) }

    after :build do |category|
      file = Tempfile.new(['bakery', '.png'])
      path_to_file = Rails.root.join('spec/fixtures/files/bakery.png')
      file.write(File.read(path_to_file))
      file.rewind

      category.default_picture.attach(
        io: file,
        filename: 'bakery.png',
        content_type: 'image/png'
      )
    end

    trait :for_attributes do
      default_picture do
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/bakery.png'))
      end
    end

    factory :catalog_category_for_attributes, traits: [:for_attributes]
  end
end
