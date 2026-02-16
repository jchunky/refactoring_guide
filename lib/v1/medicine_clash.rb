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
  require 'date'

  class Prescription
    attr_reader :dispense_date, :days_supply

    DEFAULT_DAYS_SUPPLY = 30

    def initialize(options = {})
      @dispense_date = options[:dispense_date] || Date.today
      @days_supply = options[:days_supply] || DEFAULT_DAYS_SUPPLY
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
      date_range.to_a
    end

    private

    def date_range
      dispense_date...(dispense_date + days_supply)
    end
  end

  class Medicine
    attr_reader :name, :prescriptions

    def initialize(name)
      @name = name
      @prescriptions = []
    end

    def possession_end_date
      most_recent_prescription.completion_date
    end

    def possession_effective_end_date
      [possession_end_date, Date.today].min
    end

    def possession_ratio_lower_bound_date(day_count)
      possession_effective_end_date - day_count
    end

    def possession_effective_start_date(day_count)
      [possession_ratio_lower_bound_date(day_count), initial_dispense_date].max
    end

    def initial_dispense_date
      first_prescription.dispense_date
    end

    def number_of_days_prescribed(day_count)
      dates_prescribed_in_effective_range(day_count).size
    end

    def prescriptions_in_range(day_count)
      effective_range = possession_effective_range(day_count)
      prescriptions.select { |p| prescription_overlaps_range?(p, effective_range) }
    end

    def dates_prescribed(day_count)
      prescriptions_in_range(day_count)
        .flat_map { |p| prescription_date_range(p).to_a }
        .uniq
    end

    def dates_prescribed_in_effective_range(day_count)
      effective_range = possession_effective_range(day_count)
      dates_prescribed(day_count).select { |date| effective_range.include?(date) }
    end

    protected

    def possession_effective_range(day_count)
      possession_effective_start_date(day_count)...possession_effective_end_date
    end

    private

    def first_prescription
      @first_prescription ||= sorted_prescriptions.first
    end

    def most_recent_prescription
      @most_recent_prescription ||= sorted_prescriptions.last
    end

    def sorted_prescriptions
      @sorted_prescriptions ||= prescriptions.sort_by(&:dispense_date)
    end

    def prescription_overlaps_range?(prescription, range)
      range.include?(prescription.dispense_date) || range.include?(prescription.completion_date)
    end

    def prescription_date_range(prescription)
      prescription.dispense_date...prescription.dispense_date.advance(days: prescription.days_supply)
    end
  end

  class Patient
    attr_reader :medicines

    def initialize
      @medicines = []
    end

    def clash(medicine_names, days_back)
      relevant_medicines = medicines_by_names(medicine_names)
      medicines_with_prescriptions = relevant_medicines.select { |m| m.prescriptions.any? }
      return [] if medicines_with_prescriptions.size < 2

      find_overlapping_dates(medicines_with_prescriptions, days_back)
    end

    private

    def medicines_by_names(names)
      medicines.select { |medicine| names.include?(medicine.name) }
    end

    def find_overlapping_dates(medicines, days_back)
      date_sets = medicines.map { |m| m.dates_prescribed_in_effective_range(days_back) }
      date_sets.reduce { |intersection, dates| intersection & dates } || []
    end
  end
end
