// ------------------------------------------------------------------------------------------------
// Things to know:
//
// * Type casting allows us to check the type of an instance and/or treat that instance as a
//   different type from somewhere else in its own hieararchy.
//
// * Type casting also allows us to determine if a type conforms to a protocol.
//
// * Additionally we can create
// ------------------------------------------------------------------------------------------------

// Let's start by creating a few types to work with:
class MediaItem
{
	var name: String
	init(name: String) { self.name = name }
}

class Movie: MediaItem
{
	var director: String
	init(name: String, director: String)
	{
		self.director = director
		super.init(name: name)
	}
}

class Song: MediaItem
{
	var artist: String
	init(name: String, artist: String)
	{
		self.artist = artist
		super.init(name: name)
	}
}

// We'll create a library of Movies and Songs. Note that Swift will infer the type of the array to
// be MediaItem[].
let library =
[
	Movie(name: "Casablanca", director: "Michael Curtiz"),
	Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
	Movie(name: "Citizen Kane", director: "Orson Welles"),
	Song(name: "The One And Only", artist: "Chesney Hawkes"),
	Song(name: "Never Gunna Give You Up", artist: "Rick Astley")
]

// ------------------------------------------------------------------------------------------------
// Checking type
//
// We can check the type of an object very simply with the 'is' operator, also known as the Type
// Check Operator.
library[0] is Movie // true
library[0] is Song  // false

// Let's see this in action. Lets loop through the library and count up the movies and songs:
var movieCount = 0
var songCount = 0
for item in library
{
	if item is Movie { ++movieCount }
	else if item is Song { ++songCount }
}

// Our final Movie and Song counts:
movieCount
songCount

// ------------------------------------------------------------------------------------------------
// Downcasting
//
// As with other languages, downcasting refers to casting an object to a subclass within its
// hierarchy. This is done with the Type Cast Operator, "as".
//
// Because not all objects can be downcasted, the result of a downcast may be nil. Because of this,
// we have two options for downcasting. We can downcast to an optional using the "as?" operator
// or downcast with forced unwrapping of the optional with the standard "as" operator. As with
// forced unwrapping, only do this if you know for certain that the downcast will succeed.
//
// Let's see this in action using optional binding and the "as?" operator. Remember that our
// library has type MediaItem[], so if we cast an element of that array to either a Movie or Song,
// will will be downcasting the instance.
for item in library
{
	if let movie = item as? Movie
	{
		"Movie: '\(movie.name)' was directed by \(movie.director)"
	}
	else if let song = item as? Song
	{
		"Song: '\(song.name)' was performed by \(song.artist)"
	}
}

// ------------------------------------------------------------------------------------------------
// Type Casting for Any and AnyObject
//
// * AnyObject allows us to store an instance to any class type.
//
// * Any allows us to store a reference to any type at all, excluding functino types.
//
// We should strive to use Any and AnyObject only when we must (like when an API function returns
// arrays of values of any object type.) Otherwise, it's important that we use explicit types to
// conform to Swift's type safety.
//
// Let's see AnyObject in action. We'll define an array of type AnyObject[] and populate it with
// some movies:
let someObjects: [AnyObject] =
[
	Movie(name: "2001: A Space Odyssey", director: "Stanley Kubrick"),
	Movie(name: "Moon", director: "Duncan Jones"),
	Movie(name: "Alien", director: "Ridley Scott"),
]

// Here, we know that someObjects[] only contains Movie instances, so we'll use our forced version
// of the typecast operator, "as". Note, however, that if somebody modifies the code later and adds
// an instance of a non-Movie type (which they can do), we'll crash. This is why it's important
// to limit our use of AnyObject and Any to only those cases where we absolutely need it.
//
// Let's see how we would use the someObjects array:
for object: AnyObject in someObjects
{
	let movie = object as Movie
	"Movie: '\(movie.name)' was directed by \(movie.director)"
}

// Alternatively, we can downcast the array itself rather than each item:
var someMovies = someObjects as [Movie]
for movie in someMovies
{
	"Movie: '\(movie.name)' was directed by \(movie.director)"
}

// Finally, we can avoid the additional local variable and performt he downcast right inside
// the loop structure:
for movie in someObjects as [Movie]
{
	"Movie: '\(movie.name)' was directed by \(movie.director)"
}

// Any allows us store references to any type at all (not including functions), which can include
// integers, floating points, strings or objects.
//
// Let's see this in action. We'll create an array of type Any[] and fill it with random bits and
// pieces of stuff:
var things = [Any]()

things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("Hello")
things.append((3.0, 5.0))
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))

// We can now use a switch statement with a mix of "is" and "as" operators to parse through the
// things array and get information from it.
//
// We'll use a switch statement to check each type (and even include a few where clauses to get a
// bit more specific about the value inside the type.) Note that when we do this, we use the forced
// version of the 'as' operator, which is safe in the context of a 'case' because a matched case
// means that it's guaranteed to be a valid value of the given type.
for thing in things
{
	switch thing
	{
		case 0 as Int:
			"zero as an Int"
		case 0 as Double:
			"zero as a Double"
		case let someInt as Int:
			"an integer value of \(someInt)"
		case let someDouble as Double where someDouble > 0:
			"a positive Double value of \(someDouble)"
		case is Double:
			"some other double that I don't want to print"
		case let someString as String:
			"a string value of \(someString)"
		case let (x, y) as (Double, Double):
			"a Tuple used to store an X/Y floating point coordinate: \(x), \(y)"
		case let movie as Movie:
			"A movie called '\(movie.name)'"
		default:
			"Something else"
	}
}
