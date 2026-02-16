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

    def completion_date
      dispense_date + days_supply
    end

    def days_taken
      (dispense_date...(dispense_date + days_supply)).to_a
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

    def possession_effective_start_date(day_count)
      lower_bound = possession_effective_end_date - day_count
      [lower_bound, initial_dispense_date].max
    end

    def dates_prescribed_in_effective_range(day_count)
      return [] if prescriptions.empty?
      range = effective_range(day_count)
      prescriptions_in_range(day_count)
        .flat_map(&:days_taken)
        .uniq
        .select { |d| range.include?(d) }
    end

    private

    def effective_range(day_count)
      possession_effective_start_date(day_count)...possession_effective_end_date
    end

    def prescriptions_in_range(day_count)
      range = effective_range(day_count)
      prescriptions.select do |p|
        range.include?(p.dispense_date) || range.include?(p.completion_date)
      end
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
      date_sets.inject(:&)
    end
  end
end
