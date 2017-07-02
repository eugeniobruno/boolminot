require 'minitest_helper'

class TestGeoBoundingBox < Boolminot::Test
  def test_to_elasticsearch
    expected = { geo_bounding_box: { location: borders_example } }
    actual = geo_bounding_box_example.to_elasticsearch

    assert_equal expected, actual
  end

  private

  def geo_bounding_box_example
    geo_bounding_box(:location, borders_example)
  end

  def borders_example
    {
      top: 40.73,
      left: -74.1,
      bottom: 40.01,
      right: -71.12
    }
  end
end
