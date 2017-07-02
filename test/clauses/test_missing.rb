require 'minitest_helper'

class TestMissing < Boolminot::Test
  def test_to_elasticsearch
    expected = { bool: { must_not: [{ exists: { field: :field1 } }] } }
    actual = missing_example(1).to_elasticsearch

    assert_equal expected, actual
  end

  def test_with_opts_to_elasticsearch
    expected = { bool: { must_not: [{ exists: { field: :field1, some: :option } }] } }
    actual = missing_example(1, some: :option).to_elasticsearch

    assert_equal expected, actual
  end
end
