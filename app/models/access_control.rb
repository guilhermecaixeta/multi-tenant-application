# frozen_string_literal: true
# typed: true

# Model
class AccessControl < ApplicationRecord
  belongs_to :controlable,
             polymorphic: true

  before_save :update_active_until,
              if: [proc { |r| !r.active }]

  scope :only_active, lambda {
    query = <<~QUERY
      (access_controls.active
        AND access_controls.active_from IS NULL
        AND access_controls.active_until IS NULL)
      OR (access_controls.active
        AND access_controls.active_from IS NOT NULL
        AND access_controls.active_until IS NULL
        AND access_controls.active_from <= CURRENT_TIMESTAMP)
      OR (access_controls.active
        AND access_controls.active_from IS NOT NULL
        AND access_controls.active_until IS NOT NULL
        AND access_controls.active_from <= CURRENT_TIMESTAMP
        AND access_controls.active_until >= CURRENT_TIMESTAMP)
      OR (access_controls.active
        AND access_controls.active_from IS NOT NULL
        AND access_controls.active_until IS NULL
        AND (access_controls.active_from <= CURRENT_TIMESTAMP))
    QUERY

    where(query.to_s)
  }

  def initialize(attributes = {})
    super

    self.active = false if active.nil?
    self.active_from = today if active_from.nil?
  end

  def active?
    active && active_from? && (active_until.nil? || active_until?)
  end

  private

  def today
    Time.zone.today.to_date
  end

  def update_active_until
    self.active_until = Time.zone.today
  end

  def active_until?
    active_until.present? && T.must(active_until).to_date >= today
  end

  def active_from?
    T.must(active_from).to_date <= today
  end
end
