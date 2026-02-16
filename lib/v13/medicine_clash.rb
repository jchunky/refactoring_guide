class Integer
  def day = days
  def days = self
  def ago = Date.today - self
  def from_now = Date.today + self
end

class Date
  def advance(options = {}) = self + (options[:days] || 0)
end

module MedicineClashKata
  require 'date'

  class Prescription < Data.define(:dispense_date, :days_supply)
    def initialize(dispense_date: Date.today, days_supply: 30)
      super
    end

    def completion_date = dispense_date + days_supply
    def days_taken = (dispense_date...(dispense_date + days_supply)).to_a

    def <=>(other)
      return -1 if dispense_date.nil?
      return 1 if other.dispense_date.nil?
      dispense_date <=> other.dispense_date
    end
  end

  class Medicine
    attr_reader :name, :prescriptions

    def initialize(name)
      @name = name
      @prescriptions = []
    end

    def most_recent_prescription = prescriptions.max_by(&:dispense_date)
    def initial_dispense_date = prescriptions.min_by(&:dispense_date).dispense_date
    def possession_end_date = most_recent_prescription.completion_date
    def possession_effective_end_date = [possession_end_date, Date.today].min

    def dates_prescribed_in_effective_range(day_count)
      range = possession_effective_start_date(day_count)...possession_effective_end_date
      prescriptions
        .select { |p| range.cover?(p.dispense_date) || range.cover?(p.completion_date) }
        .flat_map(&:days_taken)
        .uniq
        .select { range.cover?(it) }
    end

    private

    def possession_effective_start_date(day_count)
      [possession_effective_end_date - day_count, initial_dispense_date].max
    end
  end

  class Patient
    attr_reader :medicines

    def initialize
      @medicines = []
    end

    def clash(medicine_names, days_back)
      taken = medicines
        .select { medicine_names.include?(it.name) }
        .reject { it.prescriptions.empty? }
      return [] if taken.size < medicine_names.size
      taken.map { it.dates_prescribed_in_effective_range(days_back) }.inject(:&)
    end
  end
end
