require 'date'

class Integer
  def day = days
  def days = self
  def ago = Date.today - self
  def from_now = Date.today + self
end

class Date
  def advance(options = {}) = self + (options[:days] || 0)
end

class Prescription < Struct.new(:dispense_date, :days_supply, keyword_init: true)
  def initialize(dispense_date: Date.today, days_supply: 30)
    super
  end

  def <=>(other)
    return -1 if dispense_date.nil?
    return 1 if other.dispense_date.nil?
    dispense_date <=> other.dispense_date
  end

  def completion_date = dispense_date + days_supply

  def days_taken = (dispense_date...completion_date).to_a
end

class Medicine
  attr_reader :name, :prescriptions

  def initialize(name)
    @name = name
    @prescriptions = []
  end

  def first_prescription = @first_prescription ||= prescriptions.min
  def last_prescription = @last_prescription ||= prescriptions.max
  def initial_dispense_date = first_prescription.dispense_date
  def most_recent_prescription = prescriptions.max_by(&:dispense_date)
  def possession_end_date = most_recent_prescription.completion_date
  def possession_effective_end_date = [possession_end_date, Date.today].min

  def days_supply
    valid_prescriptions? ? last_prescription.days_supply : read_attribute(:days_supply)
  end

  def possession_ratio_lower_bound_date(day_count) = possession_effective_end_date - day_count

  def possession_effective_start_date(day_count)
    [possession_ratio_lower_bound_date(day_count), initial_dispense_date].max
  end

  def number_of_days_prescribed(day_count) = dates_prescribed_in_effective_range(day_count).size
  def number_of_days_in_range(day_count) = possession_effective_range(day_count).to_a.size

  def prescriptions_in_range(day_count)
    prescriptions.select do |p|
      [p.dispense_date, p.completion_date].any? { possession_effective_range(day_count).include?(it) }
    end
  end

  def dates_prescribed(day_count)
    prescriptions_in_range(day_count)
      .flat_map { (it.dispense_date...it.dispense_date.advance(days: it.days_supply)).to_a }
      .uniq
  end

  def dates_prescribed_in_effective_range(day_count)
    dates_prescribed(day_count).select { possession_effective_range(day_count).include?(it) }
  end

  protected

  def possession_effective_range(day_count)
    possession_effective_start_date(day_count)...possession_effective_end_date
  end
end

class Patient
  attr_reader :medicines

  def initialize
    @medicines = []
  end

  def clash(medicine_names, days_back)
    taken = medicines_taken_from(medicine_names)
    return [] if taken.empty?

    taken
      .map { it.dates_prescribed_in_effective_range(days_back) }
      .reduce(&:intersection)
  end

  def medicines_taken_from(medicine_names)
    medicines.select { medicine_names.include?(it.name) }
  end
end
