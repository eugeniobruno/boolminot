require 'minitest_helper'

class TestExists < Boolminot::Test
  def test_to_elasticsearch
    expected = { exists: { field: :field1 } }
    actual = exists_example(1).to_elasticsearch

    assert_equal expected, actual
  end

  def test_with_opts_to_elasticsearch
    expected = { exists: { field: :field1, some: :option } }
    actual = exists_example(1, some: :option).to_elasticsearch

    assert_equal expected, actual
  end

  def test_satisfied_by
    assert_raises(NoMethodError) do
      exists_example(1).satisfied_by?('document')
    end
  end
end
