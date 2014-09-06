let count = 3_000_000_000_000
switch count
{
	case 0:
		"no"
	case 1...3:
		"a few"
	case 4...9:
		"several"
	case 10...99:
		"tens of"
	case 100...999:
		"hundreds of"
	case 1000...999999:
		"thousands of"
	default:
		"millions and millions of"
}