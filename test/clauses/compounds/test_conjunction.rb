require 'minitest_helper'

class TestConjunction < Boolminot::Test
  def test_in_query_context
    expected = {
      bool: {
        must: [1, 2].map { |n| exists_example(n).to_elasticsearch(context: :query) }
      }
    }
    actual = conjunction_example([1, 2]).to_elasticsearch(context: :query)

    assert_equal expected, actual
  end

  def test_in_filter_context
    expected = {
      bool: {
        must: [1, 2].map { |n| exists_example(n).to_elasticsearch }
      }
    }
    actual = conjunction_example([1, 2]).to_elasticsearch

    assert_equal expected, actual
  end

  def test_and_with_other
    expected = {
      bool: {
        must: [1, 2, 3].map { |n| exists_example(n).to_elasticsearch }
      }
    }
    actual = conjunction_example([1, 2]).and(exists_example(3)).to_elasticsearch

    assert_equal expected, actual
  end

  def test_and_with_conjunction
    expected = {
      bool:
        {
          must: [1, 2, 3, 4].map { |n| exists_example(n).to_elasticsearch }
        }
    }
    actual = conjunction_example([1, 2]).and(conjunction_example([3, 4])).to_elasticsearch

    assert_equal expected, actual
  end

  def test_and_with_disjunction
    expected = {
      bool: {
        must:   [1, 2].map { |n| exists_example(n).to_elasticsearch },
        should: [3, 4].map { |n| exists_example(n).to_elasticsearch }
      }
    }
    actual = conjunction_example([1, 2]).and(disjunction_example([3, 4])).to_elasticsearch

    assert_equal expected, actual
  end

  def test_and_with_disjunction_twice
    third = disjunction_example([5, 6]).to_elasticsearch

    expected = {
      bool: {
        must:   [1, 2].map { |n| exists_example(n).to_elasticsearch } + [third],
        should: [3, 4].map { |n| exists_example(n).to_elasticsearch }
      }
    }
    actual = conjunction_example([1, 2]).and(disjunction_example([3, 4])).and(disjunction_example([5, 6])).to_elasticsearch

    assert_equal expected, actual
  end

  def test_and_with_disjunction_thrice
    third  = disjunction_example([5, 6]).to_elasticsearch
    fourth = disjunction_example([7, 8]).to_elasticsearch

    expected = {
      bool: {
        must:   [1, 2].map { |n| exists_example(n).to_elasticsearch } + [third, fourth],
        should: [3, 4].map { |n| exists_example(n).to_elasticsearch }
      }
    }
    actual = conjunction_example([1, 2]).and(disjunction_example([3, 4])).and(disjunction_example([5, 6])).and(disjunction_example([7, 8])).to_elasticsearch

    assert_equal expected, actual
  end

  def test_negated
    expected = {
      bool: {
        must_not: [conjunction_example([1, 2]).to_elasticsearch]
      }
    }

    actual = conjunction_example([1, 2]).negated.to_elasticsearch

    assert_equal expected, actual
  end

  def test_double_negation
    expected = conjunction_example([1, 2]).to_elasticsearch
    actual   = conjunction_example([1, 2]).negated.negated.to_elasticsearch

    assert_equal expected, actual
  end

  def test_and_with_negation
    expected = {
      bool: {
        must: [1, 2].map { |n| exists_example(n).to_elasticsearch },
        must_not: [exists_example(3).to_elasticsearch]
      }
    }
    actual = conjunction_example([1, 2]).and_not(exists_example(3)).to_elasticsearch

    assert_equal expected, actual
  end

  def test_and_with_conjunction_with_negations
    expected = {
      bool: {
        must:     [1, 2, 3, 4].map { |n| exists_example(n).to_elasticsearch },
        must_not: [5, 6, 7, 8].map { |n| exists_example(n).to_elasticsearch }
      }
    }
    part1 = conjunction_example([1, 2]).and(exists_example(5).negated).and(exists_example(6).negated)
    part2 = conjunction_example([3, 4]).and(exists_example(7).negated).and(exists_example(8).negated)
    actual = part1.and(part2).to_elasticsearch

    assert_equal expected, actual
  end

  # ---

  def test_or_with_other
    expected = {
      bool: {
        should: [conjunction_example([1, 2]).to_elasticsearch, exists_example(3).to_elasticsearch]
      }
    }

    actual = conjunction_example([1, 2]).or(exists_example(3)).to_elasticsearch

    assert_equal expected, actual
  end

  def test_or_with_conjunction
    expected = {
      bool: {
        should: [conjunction_example([1, 2]).to_elasticsearch, conjunction_example([3, 4]).to_elasticsearch]
      }
    }
    actual = conjunction_example([1, 2]).or(conjunction_example([3, 4])).to_elasticsearch

    assert_equal expected, actual
  end

  def test_or_with_disjunction
    expected = {
      bool: {
        should: [conjunction_example([1, 2]).to_elasticsearch] + [3, 4].map { |n| exists_example(n).to_elasticsearch }
      }
    }
    actual = conjunction_example([1, 2]).or(disjunction_example([3, 4])).to_elasticsearch

    assert_equal expected, actual
  end

  def test_or_with_disjunction_twice
    expected = {
      bool: {
        should: [conjunction_example([1, 2]).to_elasticsearch] + [3, 4, 5, 6].map { |n| exists_example(n).to_elasticsearch }
      }
    }
    actual = conjunction_example([1, 2]).or(disjunction_example([3, 4])).or(disjunction_example([5, 6])).to_elasticsearch

    assert_equal expected, actual
  end

  def test_or_with_negation
    expected = {
      bool: {
        should: [conjunction_example([1, 2]).to_elasticsearch] + [exists_example(3).negated.to_elasticsearch]
      }
    }
    actual = conjunction_example([1, 2]).or_not(exists_example(3)).to_elasticsearch

    assert_equal expected, actual
  end
end
