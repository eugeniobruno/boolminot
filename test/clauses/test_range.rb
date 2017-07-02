require 'minitest_helper'

class TestRange < Boolminot::Test
  def test_lower_bound
    assert_equal(1, range_with_bounds(gte: 1, lte: 6).lower_bound)
  end

  def test_upper_bound
    assert_equal(6, range_with_bounds(gt: 1, lt: 6).upper_bound)
  end

  def test_to_elasticsearch_with_both_bounds
    expected = { range: { field: { gte: 1, lte: 6 } } }
    actual = range_with_bounds(gte: 1, lte: 6).to_elasticsearch

    assert_equal expected, actual
  end

  def test_to_elasticsearch_with_lower_bound
    expected = { range: { field: { gte: 1 } } }
    actual = range_with_bounds('gte' => 1).to_elasticsearch

    assert_equal expected, actual
  end

  def test_to_elasticsearch_with_upper_bound
    expected = { range: { field: { lte: 6 } } }
    actual = range_with_bounds(lte: 6).to_elasticsearch

    assert_equal expected, actual
  end

  def test_with_opts_to_elasticsearch
    expected = { range: { field: { gte: 1, lte: 6, some: :option } } }
    actual = range_with_bounds({ gte: 1, lte: 6}, { some: :option }).to_elasticsearch

    assert_equal expected, actual
  end

  def test_and_with_range1
    expected = range_with_bounds(gte: 1, lte: 6)
    actual = range_with_bounds(gte: 1).and(range_with_bounds(lte: 6))

    assert_equal expected, actual
  end

  def test_and_with_range2
    expected = range_with_bounds(gt: 1, lte: 6)
    actual = range_with_bounds(gt: 1).and(range_with_bounds(lte: 6))

    assert_equal expected, actual
  end

  def test_and_with_range3
    expected = range_with_bounds(gte: 1, lt: 6)
    actual = range_with_bounds(gte: 1).and(range_with_bounds(lt: 6))

    assert_equal expected, actual
  end

  def test_and_with_range4
    expected = range_with_bounds(gt: 1, lt: 6)
    actual = range_with_bounds(gt: 1).and(range_with_bounds(lt: 6))

    assert_equal expected, actual
  end

  def test_and_with_range5
    expected = {
      bool: {
        must: [range_with_bounds(gte: 1, lte: 3), range_with_bounds(gte: 6, lte: 9)].map(&:to_elasticsearch)
      }
    }
    actual = range_with_bounds(gte: 1, lte: 3).and(range_with_bounds(gte: 6, lte: 9)).to_elasticsearch

    assert_equal expected, actual
  end

  def test_and_with_range6
    expected = {
      bool: {
        must: [range_with_bounds(gte: 1, lte: 3), range_with_bounds(gt: 2)].map(&:to_elasticsearch)
      }
    }
    actual = range_with_bounds(gte: 1, lte: 3).and(range_with_bounds(gt: 2)).to_elasticsearch

    assert_equal expected, actual
  end

  def test_and_with_range7
    expected = {
      bool: {
        must: [range_with_bounds(gte: 1, lte: 3), range_with_bounds(lt: 2)].map(&:to_elasticsearch)
      }
    }
    actual = range_with_bounds(gte: 1, lte: 3).and(range_with_bounds(lt: 2)).to_elasticsearch

    assert_equal expected, actual
  end

  def test_and_with_range8
    expected = {
      bool: {
        must: [range_with_bounds(gte: 1, lte: 3), range_with_bounds(gt: 2, lt: 4)].map(&:to_elasticsearch)
      }
    }
    actual = range_with_bounds(gte: 1, lte: 3).and(range_with_bounds(gt: 2, lt: 4)).to_elasticsearch

    assert_equal expected, actual
  end

  def test_and_with_range9
    expected = {
      bool: {
        must: [range_with_bounds(gte: 1), range(:other_field, lte: 3)].map(&:to_elasticsearch)
      }
    }
    actual = range_with_bounds(gte: 1).and(range(:other_field, lte: 3)).to_elasticsearch

    assert_equal expected, actual
  end

  def test_or_with_range
    expected = {
      bool: {
        should: [range_with_bounds(gte: 1), range_with_bounds(lte: 6)].map(&:to_elasticsearch)
      }
    }
    actual = range_with_bounds(gte: 1).or(range_with_bounds(lte: 6)).to_elasticsearch

    assert_equal expected, actual
  end
end
