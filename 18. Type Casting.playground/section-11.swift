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