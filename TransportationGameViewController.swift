import UIKit

class TransportationGameViewController: GameViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        gameManager = TransportationGameManager()
        
        // Update background image view
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "newBack4")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(backgroundImageView, at: 0)  // Insert at index 0 to be behind other views
        
        startNewGame()
    }
    
    override internal func updateUI() {
        guard let currentQuestion = gameManager.getCurrentQuestion() else {
            showGameComplete()
            return
        }
        
        // Clear previous state
        lettersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        letterButtons.removeAll()
        feedbackLabel.text = ""
        currentAttempts = 0
        
        // Update score
        let correctAnswers = gameManager.getScore()
        let wrongAnswers = gameManager.getWrongAnswers()
        scoreboardView.updateScores(correct: correctAnswers, wrong: wrongAnswers)
        
        // Load and set new image with forced refresh
        animalImageView.image = nil // Clear the image first
        if let image = UIImage(named: currentQuestion.animalImage) {
            UIView.transition(with: animalImageView,
                            duration: 0.5,
                            options: .transitionCrossDissolve,
                            animations: {
                self.animalImageView.image = image
            }, completion: nil)
        } else {
            print("Failed to load image: \(currentQuestion.animalImage)")
        }
        
        // Create new letter buttons
        for letter in currentQuestion.options {
            let button = UIButton()
            button.setTitle(letter, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 50, weight: .bold)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 15
            
            let buttonSize: CGFloat = 100
            button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
            button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
            
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.white.cgColor
            
            button.addTarget(self, action: #selector(letterTapped(_:)), for: .touchUpInside)
            letterButtons.append(button)
            lettersStackView.addArrangedSubview(button)
        }
    }
} 