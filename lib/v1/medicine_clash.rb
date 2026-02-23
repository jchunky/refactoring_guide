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
  def advance(options={})
    self + (options[:days] || 0)
  end
end

module MedicineClashKata
  require 'date'

  class Prescription

    attr_reader :dispense_date, :days_supply

    def initialize(options = {})
      @dispense_date = options[:dispense_date] ||= Date.today
      @days_supply = options[:days_supply] ||= 30
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

    def most_recent_prescription
      prescriptions.sort_by(&:dispense_date).last
    end

    def number_of_days_prescribed(day_count)
      dates_prescribed_in_effective_range(day_count).size
    end

    def number_of_days_in_range(day_count)
      possession_effective_range(day_count).to_a.size
    end

    def prescriptions_in_range(day_count)
      prescriptions.select do |p|
        [p.dispense_date, p.completion_date].any? do |day|
          possession_effective_range(day_count).include?(day)
        end
      end
    end

    def dates_prescribed(day_count)
      prescriptions_in_range(day_count).map do |p|
        (p.dispense_date...p.dispense_date.advance(:days => p.days_supply)).to_a
      end.flatten.uniq
    end

    def dates_prescribed_in_effective_range(day_count)
      dates_prescribed(day_count).select do |d|
        possession_effective_range(day_count).include?(d)
      end
    end

    protected

    def possession_effective_range(day_count)
      possession_effective_start_date(day_count)...possession_effective_end_date
    end

  end

  class Patient

    attr_reader :medicines

    def initialize()
      @medicines = []
    end

    def clash(medicine_names, days_back)
      medicines_taken = medicines_taken_from(medicine_names)
      return [] if medicines_taken.empty?
      all_dates = medicines_taken.map { |medicine| medicine.dates_prescribed_in_effective_range(days_back)}
      all_dates.inject{|x, y| x & y}
    end

    def medicines_taken_from(medicine_names)
      @medicines.select { |medicine| medicine_names.include?(medicine.name) }
    end

  end
end
