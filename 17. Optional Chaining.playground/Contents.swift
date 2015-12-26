// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Optional Chaining is the process of safely referencing a series of optionals (which contain
//   optionals, which contain optionals, etc.) without having to perform the optional unwrapping
//   checks at each step along the way.
// ------------------------------------------------------------------------------------------------

// Consider a case of forced unwrapping like "someOptional!.someProperty". We already know that
// this is only safe if we know that the optional will never be nil. For times that we don't know
// this, we must check the optional before we can reference it. This can become cumbersome for
// situations where many optionals are chained together as properties of properties. Let's create
// a series of optionals to show this:
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

// Here, we'll create a working chain:
var someArtist: Artist? = Artist(name: "Somebody with talent")
var favSong: Song? = Song(name: "Something with a beat", artist: someArtist)
var musicPrefs: MusicPreferences? = MusicPreferences(favoriteSong: favSong)
var person: Person? = Person(name: "Bill", musicPreferences: musicPrefs)

// We can access this chain with forced unwrapping. In this controlled environment, this will work
// but it's probably not advisable in a real world situation unless you're sure that each member
// of the chain is sure to never be nil.
person!.musicPreferences!.favoriteSong!.artist!

// Let's break the chain, removing the user's music preferences:
if var p = person
{
	p.musicPreferences = nil
}

// With a broken chain, if we try to reference the arist like before, we will get a runtime error.
//
// The following line will compile, but will crash:
//
//		person!.musicPreferences!.favoriteSong!.artist!
//
// The solusion here is to use optional chaining, which replaces the forced unwrapping "!" with
// a "?" character. If at any point along this chain, any optional is nil, evaluation is aborted
// and the entire result becomes nil.
//
// Let's see this entire chain, one step at a time working backwards. This let's us see exactly
// where the optional chain becomes a valid value:
person?.musicPreferences?.favoriteSong?.artist
person?.musicPreferences?.favoriteSong
person?.musicPreferences
person

// Optional chaining can be mixed with non-optionals as well as forced unwrapping and other
// contexts (subcripts, function calls, return values, etc.) We won't bother to create the
// series of classes and instances for the following example, but it should serve as a valid
// example of how to use optional chaining syntax in various situations. Given the proper context
// this line of code would compile and run as expected.
//
// person?.musicPreferences?[2].getFavoriteSong()?.artist?.name
//
// This line could be read as: optional person's second optional music preference's favorite song's
// optional artist's name.
