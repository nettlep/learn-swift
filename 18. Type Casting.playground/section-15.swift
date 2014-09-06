for object: AnyObject in someObjects
{
	let movie = object as Movie
	"Movie: '\(movie.name)' was directed by \(movie.director)"
}