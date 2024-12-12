class NumbersStage2Manager: NumberGameManager {
    private var currentExpression: String = ""
    private var correctAnswer: Int = 0
    
    override func setupAllQuestions() {
        var expressions: [(String, Int)] = []
        
        // Addition expressions up to 20
        for i in 1...15 {
            for j in 1...5 where i + j <= 20 {
                expressions.append(("\(i) + \(j)", i + j))
            }
        }
        
        // Subtraction expressions up to 20
        for i in 5...20 {
            for j in 1...5 where i - j >= 0 {
                expressions.append(("\(i) - \(j)", i - j))
            }
        }
        
        // Convert to Questions format and ensure options are strings
        allQuestions = expressions.map { expr, ans in
            let options = generateOptions(correctAnswer: ans)
            return Question(
                animalImage: expr,
                options: options.map { String($0) }
            )
        }
    }
    
    private func generateOptions(correctAnswer: Int) -> [Int] {
        var options = [correctAnswer]
        while options.count < 3 {
            let offset = Int.random(in: 1...3)
            let newOption = Bool.random() ? correctAnswer + offset : correctAnswer - offset
            if newOption >= 0 && newOption <= 20 && !options.contains(newOption) {
                options.append(newOption)
            }
        }
        return options.shuffled()
    }
} 