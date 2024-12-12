import UIKit
import Foundation

class NumbersStage2ViewController: NumbersGameViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        gameManager = NumbersStage2Manager()
        
        // Add background image view
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = UIImage(named: "newBack2")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(backgroundImageView, at: 0)  // Insert at index 0 to be behind other views
        
        startNewGame()
    }
    
    override func showCorrectAnswerFeedback() {
        guard let currentQuestion = gameManager.getCurrentQuestion() else { return }
        
        // Play success sound immediately
        successAudioPlayer?.play()
        
        // Show confetti with 0.3s delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showConfetti()
        }
        
        // Calculate the correct answer from the expression
        let components = currentQuestion.animalImage.components(separatedBy: " ")
        if components.count == 3,
           let num1 = Int(components[0]),
           let num2 = Int(components[2]) {
            let result = components[1] == "+" ? num1 + num2 : num1 - num2
            
            feedbackLabel.text = " כל הכבוד! התשובה \(result) נכונה! "
            feedbackLabel.textColor = .white
            feedbackLabel.font = .systemFont(ofSize: 48, weight: .bold)
            feedbackLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            feedbackLabel.layer.cornerRadius = 0
            feedbackLabel.clipsToBounds = true
            feedbackLabel.alpha = 0
            
            // Start with small scale
            feedbackLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            // Animate to full size with bounce effect
            UIView.animate(withDuration: 1.0, 
                          delay: 0,
                          usingSpringWithDamping: 0.5,
                          initialSpringVelocity: 0.5,
                          options: [],
                          animations: {
                self.feedbackLabel.transform = .identity
                self.feedbackLabel.alpha = 1
            })
            
            // Fade out before next question
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                UIView.animate(withDuration: 0.5) {
                    self.feedbackLabel.alpha = 0
                }
            }
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
} 