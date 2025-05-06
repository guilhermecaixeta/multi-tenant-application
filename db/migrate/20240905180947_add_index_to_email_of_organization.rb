# frozen_string_literal: true

class AddIndexToEmailOfOrganization < ActiveRecord::Migration[7.1]
  def change
    add_index(:organizations, :email, if_not_exists: true)
  end
end
