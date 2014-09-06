switch productBarcode
{
	// All constants
	case let .UPCA(numberSystem, identifier, check):
		"UPCA: \(numberSystem), \(identifier), \(check)"
	
	// All variables
	case var .QRCode(productCode):
		"QR: \(productCode)"
}