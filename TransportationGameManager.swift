class TransportationGameManager: GameManager {
    override func setupAllQuestions() {
        // Create a pool of questions with transportation images
        allQuestions = [
            Question(animalImage: "אוטובוס", options: ["א", "ב", "ת"]),
            Question(animalImage: "מכונית", options: ["מ", "ל", "כ"]),
            Question(animalImage: "מונית", options: ["מ", "ס", "ג"]),
            Question(animalImage: "כבאית", options: ["ש", "ד", "כ"]),
            Question(animalImage: "אמבולנס", options: ["ש", "א", "כ"]),
            Question(animalImage: "רכבת", options: ["ר", "ד", "ק"]),
            Question(animalImage: "אופניים", options: ["א", "ע", "ב"]),
            Question(animalImage: "מטוס", options: ["מ", "ט", "נ"]),
            Question(animalImage: "אוניה", options: ["א", "ק", "פ"]),
            Question(animalImage: "קורקינט", options: ["ק", "ר", "ת"]),
            Question(animalImage: "משאית", options: ["מ", "ש", "ת"]),
            Question(animalImage: "טרקטור", options: ["ט", "ר", "ס"]),
            Question(animalImage: "אופנוע", options: ["א", "ו", "ע"]),
            Question(animalImage: "מסוק", options: ["מ", "ב", "ק"]),
            Question(animalImage: "רכבל", options: ["ר", "ש", "ג"]),
            Question(animalImage: "גרר", options: ["ב", "י", "ג"]),
            Question(animalImage: "מערבל בטון", options: ["ב", "מ", "ד"]),
            Question(animalImage: "כדור פורח", options: ["כ", "ש", "ג"]),
            Question(animalImage: "צוללת", options: ["צ", "ש", "ג"]),
            Question(animalImage: "קאיאק", options: ["ה", "ת", "ק"]),
            Question(animalImage: "מלגזה", options: ["ד", "מ", "ת"])
        ]
    }
} 
