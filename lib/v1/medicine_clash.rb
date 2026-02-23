# frozen_string_literal: true

require "date"

# These extensions are used by both the implementation and the tests.
# Ideally these would be refinements, but the shared test file depends on them.
class Integer
  def day = self
  def days = self
  def ago = Date.today - self
  def from_now = Date.today + self
end

module MedicineClashKata
  class Prescription < Struct.new(:dispense_date, :days_supply)
    def days_taken = (dispense_date...completion_date).to_a
    def completion_date = dispense_date + days_supply
  end

  class Medicine < Struct.new(:name, :prescriptions)
    def initialize(name) = super(name, [])

    def days_taken = prescriptions.flat_map(&:days_taken).uniq
  end

  class Patient < Struct.new(:medicines)
    def initialize = super([])

    def clash(medicine_names, days_back)
      today = Date.today
      effective_range = ((today - days_back)...today)

      medicines
        .select { |m| medicine_names.include?(m.name) }
        .map(&:days_taken)
        .reduce(&:intersection)
        .select { |d| effective_range.include?(d) }
    end
  end
end
