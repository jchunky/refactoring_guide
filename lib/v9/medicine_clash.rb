# Medicine Clash Kata
#
# Detects potential drug interactions by finding overlapping prescription periods.
# Used in healthcare systems to alert when a patient is taking multiple medications
# that might interact adversely if taken simultaneously.
#
# Key concepts:
# - Prescription: A medicine dispensed on a date with a supply lasting N days
# - Medicine: A drug with one or more prescriptions
# - Patient: Has multiple medicines, need to check for overlapping usage
# - Clash: Days when two or more specified medicines are both being taken

require 'date'

# ============================================
# DATE EXTENSIONS FOR READABILITY
# ============================================

class Integer
  # Enables readable duration expressions like "30.days"
  def day
    days
  end

  def days
    self
  end

  # Enables expressions like "7.days.ago"
  def ago
    Date.today - self
  end

  # Enables expressions like "7.days.from_now"
  def from_now
    Date.today + self
  end
end

class Date
  # Enables date advancement: date.advance(days: 5)
  def advance(options = {})
    self + (options[:days] || 0)
  end
end

# ============================================
# MEDICINE CLASH MODULE
# ============================================

module MedicineClashKata
  # Represents a single prescription of a medicine
  #
  # @attr_reader dispense_date [Date] The date the medicine was dispensed
  # @attr_reader days_supply [Integer] Number of days the prescription covers
  class Prescription
    attr_reader :dispense_date, :days_supply

    DEFAULT_DAYS_SUPPLY = 30

    def initialize(options = {})
      @dispense_date = options[:dispense_date] || Date.today
      @days_supply = options[:days_supply] || DEFAULT_DAYS_SUPPLY
    end

    # Compare prescriptions by dispense date for sorting
    def <=>(other)
      return -1 if dispense_date.nil?
      return 1 if other.dispense_date.nil?
      dispense_date <=> other.dispense_date
    end

    # The date when this prescription's supply runs out
    def completion_date
      dispense_date + days_supply
    end

    # Array of all dates this prescription covers
    def days_taken
      (dispense_date...completion_date).to_a
    end
  end

  # Represents a medicine that may have multiple prescriptions
  #
  # @attr_reader name [String] The medicine name
  # @attr_reader prescriptions [Array<Prescription>] All prescriptions for this medicine
  class Medicine
    attr_reader :name, :prescriptions

    def initialize(name)
      @name = name
      @prescriptions = []
    end

    # ============================================
    # PRESCRIPTION QUERIES
    # ============================================

    def first_prescription
      @first_prescription ||= prescriptions.min_by(&:dispense_date)
    end

    def last_prescription
      @last_prescription ||= prescriptions.max_by(&:dispense_date)
    end

    def most_recent_prescription
      prescriptions.max_by(&:dispense_date)
    end

    def initial_dispense_date
      first_prescription.dispense_date
    end

    # ============================================
    # POSSESSION DATE CALCULATIONS
    # ============================================

    # The date when the most recent prescription ends
    def possession_end_date
      most_recent_prescription.completion_date
    end

    # The effective end date (can't be in the future)
    def possession_effective_end_date
      [possession_end_date, Date.today].min
    end

    # The earliest date we consider for a date range analysis
    def possession_ratio_lower_bound_date(day_count)
      possession_effective_end_date - day_count
    end

    # The effective start date (no earlier than first prescription)
    def possession_effective_start_date(day_count)
      [possession_ratio_lower_bound_date(day_count), initial_dispense_date].max
    end

    # ============================================
    # DAYS PRESCRIBED CALCULATIONS
    # ============================================

    # Count of days with active prescription in the effective range
    def number_of_days_prescribed(day_count)
      dates_prescribed_in_effective_range(day_count).size
    end

    # Total days in the analysis range
    def number_of_days_in_range(day_count)
      possession_effective_range(day_count).to_a.size
    end

    # Prescriptions that overlap with the analysis range
    def prescriptions_in_range(day_count)
      prescriptions.select do |prescription|
        [prescription.dispense_date, prescription.completion_date].any? do |day|
          possession_effective_range(day_count).include?(day)
        end
      end
    end

    # All dates covered by prescriptions in the range
    def dates_prescribed(day_count)
      prescriptions_in_range(day_count)
        .flat_map { |prescription| prescription_date_range(prescription) }
        .uniq
    end

    # Dates prescribed that fall within the effective analysis range
    def dates_prescribed_in_effective_range(day_count)
      dates_prescribed(day_count).select do |date|
        possession_effective_range(day_count).include?(date)
      end
    end

    protected

    # The date range we're analyzing
    def possession_effective_range(day_count)
      possession_effective_start_date(day_count)...possession_effective_end_date
    end

    private

    # Convert a prescription to its date range
    def prescription_date_range(prescription)
      end_date = prescription.dispense_date.advance(days: prescription.days_supply)
      (prescription.dispense_date...end_date).to_a
    end
  end

  # Represents a patient who may take multiple medicines
  #
  # @attr_reader medicines [Array<Medicine>] All medicines the patient takes
  class Patient
    attr_reader :medicines

    def initialize
      @medicines = []
    end

    # Find dates when specified medicines overlap (potential clash)
    #
    # @param medicine_names [Array<String>] Names of medicines to check
    # @param days_back [Integer] How many days back to analyze
    # @return [Array<Date>] Dates when ALL specified medicines were being taken
    def clash(medicine_names, days_back)
      relevant_medicines = find_medicines_by_name(medicine_names)
      return [] if relevant_medicines.empty?

      # Get dates for each medicine and find the intersection
      date_sets = relevant_medicines.map do |medicine|
        medicine.dates_prescribed_in_effective_range(days_back)
      end

      # Find dates common to ALL medicines (the clash dates)
      date_sets.reduce { |intersection, dates| intersection & dates }
    end

    private

    # Find medicines that match the given names
    def find_medicines_by_name(medicine_names)
      @medicines.select { |medicine| medicine_names.include?(medicine.name) }
    end
  end
end
