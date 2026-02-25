# frozen_string_literal: true

require "date"

class Integer
  def day = days
  def days = self
  def ago = Date.today - self
  def from_now = Date.today + self
end

class Date
  def advance(options = {})
    self + (options[:days] || 0)
  end
end

module MedicineClashKata
  class Prescription
    attr_reader :dispense_date, :days_supply

    def initialize(dispense_date: Date.today, days_supply: 30)
      @dispense_date = dispense_date
      @days_supply = days_supply
    end

    def <=>(other)
      return -1 if dispense_date.nil?
      return 1 if other.dispense_date.nil?

      dispense_date <=> other.dispense_date
    end

    def completion_date
      dispense_date + days_supply
    end

    def date_range
      (dispense_date...completion_date).to_a
    end
  end

  class Medicine
    attr_reader :name, :prescriptions

    def initialize(name)
      @name = name
      @prescriptions = []
    end

    def most_recent_prescription
      prescriptions.max_by(&:dispense_date)
    end

    def initial_dispense_date
      prescriptions.min_by(&:dispense_date).dispense_date
    end

    def possession_end_date
      most_recent_prescription.completion_date
    end

    def possession_effective_end_date
      [possession_end_date, Date.today].min
    end

    def dates_prescribed_in_effective_range(day_count)
      return [] if prescriptions.empty?

      effective_range = effective_range_for(day_count)
      all_prescribed_dates(day_count).select { |d| effective_range.include?(d) }
    end

    private

    def effective_range_for(day_count)
      start_date = [possession_effective_end_date - day_count, initial_dispense_date].max
      start_date...possession_effective_end_date
    end

    def all_prescribed_dates(day_count)
      effective_range = effective_range_for(day_count)

      prescriptions
        .select { |p| overlaps_range?(p, effective_range) }
        .flat_map(&:date_range)
        .uniq
    end

    def overlaps_range?(prescription, range)
      range.include?(prescription.dispense_date) || range.include?(prescription.completion_date)
    end
  end

  class Patient
    attr_reader :medicines

    def initialize
      @medicines = []
    end

    def clash(medicine_names, days_back)
      relevant_medicines = medicines.select { |m| medicine_names.include?(m.name) }
      return [] if relevant_medicines.empty?

      date_sets = relevant_medicines.map { |m| m.dates_prescribed_in_effective_range(days_back) }
      date_sets.reduce(:&)
    end
  end
end
