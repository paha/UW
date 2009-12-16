###
# Student Name: Pavel Snagovsky 
# Project: iTunes Data Mining
#

# Defines playlist object for itunes Library
class Playlist
  # We store the name of the playlist and an array of track ids in the list
  attr_reader :name, :songs
  
  def initialize(name, songs)
    @name = name
    @songs = songs
  end
  
  # Method returns amount of songs in the playlist 
  def size
    return @songs.length
  end
  
  # Method returns total duration of the playlist
  def duration
    # how to talk to the Track class objects stored in Library class?
    # I don't want to inialize another Library, though it would work
  end
  
  def total_song_plays
    # the same problem as above
  end
end
