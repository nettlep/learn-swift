class DataImporter
{
	var filename = "data.txt"
}

class DataManager
{
	lazy var importer = DataImporter()
	var data = [String]()
}