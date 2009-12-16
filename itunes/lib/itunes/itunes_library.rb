###
# Student Name: Pavel Snagovsky
# Project: iTunes Data Mining
#

# Library class.
# Class parses iTunes xml Library file and keeps track of and has methods to manipulate objects we might be interested at
class Library
  
  # Library class stores arrays of tracks and playlists objects
  # albums and artists arrays are collected from track objects  
  #  *** initial reaction was to make something like @tracks(track_id) << Track.new(data)
  #       but I went with the lighter model, and feel it works well. 
  attr_reader :tracks, :albums, :artists, :playlists
  
  # Method to initalize the class
  # iTunes library filename could be passed to the method (optional)
  # self.parse method is called to process our itunes xml data initializing the class.
  def initialize(file = "../data/iTunes\ Music\ Library.xml")
    @tracks, @playlists = [], []
    self.parse(file)
  end

  # Parses track and playlists node sets.
  # This method is called when the class is initialized.
  # Track and Playlist classes are used to create tracks and playlists objects.
  def parse(library_file)
    xml = Nokogiri::XML(File.open(library_file))
    
    # parsing songs:
    # Using 'class community' contributed snippet, 
    # couple of ways I came up with were not nearly as elegant to say the least
    (xml/"/plist/dict/dict/dict").each do |tnode|
      metadata = Hash[*tnode.children.reject {
        |e| e.kind_of? Nokogiri::XML::Text}.collect {
        |e| e.text}]

      song = Track.new(metadata)
      @tracks << song
    end
    
    @albums = @tracks.collect {|s| s.album}.uniq
    @artists = @tracks.collect {|s| s.artist}.uniq
    
    # parsing playlists:
    (xml/"/plist/dict/array/dict").each do |pnode| 
      # excluding 'special' playlists based on a 'special' string in a key 
      next if (pnode/"key").any? {|x| x.to_s =~ /Visible|Smart|Distinguished/}
      
      # the rest is slightly modified version provided by Ben
      playlist_name = (pnode/"key[text()='Name']").first.next.text
      playlist_tracks = (pnode/"array//integer").collect {|e| e.text.to_i}
      
      playlist = Playlist.new(playlist_name, playlist_tracks)
      @playlists << playlist
    end
  end
  
  # Method returns amount of Track class objects in the library
  def track_count
    return @tracks.length
  end
  
  # Method counts amount of albums in the library
  def album_count
    return @albums.length
  end
  
  # Method returns amount of artists in the library
  def artist_count
    return @artists.length
  end
  
  # Method returns the amount of playlist objects in the library.
  # This list excludes 'special' itunes playlists, details are in the self.parse method
  def playlist_count
    return @playlists.length
  end
  
  # Method returns total play time of the library in human readable format
  def play_time
    sum = 0
    @tracks.each {|n| sum += n.total_time}
    return Time.at(sum/1000.0).strftime('%R:%S')
  end
  
  # Top played songs:
  # Method returns an array of track objects on 'n' top played songs.
  def top_songs(n = 3)
    top_list = @tracks.sort_by {|s| s.play_count}.reverse
    return top_list[0..n-1].compact
  end
  
  # Method to list albums with only one track
  # Returns array of track objects (the first 10 by default), it was getting long in my case.
  # *** wanted to make this method calculating songs per album, comparing it to 'Track Count',
  # however Track data is rear (for my library especially), the method was practically useless, catching too few albums.
  def albums_with_one_song(n = 10)
    single_songs = []
    @albums.each do |a|
      b = @tracks.find_all {|s| s.album == a}
      single_songs << b.first unless b.length > 1
    end
    return single_songs[0..n-1]
  end
  
  # Method returns array of tracks objects that have never been played.
  def songs_never_played
    return @tracks.find_all {|s| s.play_count == 0}
  end
  
  # Method returns track object with specified track_id
  def get_track(id)
    return @tracks.find {|s| s.track_id == id}
  end
  
  # Method returns array of track class objects based on array of track_ids 
  def get_tracks(*ids)
    song_list = []
    ids.each do |id|
     song_list << @tracks.find {|s| s.track_id == id}
    end
    return song_list.compact
  end
    
end
