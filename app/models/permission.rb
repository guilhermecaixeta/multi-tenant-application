# frozen_string_literal: true
# typed: true

# Model
class Permission < ApplicationRecord
  has_and_belongs_to_many :roles

  def self.group_permissions(permissions)
    result = []

    permissions.each do |permission|
      parts = permission.scope.split('::')
      build_group(result, parts)
    end

    result
  end

  def self.build_group(result, parts)
    return if parts.empty?

    key = parts.shift.to_sym
    sub_hash = find_or_create_sub_hash(result, key)

    # If there are no more parts, just assign the key's value
    if parts.empty?
      sub_hash[key] = key.to_s
    else
      sub_group_key = parts.shift.to_sym
      sub_hash[key] ||= {}
      sub_hash[key][sub_group_key] = build_group(sub_hash[key][sub_group_key] || {}, parts)
    end
  end

  def self.find_or_create_sub_hash(result, key)
    # Find existing group by key or create a new one
    existing_group = result.find { |h| h.key?(key) }

    unless existing_group
      existing_group = { key => [] }
      result << existing_group
    end

    existing_group[key]
  end
end
