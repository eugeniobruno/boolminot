require 'minitest_helper'

class TestNested < Boolminot::Test
  def test_to_elasticsearch
    expected = { nested: { path: 'values' }.merge(filter: exists_example(1).to_elasticsearch) }
    actual = nested_example.to_elasticsearch

    assert_equal expected, actual
  end

  def test_with_opts_to_elasticsearch
    expected = { nested: { path: 'values', some: :option }.merge(filter: exists_example(1).to_elasticsearch) }
    actual = nested_example(some: :option).to_elasticsearch

    assert_equal expected, actual
  end
end
