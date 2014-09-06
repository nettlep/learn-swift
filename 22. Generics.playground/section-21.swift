var stringStack = StackContainer<String>()
stringStack.push("Albert")
stringStack.push("Andrew")
stringStack.push("Betty")
stringStack.push("Jacob")
stringStack.pop()
stringStack.count

var doubleStack = StackContainer<Double>()
doubleStack.push(3.14159)
doubleStack.push(42.0)
doubleStack.push(1_000_000)
doubleStack.pop()
doubleStack.count