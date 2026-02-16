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
  # Refactored to fix:
  # - Feature Envy: DateRange handles its own intersection logic
  # - Data Clumps: Date range data grouped into DateRange class
  require 'date'



  # Data Clump: Date range with start and end dates
  class DateRange
    attr_reader :start_date, :end_date

    def initialize(start_date, end_date)
      @start_date = start_date
      @end_date = end_date
    end

    def to_a
      (start_date...end_date).to_a
    end

    def include?(date)
      date >= start_date && date < end_date
    end

    def overlap?(other)
      start_date < other.end_date && end_date > other.start_date
    end

    def intersection(other)
      return nil unless overlap?(other)
      DateRange.new(
        [start_date, other.start_date].max,
        [end_date, other.end_date].min
      )
    end
  end

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

    def date_range
      DateRange.new(dispense_date, completion_date)
    end

    def days_taken
      date_range.to_a
    end
  end

  class Medicine
    attr_reader :name, :prescriptions

    def initialize(name)
      @name = name
      @prescriptions = []
    end

    def first_prescription
      @first_prescription ||= prescriptions.sort.first
    end

    def last_prescription
      @last_prescription ||= prescriptions.sort.last
    end

    def days_supply
      valid_prescriptions? ? last_prescription.days_supply : read_attribute(:days_supply)
    end

    def possession_end_date
      most_recent_prescription&.completion_date
    end

    def possession_effective_end_date
      end_date = possession_end_date
      return Date.today unless end_date
      [end_date, Date.today].min
    end

    def possession_ratio_lower_bound_date(day_count)
      possession_effective_end_date - day_count
    end

    def possession_effective_start_date(day_count)
      start_date = initial_dispense_date
      return possession_ratio_lower_bound_date(day_count) unless start_date
      [possession_ratio_lower_bound_date(day_count), start_date].max
    end

    def initial_dispense_date
      first_prescription&.dispense_date
    end

    def most_recent_prescription
      prescriptions.sort_by(&:dispense_date).last
    end

    def effective_range(day_count)
      DateRange.new(
        possession_effective_start_date(day_count),
        possession_effective_end_date
      )
    end

    def number_of_days_prescribed(day_count)
      dates_prescribed_in_effective_range(day_count).size
    end

    def number_of_days_in_range(day_count)
      effective_range(day_count).to_a.size
    end

    def prescriptions_in_range(day_count)
      return [] if prescriptions.empty?
      range = effective_range(day_count)
      prescriptions.select do |p|
        p.date_range.overlap?(range)
      end
    end

    def dates_prescribed(day_count)
      prescriptions_in_range(day_count)
        .flat_map(&:days_taken)
        .uniq
    end

    def dates_prescribed_in_effective_range(day_count)
      return [] if prescriptions.empty?
      range = effective_range(day_count)
      dates_prescribed(day_count).select { |d| range.include?(d) }
    end
  end

  class Patient
    attr_reader :medicines

    def initialize
      @medicines = []
    end

    def clash(medicine_names, days_back)
      medicines_taken = medicines_taken_from(medicine_names)
      return [] if medicines_taken.empty?
      return [] if medicines_taken.size < 2

      all_dates = medicines_taken.map { |medicine| medicine.dates_prescribed_in_effective_range(days_back) }
      all_dates.inject { |x, y| x & y }
    end

    def medicines_taken_from(medicine_names)
      @medicines.select { |medicine| medicine_names.include?(medicine.name) }
    end
  end
end
