# frozen_string_literal: true

require "date"

# These extensions are used by both the implementation and the tests.
# Ideally these would be refinements, but the shared test file depends on them.
class Integer
  def day = days
  def days = self
  def ago = Date.today - self
  def from_now = Date.today + self
end

module MedicineClashKata
  class Prescription
    include Comparable

    attr_reader :dispense_date, :days_supply

    def initialize(dispense_date: Date.today, days_supply: 30)
      @dispense_date = dispense_date
      @days_supply = days_supply
    end

    def <=>(other)
      dispense_date <=> other.dispense_date
    end

    def completion_date = dispense_date + days_supply

    def date_range = (dispense_date...(dispense_date + days_supply))
  end

  class Medicine
    attr_reader :name, :prescriptions

    def initialize(name)
      @name = name
      @prescriptions = []
    end

    def dates_prescribed_in_effective_range(days_back)
      return [] if prescriptions.empty?

      all_dates = prescriptions.flat_map { |p| p.date_range.to_a }.uniq
      effective_range = build_effective_range(days_back)
      all_dates.select { |d| effective_range.include?(d) }
    end

    private

    def most_recent_prescription = prescriptions.max_by(&:dispense_date)
    def earliest_prescription = prescriptions.min_by(&:dispense_date)

    def build_effective_range(days_back)
      end_date = [most_recent_prescription.completion_date, Date.today].min
      start_date = [end_date - days_back, earliest_prescription.dispense_date].max
      start_date...end_date
    end
  end

  class Patient
    attr_reader :medicines

    def initialize
      @medicines = []
    end

    def clash(medicine_names, days_back)
      relevant = medicines.select { |m| medicine_names.include?(m.name) }
      return [] if relevant.empty?

      relevant
        .map { |m| m.dates_prescribed_in_effective_range(days_back) }
        .reduce { |acc, dates| acc & dates }
    end
  end
end
