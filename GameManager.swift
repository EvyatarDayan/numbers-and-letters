import Foundation

struct Question {
    let animalImage: String
    let options: [String]
    
    var correctLetter: String {
        return animalImage.first?.description ?? ""
    }
    
    var correctAnswer: Int {
        let components = animalImage.components(separatedBy: " ")
        if components.count == 3,
           let num1 = Int(components[0]),
           let num2 = Int(components[2]) {
            switch components[1] {
            case "+": return num1 + num2
            case "-": return num1 - num2
            default: return 0
            }
        }
        return 0
    }
}

class GameManager {
    internal var allQuestions: [Question] = []
    internal var questions: [Question] = []
    internal var currentQuestionIndex = 0
    internal var score = 0
    internal var wrongAnswers = 0
    
    init() {
        setupAllQuestions()
        setupGameQuestions()
    }
    
    internal func setupAllQuestions() {
        allQuestions = [
            Question(animalImage: "אריה", options: ["א", "ל", "ק"]),
            Question(animalImage: "ארנב", options: ["א", "ע", "ב"]),
            Question(animalImage: "איל", options: ["א", "ע", "פ"]),
            Question(animalImage: "ברווז", options: ["ב", "ו", "ח"]),
            Question(animalImage: "ברדלס", options: ["ב", "ק", "ד"]),
            Question(animalImage: "גמל", options: ["ג", "ד", "כ"]),
            Question(animalImage: "גורילה", options: ["ג", "ש", "ו"]),
            Question(animalImage: "דג", options: ["ד", "ת", "ר"]),
            Question(animalImage: "דוב", options: ["ד", "מ", "א"]),
            Question(animalImage: "היפופוטם", options: ["ה", "ח", "פ"]),
            Question(animalImage: "זברה", options: ["ז", "צ", "ט"]),
            Question(animalImage: "זבוב", options: ["ז", "ק", "ש"]),
            Question(animalImage: "חתול", options: ["ח", "כ", "פ"]),
            Question(animalImage: "חמור", options: ["ח", "מ", "ש"]),
            Question(animalImage: "ינשוף", options: ["י", "ו", "ת"]),
            Question(animalImage: "יען", options: ["י", "ק", "ג"]),
            Question(animalImage: "כלב", options: ["כ", "ד", "ב"]),
            Question(animalImage: "כלב", options: ["ש", "כ", "ט"]),
            Question(animalImage: "כבשה", options: ["כ", "ז", "ג"]),
            Question(animalImage: "נמר", options: ["נ", "מ", "ס"]),
            Question(animalImage: "נחש", options: ["נ", "ד", "ת"]),
            Question(animalImage: "סוס", options: ["ס", "ו", "ש"]),
            Question(animalImage: "פיל", options: ["פ", "ה", "ר"]),
            Question(animalImage: "צב", options: ["צ", "ב", "ט"]),
            Question(animalImage: "קוף", options: ["ק", "ה", "ח "]),
            Question(animalImage: "קנגורו", options: ["ק", "ש", "ג"]),
            Question(animalImage: "תוכי", options: ["ת", "ש", "ג"]),
            Question(animalImage: "נשר", options: ["נ", "ק", "ג"]),
            Question(animalImage: "סנאי", options: ["ס", "ב", "ר"]),
            Question(animalImage: "ג׳ירפה", options: ["ג", "ח", "צ"]),
            Question(animalImage: "חזיר", options: ["ג", "ח", "ש"]),
            Question(animalImage: "פרה", options: ["ע", "פ", "י"]),
            Question(animalImage: "פינגווין", options: ["ר", "פ", "ק"]),
            Question(animalImage: "כריש", options: ["צ", "נ", "כ"]),
            Question(animalImage: "לוויתן", options: ["ה", "ל", "ס"]),
            Question(animalImage: "עכבר", options: ["צ", "ע", "ח"]),
            Question(animalImage: "פרפר", options: ["ב", "פ", "ז"]),
            Question(animalImage: "צפרדע", options: ["צ", "ב", "א"]),
            Question(animalImage: "תרנגול", options: ["ק", "ל", "ת"])
        ]
    }
    
    internal func setupGameQuestions() {
        questions = Array(allQuestions.shuffled().prefix(10)).map { question in
            Question(
                animalImage: question.animalImage,
                options: question.options.shuffled()
            )
        }
    }
    
    func getCurrentQuestion() -> Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    func checkAnswer(_ answer: String) -> Bool {
        guard let currentQuestion = getCurrentQuestion() else { return false }
        return currentQuestion.correctLetter == answer
    }
    
    func moveToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func incrementScore() {
        score += 1
    }
    
    func getScore() -> Int {
        return score
    }
    
    func getSuccessPercentage() -> Double {
        guard questions.count > 0 else { return 0 }
        return Double(score) / Double(questions.count) * 100
    }
    
    func resetGame() {
        currentQuestionIndex = 0
        score = 0
        wrongAnswers = 0
        setupGameQuestions()
    }
    
    func isGameComplete() -> Bool {
        return currentQuestionIndex >= questions.count
    }
    
    func incrementWrongAnswers() {
        wrongAnswers += 1
    }
    
    func getWrongAnswers() -> Int {
        return wrongAnswers
    }
} 
