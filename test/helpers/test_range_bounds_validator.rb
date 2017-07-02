require 'minitest_helper'

class TestRangeBoundsValidator < Boolminot::Test

  def test_no_bounds
    assert !validator({}).valid?
  end

  def test_one_bound1
    assert validator(gt: 1).valid?
  end

  def test_one_bound2
    assert validator(gte: 1).valid?
  end

  def test_one_bound3
    assert validator(lt: 1).valid?
  end

  def test_one_bound4
    assert validator(lte: 1).valid?
  end

  def test_one_bound5
    assert !validator(other: 1).valid?
  end

  def test_one_bound6
    assert !validator(other: 1, gte: 1).valid?
  end

  def test_two_bounds1
    assert validator(gt: 1, lt: 9).valid?
  end

  def test_two_bounds2
    assert validator(gt: 1, lte: 9).valid?
  end

  def test_two_bounds3
    assert !validator(gt: 1, gte: 9).valid?
  end

  def test_two_bounds4
    assert validator(gte: 1, lt: 9).valid?
  end

  def test_two_bounds5
    assert validator(gte: 1, lte: 9).valid?
  end

  def test_two_bounds6
    assert !validator(lt: 1, lte: 9).valid?
  end

  private

  def validator(bounds)
    Boolminot::Helpers::RangeBoundsValidator.new(bounds)
  end

end