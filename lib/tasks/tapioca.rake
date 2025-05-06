# frozen_string_literal: true

namespace :tapioca do
  namespace :update do
    desc 'Update Tapioca RBIs.'
    task all: :environment do
      Bundler.with_unbundled_env do
        # Pull in community-created RBIs for popular gems, such as Faker.

        # If you want to use a fork of sorbet-typed for any reason, you can set
        # SRB_SORBET_TYPED_REPO to the git URL and SRB_SORBET_TYPED_REVISION
        # to the "origin/master"-type branch reference).
        puts '\n== Updating annotations =='
        system('bin/tapioca annotations')

        # Use Tapioca to generate RBIs for gems
        puts '\n== Generating RBIs for gems =='
        system('bin/tapioca gems --all')

        # User Tapioca to generate DSL
        puts '\n== Generating DSLs =='
        system('bin/tapioca dsl')

        # Checking shims
        puts '\n== Checking shims =='
        system('bin/tapioca check-shims')

        # Bump the strictness from all files currently at typed: false to typed: true where it does not create
        # typechecking errors.
        puts '\n== Bumping the strictness from all files currently at typed: false to typed: true =='
        system('spoom srb bump --from false --to true')

        # Count the number of type-checking errors if all files were bumped to true
        puts '\n== Counting the number of type-checking errors if all files were bumped to true =='
        system('spoom srb bump --count-errors --dry')
      end
    end
  end
end
