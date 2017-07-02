require 'minitest_helper'

class TestQueryString < Boolminot::Test
  def test_to_elasticsearch
    expected = { query_string: query_string_parameters_example }
    actual = query_string_example.to_elasticsearch

    assert_equal expected, actual
  end

  def test_with_opts_to_elasticsearch
    expected = { query_string: query_string_parameters_example.merge(some: :option) }
    actual = query_string_example(some: :option).to_elasticsearch

    assert_equal expected, actual
  end
end
