require 'bigdecimal'
require 'rspec'

require_relative "../lib/version_loader"
VersionLoader.require_kata('medicine_clash')

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

describe Medicine do
  describe "#possession_end_date" do
    let(:medicine) do
      Medicine.new("Aspirin").tap do |m|
        m.prescriptions << Prescription.new(:dispense_date => Date.strptime('12/01/2009', '%m/%d/%Y'), :days_supply => 30)
      end
    end
  
    it "returns the sum of the most recent prescription's dispense date and its days supply" do
      expect(medicine.possession_end_date).to eq(Date.strptime('12/31/2009', '%m/%d/%Y'))
    end
  end
  
  describe "#possession_effective_end_date" do
    context "when ending before today's date" do
      let(:medicine) do
        Medicine.new("Aspirin").tap do |m|
          m.prescriptions << Prescription.new(:dispense_date => 40.days.ago, :days_supply => 30)
        end
      end
  
      it "returns the end date" do
        expect(medicine.possession_effective_end_date).to eq(medicine.possession_end_date)
      end
    end
    context "when in theory it would end after today's date" do
      let(:medicine) do
        Medicine.new("Aspirin").tap do |m|
          m.prescriptions << Prescription.new(:dispense_date => 15.days.ago, :days_supply => 30)
        end
      end
  
      it "returns today's date" do
        expect(medicine.possession_effective_end_date).to eq(Date.today)
      end
    end
  end
  
  describe "#initial_dispense_date" do
    let(:medicine) do
      Medicine.new("Aspirin").tap do |m|
        m.prescriptions << Prescription.new(:dispense_date => Date.strptime('11/01/2009', '%m/%d/%Y'), :days_supply => 30)
        m.prescriptions << Prescription.new(:dispense_date => Date.strptime('11/30/2009', '%m/%d/%Y'), :days_supply => 30)
      end
    end
  
    it "returns the first prescriptions dispense date" do
      expect(medicine.initial_dispense_date).to eq(Date.strptime('11/01/2009', '%m/%d/%Y'))
    end
  end
  
  describe "#possession_ratio_lower_bound_date" do
    let(:medicine) do
      Medicine.new("Aspirin").tap do |m|
        allow(m).to receive(:possession_effective_end_date).and_return(Date.strptime('12/30/2009', '%m/%d/%Y'))
      end
    end
    it "is the difference of effective end date and the day count" do
      expect(medicine.possession_ratio_lower_bound_date(90)).to eq(Date.strptime('10/01/2009', '%m/%d/%Y'))
    end
  end
  
  describe "#possession_effective_start_date" do
    context "when the initial dispense date is after the lower bound date" do
      let(:medicine) do
        Medicine.new("Aspirin").tap do |m|
          m.prescriptions << Prescription.new(:dispense_date => Date.strptime('12/01/2009', '%m/%d/%Y'), :days_supply => 30)
          allow(m).to receive(:possession_ratio_lower_bound_date).and_return(Date.strptime('11/30/2009', '%m/%d/%Y'))
        end
      end
      it "returns the initial dispense date" do
        expect(medicine.possession_effective_start_date(90)).to eq(medicine.initial_dispense_date)
      end
    end
    context "when the initial dispense date is before the lower bound date" do
      let(:medicine) do
        Medicine.new("Aspirin").tap do |m|
          m.prescriptions << Prescription.new(:dispense_date => Date.strptime('12/01/2009', '%m/%d/%Y'), :days_supply => 30)
          allow(m).to receive(:possession_ratio_lower_bound_date).and_return(Date.strptime('12/30/2009', '%m/%d/%Y'))
        end
      end
      it "returns the lower bound date" do
        expect(medicine.possession_effective_start_date(90)).to eq(Date.strptime('12/30/2009', '%m/%d/%Y'))
      end
    end
  end
  
  describe "#prescriptions_in_range" do
    let(:medicine) do
      Medicine.new("Aspirin").tap do |m|
        m.prescriptions << @prescription1 = Prescription.new(:dispense_date => Date.strptime('08/01/2009', '%m/%d/%Y'), :days_supply => 30)
        m.prescriptions << @prescription2 = Prescription.new(:dispense_date => Date.strptime('11/01/2009', '%m/%d/%Y'), :days_supply => 30)
        m.prescriptions << @prescription3 = Prescription.new(:dispense_date => Date.strptime('12/01/2009', '%m/%d/%Y'), :days_supply => 30)
        allow(m).to receive(:possession_effective_end_date).and_return(Date.strptime('12/15/2009', '%m/%d/%Y'))
      end
    end
    it "returns prescriptions dispensed during the effective range" do
      expect(medicine.prescriptions_in_range(90)).to eq([@prescription2,@prescription3])
    end
  end
  
  describe "#dates_prescribed" do
    let(:medicine) do
      Medicine.new("Aspirin").tap do |m|
        m.prescriptions << Prescription.new(:dispense_date => Date.strptime('12/01/2009', '%m/%d/%Y'), :days_supply => 2)
      end
    end
    it "returns the Dates a medicine was prescribed for" do
      expect(medicine.dates_prescribed(2)).to eq([Date.strptime('12/01/2009', '%m/%d/%Y'), Date.strptime('12/02/2009', '%m/%d/%Y')])
    end
  
    context "when there is a date overlap between two prescriptions" do
      let(:medicine) do
        Medicine.new("Aspirin").tap do |m|
          m.prescriptions << Prescription.new(:dispense_date => Date.strptime('12/01/2009', '%m/%d/%Y'), :days_supply => 2)
          m.prescriptions << Prescription.new(:dispense_date => Date.strptime('12/02/2009', '%m/%d/%Y'), :days_supply => 2)
        end
      end
      it "removes duplicates" do
        expect(medicine.dates_prescribed(5)).to eq([Date.strptime('12/01/2009', '%m/%d/%Y'),
                                                Date.strptime('12/02/2009', '%m/%d/%Y'), 
                                                Date.strptime('12/03/2009', '%m/%d/%Y')])      end
    end
  end

  describe "#dates_prescribed_in_effective_range" do
      let(:medicine) do
        Medicine.new("Aspirin").tap do |m|
          m.prescriptions << Prescription.new(:dispense_date => 2.days.ago, :days_supply => 4)
        end
      end
    it "returns the Dates a medicine was prescribed that fall in the effective possession range" do
      expect(medicine.dates_prescribed_in_effective_range(2)).to eq([2.days.ago, 1.day.ago])
    end
  end


  describe "#number_of_days_prescribed(90)" do
    let(:medicine) do
      Medicine.new("Aspirin").tap do |m|
        allow(m).to receive(:possession_effective_range).and_return(Date.strptime('10/03/2009', '%m/%d/%Y')..Date.strptime('12/17/2009', '%m/%d/%Y'))
        m.prescriptions << Prescription.new(:dispense_date => Date.strptime('10/03/2009', '%m/%d/%Y'), :days_supply => 30)
        m.prescriptions << Prescription.new(:dispense_date => Date.strptime('11/17/2009', '%m/%d/%Y'), :days_supply => 30)
      end
    end
    it "returns a count of the days that a medicine was prescribed that fall in the effective possession range" do
      expect(medicine.number_of_days_prescribed(90)).to eq(60)
    end
  end
  
end

describe Patient do
  before do
    @patient = Patient.new
    @codeine = Medicine.new("Codeine")
    @prozac = Medicine.new("Prozac")
    @patient.medicines << @codeine
    @patient.medicines << @prozac
  end

  describe "#clash" do
    context "no prescriptions" do
      it "returns an empty list of dates" do
        expect(@patient.clash(["Codeine", "Prozac"], 90)).to eq([])
      end
    end

    context "only one medicine being taken" do
      before do
        @codeine.prescriptions << Prescription.new(:dispense_date => 30.days.ago, :days_supply => 30)
      end

      it "returns an empty list of days" do
        expect(@patient.clash(["Codeine", "Prozac"], 90).size).to eq(0)
      end
    end

    context "both medicines taken but with no overlap" do
      before do
        @codeine.prescriptions << Prescription.new(:dispense_date => 30.days.ago, :days_supply => 30)
        @prozac.prescriptions << Prescription.new(:dispense_date => 90.days.ago, :days_supply => 30)
      end

      it "returns an empty list of days" do
        expect(@patient.clash(["Codeine", "Prozac"], 90).size).to eq(0)
      end
    end

    context "both medicines taken continuously" do
      before do
        @codeine.prescriptions << Prescription.new(:dispense_date => 30.days.ago, :days_supply => 30)
        @codeine.prescriptions << Prescription.new(:dispense_date => 60.days.ago, :days_supply => 30)
        @codeine.prescriptions << Prescription.new(:dispense_date => 90.days.ago, :days_supply => 30)
        @prozac.prescriptions << Prescription.new(:dispense_date => 30.days.ago, :days_supply => 30)
        @prozac.prescriptions << Prescription.new(:dispense_date => 60.days.ago, :days_supply => 30)
        @prozac.prescriptions << Prescription.new(:dispense_date => 90.days.ago, :days_supply => 30)
      end

      it "returns all the days" do
        expect(@patient.clash(["Codeine", "Prozac"], 90).size).to eq(90)
      end
    end

    context "one medicine taken only on some of the days" do
      before do
        @codeine.prescriptions << Prescription.new(:dispense_date => 30.days.ago, :days_supply => 30)
        @codeine.prescriptions << Prescription.new(:dispense_date => 60.days.ago, :days_supply => 30)
        @prozac.prescriptions << Prescription.new(:dispense_date => 30.days.ago, :days_supply => 30)
        @prozac.prescriptions << Prescription.new(:dispense_date => 60.days.ago, :days_supply => 30)
        @prozac.prescriptions << Prescription.new(:dispense_date => 90.days.ago, :days_supply => 30)
      end

      it "returns two thirds of the days" do
        expect(@patient.clash(["Codeine", "Prozac"], 90).size).to eq(60)
      end
    end

    context "two medicines taken in a partially overlapping period" do
      before do
        @codeine.prescriptions << Prescription.new(:dispense_date => 30.days.ago, :days_supply => 30)
        @prozac.prescriptions << Prescription.new(:dispense_date => 40.days.ago, :days_supply => 30)
      end

      it "returns only the days both were taken" do
        expect(@patient.clash(["Codeine", "Prozac"], 90).size).to eq(20)
      end
    end

    context "two medicines overlapping with current date" do
      before do
        @codeine.prescriptions << Prescription.new(:dispense_date => 1.day.ago, :days_supply => 30)
        @prozac.prescriptions << Prescription.new(:dispense_date => 5.days.ago, :days_supply => 30)
      end

      it "returns only the days both were taken, not future dates" do
        expect(@patient.clash(["Codeine", "Prozac"], 90)).to eq([1.day.ago])
      end
    end

    context "two medicines overlapping with start of period" do
      before do
        @codeine.prescriptions << Prescription.new(:dispense_date => 91.day.ago, :days_supply => 30)
        @prozac.prescriptions << Prescription.new(:dispense_date => 119.days.ago, :days_supply => 30)
      end

      xit "returns only the days both were taken that fall within the last 90 days" do
        expect(@patient.clash(["Codeine", "Prozac"], 90)).to eq([90.days.ago])
      end
    end
  end
end
