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

    def completion_date = dispense_date + days_supply

    def days_taken
      (dispense_date...completion_date).to_a
    end
  end

  class Medicine
    attr_reader :name, :prescriptions

    def initialize(name)
      @name = name
      @prescriptions = []
    end

    def first_prescription = sorted_prescriptions.first
    def last_prescription = sorted_prescriptions.last
    def initial_dispense_date = first_prescription&.dispense_date
    def most_recent_prescription = prescriptions.max_by(&:dispense_date)

    def possession_end_date
      most_recent_prescription&.completion_date
    end

    def possession_effective_end_date
      return Date.today if possession_end_date.nil?
      [possession_end_date, Date.today].min
    end

    def possession_effective_start_date(day_count)
      return Date.today if initial_dispense_date.nil?
      [possession_ratio_lower_bound_date(day_count), initial_dispense_date].max
    end

    def dates_prescribed_in_effective_range(day_count)
      return [] if prescriptions.empty?
      dates_prescribed(day_count) & possession_effective_range(day_count).to_a
    end

    private

    def sorted_prescriptions = prescriptions.sort
    def possession_ratio_lower_bound_date(day_count) = possession_effective_end_date - day_count

    def possession_effective_range(day_count)
      possession_effective_start_date(day_count)...possession_effective_end_date
    end

    def dates_prescribed(day_count)
      prescriptions_in_range(day_count).flat_map(&:days_taken).uniq
    end

    def prescriptions_in_range(day_count)
      prescriptions.select { |p| prescription_in_range?(p, day_count) }
    end

    def prescription_in_range?(prescription, day_count)
      range = possession_effective_range(day_count)
      range.cover?(prescription.dispense_date) || range.cover?(prescription.completion_date)
    end
  end

  class Patient
    attr_reader :medicines

    def initialize
      @medicines = []
    end

    def clash(medicine_names, days_back)
      selected = medicines_taken_from(medicine_names)
      return [] if selected.empty?
      return [] if selected.length < 2
      find_clash_dates(selected, days_back)
    end

    private

    def medicines_taken_from(names)
      @medicines.select { |m| names.include?(m.name) }
    end

    def find_clash_dates(medicines, days_back)
      all_dates = medicines.map { |m| m.dates_prescribed_in_effective_range(days_back) }
      all_dates.reduce(:&)
    end
  end
end
