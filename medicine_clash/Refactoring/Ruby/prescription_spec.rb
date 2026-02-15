require 'date'

require_relative "prescription"
require_relative "days_ago"

describe Prescription do
  describe "#completion_date" do
    let(:prescription) do
      Prescription.new(:dispense_date => 15.days.ago, :days_supply => 30)
    end
    it 'is <days_supply> after <dispense_date>' do
      expect(prescription.completion_date).to eq(15.days.from_now.to_date)
    end
  end
end