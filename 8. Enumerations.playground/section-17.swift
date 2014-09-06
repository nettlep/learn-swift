switch productBarcode
{
	case .UPCA(let numberSystem, let identifier, let check):
		"UPCA: \(numberSystem), \(identifier), \(check)"
	case .QRCode(let productCode):
		"QR: \(productCode)"
}