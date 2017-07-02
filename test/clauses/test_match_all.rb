require 'minitest_helper'

class TestMatchAll < Boolminot::Test
  def test_to_elasticsearch
    expected = { match_all: {} }
    actual = match_all.to_elasticsearch

    assert_equal expected, actual
  end

  def test_and
    expected = exists_example(1)
    actual = match_all.and(exists_example(1))

    assert_equal expected, actual
  end

  def test_or
    expected = match_all
    actual = match_all.or(exists_example(1))

    assert_equal expected, actual
  end
end
