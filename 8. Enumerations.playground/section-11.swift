enum Barcode
{
	case UPCA(Int, Int, Int) // UPCA with associated value type (Int, Int, Int)
	case QRCode(String)      // QRCode with associated value type of String
}