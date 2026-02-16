class Integer
  def day = self
  def days = self
  def ago = Date.today - self
  def from_now = Date.today + self
end

module MedicineClashKata
  require "date"

  class Prescription < Data.define(:dispense_date, :days_supply)
    def days_taken = (dispense_date...completion_date).to_a
    def completion_date = dispense_date + days_supply
  end

  class Medicine < Data.define(:name, :prescriptions)
    def initialize(name:, prescriptions: []) = super
    def days_taken = prescriptions.flat_map(&:days_taken).uniq
  end

  class Patient < Data.define(:medicines)
    def initialize = super(medicines: [])

    def clash(medicine_names, days_back)
      today = Date.today
      date_range = ((today - days_back)...today)
      medicines.select { |medicine| medicine_names.include?(medicine.name) }
        .map(&:days_taken)
        .reduce(&:intersection)
        .select do |d|
          date_range.cover?(d)
        end
    end
  end
end
