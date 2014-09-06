class Artist
{
	let name: String
	init(name: String) { self.name = name }
}

class Song
{
	let name: String
	var artist: Artist?
	init(name: String, artist: Artist?)
	{
		self.name = name
		self.artist = artist
	}
}

class MusicPreferences
{
	var favoriteSong: Song?
	init(favoriteSong: Song?) { self.favoriteSong = favoriteSong }
}

class Person
{
	let name: String
	var musicPreferences: MusicPreferences?
	init (name: String, musicPreferences: MusicPreferences?)
	{
		self.name = name
		self.musicPreferences = musicPreferences
	}
}