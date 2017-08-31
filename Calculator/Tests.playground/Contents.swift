
let num  = 20

for i in 0..<num {
	guard i % 2 == 0 else { continue }
	print(i)
}

let str = "Swift"

for s in str.characters {
	guard s != "i" else { continue }
	print(s)
}
