let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
var reversed = [String]()
reversed = names.sorted({
    (s1: String, s2: String) -> Bool in
        return s1 > s2
})