require 'minitest_helper'

class TestExactly < Boolminot::Test
  def test_in_query_context
    expected = {
      bool: {
        must: [
          {
            bool: {
              should: [1, 2, 3].map { |n| { bool: { must_not: [exists_example(n).to_elasticsearch] } } },
              minimum_should_match: 1
            }
          }
        ],
        should: [1, 2, 3].map { |n| exists_example(n).to_elasticsearch },
        minimum_should_match: 2
      }
    }
    actual = exactly_example(2, [1, 2, 3]).to_elasticsearch(context: :query)

    assert_equal expected, actual
  end

  def test_in_filter_context
    expected = {
      bool: {
        must: [
          {
            bool: {
              should: [1, 2, 3].map { |n| { bool: { must_not: [exists_example(n).to_elasticsearch] } } }
            }
          }
        ],
        should: [
          {
            bool: {
              must: [1, 2].map { |n| exists_example(n).to_elasticsearch }
            }
          },
          {
            bool: {
              must: [1, 3].map { |n| exists_example(n).to_elasticsearch }
            }
          },
          {
            bool: {
              must: [2, 3].map { |n| exists_example(n).to_elasticsearch }
            }
          }
        ]
      }
    }
    actual = exactly_example(2, [1, 2, 3]).to_elasticsearch

    assert_equal expected, actual
  end
end
