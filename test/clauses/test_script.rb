require 'minitest_helper'

class TestScript < Boolminot::Test
  def test_to_elasticsearch
    expected = { script: { script: inner_script_example } }
    actual = script_example.to_elasticsearch

    assert_equal expected, actual
  end

  def test_with_opts_to_elasticsearch
    expected = { script: { script: inner_script_example, some: :option } }
    actual = script_example(some: :option).to_elasticsearch

    assert_equal expected, actual
  end
end
