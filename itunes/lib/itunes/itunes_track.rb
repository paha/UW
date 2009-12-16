###
# Student Name: Pavel Snagovsky 
# Project iTunes Data Mining
#

# Defining object and methods for a track in iTunes library
class Track
  # from all the metadata tha t comes to as we select few attributes of a track we care about
  attr_reader :track_id, :name, :artist, :album, :total_time, :play_count
  
  # New track receives a hash with metadata, we pick selected values converting strings to integers where needed. 
  def initialize(track_metadata)
    @track_id = track_metadata['Track ID'].to_i
    @name = track_metadata['Name']
    @artist = track_metadata['Artist']
    @album = track_metadata['Album']
    @total_time = track_metadata['Total Time'].to_i
    @play_count = track_metadata['Play Count'].to_i
  end
  
  # 'Total time' is defined in milliseconds.
  # Method converts it into human readable format, but it returns it as a string limiting the use of the method
  def duration
    return Time.at(@total_time/1000.0).getgm.strftime('%R:%S')
  end 

end
