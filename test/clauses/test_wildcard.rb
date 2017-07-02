require 'minitest_helper'

class TestWildcard < Boolminot::Test
  def test_to_elasticsearch
    expected = { wildcard: { 'user' => 'ki*y' } }
    actual = wildcard_example.to_elasticsearch

    assert_equal expected, actual
  end

  def test_with_opts_to_elasticsearch
    expected = { wildcard: { 'user' => 'ki*y', some: :option } }
    actual = wildcard_example(some: :option).to_elasticsearch

    assert_equal expected, actual
  end
end
