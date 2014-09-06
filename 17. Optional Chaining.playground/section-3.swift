var someArtist: Artist? = Artist(name: "Somebody with talent")
var favSong: Song? = Song(name: "Something with a beat", artist: someArtist)
var musicPrefs: MusicPreferences? = MusicPreferences(favoriteSong: favSong)
var person: Person? = Person(name: "Bill", musicPreferences: musicPrefs)