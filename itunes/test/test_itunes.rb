#!/usr/bin/env ruby

###
# Student Name: Pavel Snagovsky 
# Project: iTunes Data Mining

$: << 'lib'

require 'test/unit'
require 'itunes'

LIBRARY = Library.new

# the only set of tests we would need is to test Library class
# with my tests I will try to be as generic as I can
class TestLibrary < Test::Unit::TestCase

  # in order for our library to be useful, it has to have at least one track
  def test_any_tracks
    assert LIBRARY.track_count > 0
  end
  
  # testing that track and plylists are real objects defined by our classes
  def test_library_objects
    assert_equal Track, LIBRARY.tracks.first.class
    assert_equal Playlist, LIBRARY.playlists.first.class
  end
  
  # testing 
  def test_track_find_by_id
    actual = LIBRARY.get_track(555)
    expected = "Bee Gees"
    assert_equal actual.artist, expected
  end
  
  def test_top_songs
    expected = 5
    actual = LIBRARY.top_songs(5)
    assert_equal actual.length, expected
  end
  
  # track_id must always exist
  def test_track_id_nil
    oh = LIBRARY.tracks.find_all {|s| s.track_id == nil}
    assert oh.none?
  end
    
end
