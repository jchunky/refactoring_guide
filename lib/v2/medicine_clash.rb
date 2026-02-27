# frozen_string_literal: true

require "date"

class Integer
  def day = self
  def days = self
  def ago = Date.today - self
  def from_now = Date.today + self
end

module MedicineClashKata
  class Prescription < Data.define(:dispense_date, :days_supply)
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
        .select { |medicine| medicine_names.include?(medicine.name) }
        .map(&:days_taken)
        .reduce(&:intersection)
        .select { |date| effective_range.include?(date) }
    end
  end
end
