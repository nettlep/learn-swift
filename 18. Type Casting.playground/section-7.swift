var movieCount = 0
var songCount = 0
for item in library
{
	if item is Movie { ++movieCount }
	else if item is Song { ++songCount }
}