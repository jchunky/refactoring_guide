class Integer
  def day
    days
  end

  def days
    self
  end

  def ago
    Date.today - self
  end

  def from_now
    Date.today + self
  end
end

class Date
  def advance(options = {})
    self + (options[:days] || 0)
  end
end

module MedicineClashKata
  # Refactored using 99 Bottles of OOP principles:
  # - Small methods that do one thing
  # - Names reflect roles
  # - Removed unused/dead code paths
  # - Consistent approach to date range handling

  require 'date'

  class Prescription
    attr_reader :dispense_date, :days_supply

    def initialize(options = {})
      @dispense_date = options[:dispense_date] || Date.today
      @days_supply = options[:days_supply] || 30
    end

    def <=>(other)
      return -1 if dispense_date.nil?
      return 1 if other.dispense_date.nil?
      dispense_date <=> other.dispense_date
    end

    def completion_date
      dispense_date + days_supply
    end

    def days_taken
      (dispense_date...completion_date).to_a
    end

    def covers_date?(date)
      date >= dispense_date && date < completion_date
    end
  end

  class Medicine
    attr_reader :name, :prescriptions

    def initialize(name)
      @name = name
      @prescriptions = []
    end

    def dates_prescribed_in_range(day_count)
      return [] if prescriptions.empty?
      effective_range = build_effective_range(day_count)
      all_prescribed_dates.select { |date| effective_range.include?(date) }
    end

    private

    def all_prescribed_dates
      prescriptions.flat_map(&:days_taken).uniq
    end

    def build_effective_range(day_count)
      start_date = effective_start_date(day_count)
      end_date = effective_end_date
      (start_date...end_date)
    end

    def effective_start_date(day_count)
      lower_bound = effective_end_date - day_count
      [lower_bound, initial_dispense_date].max
    end

    def effective_end_date
      [most_recent_completion_date, Date.today].min
    end

    def initial_dispense_date
      sorted_prescriptions.first.dispense_date
    end

    def most_recent_completion_date
      sorted_prescriptions.last.completion_date
    end

    def sorted_prescriptions
      @sorted_prescriptions ||= prescriptions.sort_by(&:dispense_date)
    end
  end

  class Patient
    attr_reader :medicines

    def initialize
      @medicines = []
    end

    def clash(medicine_names, days_back)
      relevant_medicines = medicines_by_names(medicine_names)
      return [] if relevant_medicines.empty?

      date_sets = relevant_medicines.map { |med| med.dates_prescribed_in_range(days_back) }
      date_sets.reduce(:&) || []
    end

    private

    def medicines_by_names(names)
      medicines.select { |medicine| names.include?(medicine.name) }
    end
  end
end
