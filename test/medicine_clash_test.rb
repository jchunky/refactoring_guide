require 'minitest/autorun'
require 'minitest/reporters'
require 'bigdecimal'
require_relative '../lib/version_loader'
VersionLoader.require_kata('medicine_clash')
include MedicineClashKata

Minitest::Reporters.use!

class PrescriptionTest < Minitest::Test
  def test_completion_date_is_days_supply_after_dispense_date
    prescription = Prescription.new(dispense_date: 15.days.ago, days_supply: 30)
    assert_equal 15.days.from_now.to_date, prescription.completion_date
  end
end

class PatientTest < Minitest::Test
  def setup
    @patient = Patient.new
    @codeine = Medicine.new("Codeine")
    @prozac = Medicine.new("Prozac")
    @patient.medicines << @codeine
    @patient.medicines << @prozac
  end

  def test_clash_with_no_prescriptions_returns_empty_list
    assert_equal [], @patient.clash(["Codeine", "Prozac"], 90)
  end

  def test_clash_with_only_one_medicine_returns_empty_list
    @codeine.prescriptions << Prescription.new(dispense_date: 30.days.ago, days_supply: 30)
    assert_equal 0, @patient.clash(["Codeine", "Prozac"], 90).size
  end

  def test_clash_with_no_overlap_returns_empty_list
    @codeine.prescriptions << Prescription.new(dispense_date: 30.days.ago, days_supply: 30)
    @prozac.prescriptions << Prescription.new(dispense_date: 90.days.ago, days_supply: 30)
    assert_equal 0, @patient.clash(["Codeine", "Prozac"], 90).size
  end

  def test_clash_with_both_medicines_taken_continuously_returns_all_days
    @codeine.prescriptions << Prescription.new(dispense_date: 30.days.ago, days_supply: 30)
    @codeine.prescriptions << Prescription.new(dispense_date: 60.days.ago, days_supply: 30)
    @codeine.prescriptions << Prescription.new(dispense_date: 90.days.ago, days_supply: 30)
    @prozac.prescriptions << Prescription.new(dispense_date: 30.days.ago, days_supply: 30)
    @prozac.prescriptions << Prescription.new(dispense_date: 60.days.ago, days_supply: 30)
    @prozac.prescriptions << Prescription.new(dispense_date: 90.days.ago, days_supply: 30)
    assert_equal 90, @patient.clash(["Codeine", "Prozac"], 90).size
  end

  def test_clash_with_one_medicine_partial_returns_two_thirds
    @codeine.prescriptions << Prescription.new(dispense_date: 30.days.ago, days_supply: 30)
    @codeine.prescriptions << Prescription.new(dispense_date: 60.days.ago, days_supply: 30)
    @prozac.prescriptions << Prescription.new(dispense_date: 30.days.ago, days_supply: 30)
    @prozac.prescriptions << Prescription.new(dispense_date: 60.days.ago, days_supply: 30)
    @prozac.prescriptions << Prescription.new(dispense_date: 90.days.ago, days_supply: 30)
    assert_equal 60, @patient.clash(["Codeine", "Prozac"], 90).size
  end

  def test_clash_with_partial_overlap_returns_overlap_days
    @codeine.prescriptions << Prescription.new(dispense_date: 30.days.ago, days_supply: 30)
    @prozac.prescriptions << Prescription.new(dispense_date: 40.days.ago, days_supply: 30)
    assert_equal 20, @patient.clash(["Codeine", "Prozac"], 90).size
  end

  def test_clash_overlapping_with_current_date_excludes_future
    @codeine.prescriptions << Prescription.new(dispense_date: 1.day.ago, days_supply: 30)
    @prozac.prescriptions << Prescription.new(dispense_date: 5.days.ago, days_supply: 30)
    assert_equal [1.day.ago], @patient.clash(["Codeine", "Prozac"], 90)
  end

  # Skipped: two medicines overlapping with start of period
  # def test_clash_overlapping_with_start_of_period
  #   @codeine.prescriptions << Prescription.new(dispense_date: 91.day.ago, days_supply: 30)
  #   @prozac.prescriptions << Prescription.new(dispense_date: 119.days.ago, days_supply: 30)
  #   assert_equal [90.days.ago], @patient.clash(["Codeine", "Prozac"], 90)
  # end
end
