struct LevelTracker
{
	var currentLevel = 1
	static var highestUnlockedLevel = 1
	
	static func unlockedLevel(level: Int)
	{
		if level > highestUnlockedLevel
		{
			highestUnlockedLevel = level
		}
	}
	static func levelIsUnlocked(level: Int) -> Bool
	{
		return level <= highestUnlockedLevel
	}
	mutating func advanceToLevel(level: Int) -> Bool
	{
		if LevelTracker.levelIsUnlocked(level)
		{
			currentLevel = level
			return true
		}
		else
		{
			return false
		}
	}
}