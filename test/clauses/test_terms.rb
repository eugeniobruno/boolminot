require 'minitest_helper'

class TestTerms < Boolminot::Test
  def test_to_elasticsearch_with_one_value
    expected = { term: { my_field: 'value' } }
    actual = term_example.to_elasticsearch

    assert_equal expected, actual
  end

  def test_to_elasticsearch_with_many_values
    expected = { terms: { my_field: %w(first_value second_value) } }
    actual = terms_example.to_elasticsearch

    assert_equal expected, actual
  end

  def test_or_with_other
    other = exists('some_field')

    expected = disjunction([terms_example, other])
    actual = terms_example.or(other)

    assert_equal expected, actual
  end

  def test_or_with_terms
    expected = disjunction([term_example, terms_example])
    actual = term_example.or(terms_example)

    assert_equal expected, actual
  end

  def test_or_with_terms_with_common_fields
    other_terms_example = terms('my_field', %w(second_value third_value))

    expected = terms('my_field', %w(first_value second_value third_value))
    actual = terms_example.or(other_terms_example)

    assert_equal expected, actual
  end

  def test_or_with_disjunction1
    other = disjunction([term('some_field', 'some_value'), exists('other_field')])

    expected = disjunction([terms_example, other])
    actual = terms_example.or(other)

    assert_equal expected, actual
  end

  def test_or_with_disjunction2
    other = disjunction([term('some_field', 'some_value'), exists('other_field')])

    expected = disjunction([other, terms_example])
    actual = other.or(terms_example)

    assert_equal expected, actual
  end

  def test_or_with_disjunction3
    other = disjunction([term('my_field', 'some_value'), exists('other_field')])

    expected = disjunction([terms('my_field', %w(first_value second_value some_value)), exists('other_field')])
    actual = terms_example.or(other)

    assert_equal expected, actual
  end

  def test_or_with_disjunction4
    other = disjunction([term('my_field', 'some_value'), exists('other_field')])

    expected = disjunction([exists('other_field'), terms('my_field', %w(some_value first_value second_value some_value))])
    actual = other.or(terms_example)

    assert_equal expected, actual
  end

  def test_or_with_disjunction5
    other = disjunction([terms('my_field', %w(some_value other_value)), exists('other_field')])

    expected = disjunction([terms('my_field', %w(first_value second_value some_value other_value)), exists('other_field')])
    actual = terms_example.or(other)

    assert_equal expected.to_elasticsearch, actual.to_elasticsearch
  end

  def test_or_with_disjunction6
    other = disjunction([terms('my_field', %w(some_value other_value)), exists('other_field')])

    expected = disjunction([exists('other_field'), terms('my_field', %w(some_value other_value first_value second_value))])
    actual = other.or(terms_example)

    assert_equal expected, actual
  end

  def test_or_with_disjunction7
    other = disjunction([exists('other_field'), term('my_field', 'some_value')])

    expected = disjunction([terms('my_field', %w(first_value second_value some_value)), exists('other_field')])
    actual = terms_example.or(other)

    assert_equal expected, actual
  end

  def test_or_with_disjunction8
    other = disjunction([exists('other_field'), term('my_field', 'some_value'), term('other_field', 'other_value')])

    expected = disjunction([terms('my_field', %w(first_value second_value some_value)), term('other_field', 'other_value'), exists('other_field')])
    actual = terms_example.or(other)

    assert_equal expected, actual
  end

  def test_specialization_of
    other_terms_example = terms('my_field', %w(second_value third_value))
    special_case = terms(:my_field, ['second_value'])
    exists = exists('my_field')

    assert(special_case.specialization_of?(terms_example))
    assert(special_case.specialization_of?(other_terms_example))

    assert(!special_case.specialization_of?(term_example))
    assert(!special_case.specialization_of?(exists))
  end
end
