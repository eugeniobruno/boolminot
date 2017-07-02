require 'minitest_helper'

class TestMatchNone < Boolminot::Test
  def test_to_elasticsearch
    expected = { bool: { must_not: [{ match_all: {} }] } }
    actual = match_none.to_elasticsearch

    assert_equal expected, actual
  end

  def test_and
    expected = match_none
    actual = match_none.and(exists_example(1))

    assert_equal expected, actual
  end

  def test_or
    expected = exists_example(1)
    actual = match_none.or(exists_example(1))

    assert_equal expected, actual
  end
end
