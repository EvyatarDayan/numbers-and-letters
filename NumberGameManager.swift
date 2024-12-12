class NumberGameManager: GameManager {
    private var currentExpression: String = ""
    private var correctAnswer: Int = 0
    
    override func setupAllQuestions() {
        var expressions: [(String, Int)] = []
        
        // Addition expressions
        for i in 1...5 {
            for j in 1...5 where i + j <= 10 {
                expressions.append(("\(i) + \(j)", i + j))
            }
        }
        
        // Subtraction expressions
        for i in 2...10 {
            for j in 1...5 where i - j >= 0 {
                expressions.append(("\(i) - \(j)", i - j))
            }
        }
        
        // Convert to Questions format and ensure options are strings
        allQuestions = expressions.map { expr, ans in
            let options = generateOptions(correctAnswer: ans)
            return Question(
                animalImage: expr,
                options: options.map { String($0) }  // Convert Int options to String
            )
        }
    }
    
    private func generateOptions(correctAnswer: Int) -> [Int] {
        var options = [correctAnswer]
        print("Generating options for answer:", correctAnswer)
        
        while options.count < 3 {
            let offset = Int.random(in: 1...3)
            let newOption = Bool.random() ? correctAnswer + offset : correctAnswer - offset
            if newOption >= 0 && newOption <= 10 && !options.contains(newOption) {
                options.append(newOption)
            }
        }
        let shuffledOptions = options.shuffled()
        print("Generated options:", shuffledOptions)
        return shuffledOptions
    }
    
    override func checkAnswer(_ answer: String) -> Bool {
        guard let number = Int(answer),
              let currentQuestion = getCurrentQuestion() else { return false }
        
        // Debug prints
        print("User answer:", number)
        print("Expression:", currentQuestion.animalImage)
        
        let components = currentQuestion.animalImage.components(separatedBy: " ")
        if components.count == 3,
           let num1 = Int(components[0]),
           let num2 = Int(components[2]) {
            let expectedResult = components[1] == "+" ? num1 + num2 : num1 - num2
            print("Expected result:", expectedResult)
            print("Comparison result:", number == expectedResult)
            return number == expectedResult
        }
        return false
    }
} 