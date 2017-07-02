require 'minitest_helper'

class TestAtMost < Boolminot::Test
  def test_in_query_context
    expected = {
      bool: {
        should: [1, 2, 3].map { |n| { bool: { must_not: [exists_example(n).to_elasticsearch] } } },
        minimum_should_match: 1
      }
    }
    actual = at_most_example(2, [1, 2, 3]).to_elasticsearch(context: :query)

    assert_equal expected, actual
  end

  def test_in_filter_context
    expected = {
      bool: {
        should: [1, 2, 3].map { |n| { bool: { must_not: [exists_example(n).to_elasticsearch] } } }
      }
    }
    actual = at_most_example(2, [1, 2, 3]).to_elasticsearch

    assert_equal expected, actual
  end
end
