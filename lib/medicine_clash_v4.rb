require 'date'

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
end

class Medicine
  attr_reader :name, :prescriptions

  def initialize(name)
    @name = name
    @prescriptions = []
  end

  def dates_prescribed_in_effective_range(days_back)
    return [] if prescriptions.empty?
    effective_range = effective_date_range(days_back)
    all_dates_prescribed.select { |d| effective_range.include?(d) }
  end

  private

  def effective_date_range(days_back)
    end_date = [most_recent_completion, Date.today].min
    start_date = [end_date - days_back, earliest_dispense].max
    start_date...end_date
  end

  def most_recent_completion
    prescriptions.map(&:completion_date).max
  end

  def earliest_dispense
    prescriptions.map(&:dispense_date).min
  end

  def all_dates_prescribed
    prescriptions.flat_map(&:days_taken).uniq
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

    date_sets = relevant.map { |m| m.dates_prescribed_in_effective_range(days_back) }
    date_sets.reduce(:&)
  end
end
