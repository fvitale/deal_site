require 'test_helper'

class DealTest < ActiveSupport::TestCase
  test "factory should be sane" do
    assert FactoryGirl.build(:deal).valid?
  end

  test "deal that ends in the future should not be over yet" do
    deal = FactoryGirl.create(:deal, :end_at => Time.zone.now + 10)
    assert !deal.over?, "Deal should not be over"
  end

  test "deal that ended in the past should be over now" do
    deal = FactoryGirl.create(:deal, :end_at => Time.zone.now - 10)
    assert deal.over?, "Deal should be over"
  end
end
