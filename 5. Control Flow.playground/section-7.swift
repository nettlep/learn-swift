var indx = 3999
for indx in 1...5
{
	indx // This ranges from 1 to 5, inclusive

	// 'indx' is still acting like a constant, so this line won't compile:
	//
	// indx++
}