//
//  GameViewController.swift
//  Game1
//
//  Created by EVYATAR DAYAN on 08/12/2024.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    internal let animalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    internal let scoreboardView: ScoreboardView = {
        let view = ScoreboardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let newGameButton: UIButton = {
        let button = UIButton()
        button.setTitle("משחק חדש", for: .normal)
        button.backgroundColor = .black
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    internal let lettersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    internal let feedbackLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "newBack4")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.borderWidth = 19
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Add inner shadow effect
        let innerShadow = CALayer()
        innerShadow.frame = view.bounds
        innerShadow.backgroundColor = UIColor.black.cgColor
        innerShadow.cornerRadius = 15
        innerShadow.shadowColor = UIColor.black.cgColor
        innerShadow.shadowOffset = CGSize(width: 0, height: 5)
        innerShadow.shadowOpacity = 0.7
        innerShadow.shadowRadius = 6
        view.layer.addSublayer(innerShadow)
        
        return view
    }()
    
    private let muteButton: UIButton = {
        let button = UIButton()
        button.setTitle("🔊", for: .normal) // Sound on emoji
        button.backgroundColor = .black
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 40, weight: .bold) // Larger font for emoji
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("יציאה", for: .normal)
        button.backgroundColor = .black
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    internal var gameManager: GameManager!
    internal var currentAttempts = 0
    internal var letterButtons: [UIButton] = []
    internal var successAudioPlayer: AVAudioPlayer?
    internal var applauseAudioPlayer: AVAudioPlayer?
    internal var musicLoopPlayer: AVAudioPlayer?
    internal var gameCompleteOverlay: UIView?
    internal var clickAudioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAudioPlayers()
        gameManager = GameManager()
        startNewGame()
    }
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        
        view.addSubview(imageContainerView)
        imageContainerView.addSubview(animalImageView)
        
        view.addSubview(newGameButton)
        view.addSubview(scoreboardView)
        view.addSubview(lettersStackView)
        view.addSubview(feedbackLabel)
        view.addSubview(muteButton)
        view.addSubview(exitButton)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            newGameButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            newGameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            newGameButton.widthAnchor.constraint(equalToConstant: 180),
            newGameButton.heightAnchor.constraint(equalToConstant: 80),
            
            scoreboardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scoreboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scoreboardView.widthAnchor.constraint(equalToConstant: 180),
            scoreboardView.heightAnchor.constraint(equalToConstant: 80),
            
            imageContainerView.topAnchor.constraint(equalTo: scoreboardView.bottomAnchor, constant: 20),
            imageContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageContainerView.heightAnchor.constraint(equalToConstant: 400),
            imageContainerView.widthAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 1.5),
            
            animalImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            animalImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            animalImageView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor, constant: -40),
            animalImageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, constant: -40),
            
            lettersStackView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 60),
            lettersStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lettersStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            feedbackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            feedbackLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            feedbackLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.6),
            feedbackLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 150),
            
            muteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            muteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            muteButton.widthAnchor.constraint(equalToConstant: 180),
            muteButton.heightAnchor.constraint(equalToConstant: 80),
            
            exitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            exitButton.widthAnchor.constraint(equalToConstant: 180),
            exitButton.heightAnchor.constraint(equalToConstant: 80),
        ])
        
        view.backgroundColor = .clear
        animalImageView.backgroundColor = .clear
        
        newGameButton.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
        muteButton.addTarget(self, action: #selector(toggleMusic), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
        
        imageContainerView.layer.shadowColor = UIColor.black.cgColor
        imageContainerView.layer.shadowOffset = CGSize(width: 0, height: 8)
        imageContainerView.layer.shadowRadius = 12
        imageContainerView.layer.shadowOpacity = 0.8
    }
    
    private func setupAudioPlayers() {
        // Setup success sound
        if let successURL = Bundle.main.url(forResource: "success", withExtension: "mp3") {
            successAudioPlayer = try? AVAudioPlayer(contentsOf: successURL)
            successAudioPlayer?.prepareToPlay()
        }
        
        // Setup applause sound
        if let applauseURL = Bundle.main.url(forResource: "applause", withExtension: "mp3") {
            applauseAudioPlayer = try? AVAudioPlayer(contentsOf: applauseURL)
            applauseAudioPlayer?.prepareToPlay()
        }
        
        // Setup music loop
        if let musicURL = Bundle.main.url(forResource: "musicLoop", withExtension: "mp3") {
            musicLoopPlayer = try? AVAudioPlayer(contentsOf: musicURL)
            musicLoopPlayer?.numberOfLoops = -1
            musicLoopPlayer?.volume = 0.4
            musicLoopPlayer?.prepareToPlay()
        }
        
        // Setup click sound
        if let clickURL = Bundle.main.url(forResource: "click", withExtension: "mp3") {
            clickAudioPlayer = try? AVAudioPlayer(contentsOf: clickURL)
            clickAudioPlayer?.prepareToPlay()
        }
    }
    
    @objc func startNewGame() {
        // Remove all overlay views including blur
        view.subviews.forEach { view in
            if view is UIVisualEffectView || view == gameCompleteOverlay {
                UIView.animate(withDuration: 0.3, animations: {
                    view.alpha = 0
                }) { _ in
                    view.removeFromSuperview()
                }
            }
        }
        
        // Clear the overlay reference
        gameCompleteOverlay = nil
        
        // Reset game state
        gameManager.resetGame()
        currentAttempts = 0
        updateUI()
        
        // Start background music
        musicLoopPlayer?.play()
    }
    
    internal func updateUI() {
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
        
        // Load and set new image with fade transition
        if let image = UIImage(named: currentQuestion.animalImage) {
            UIView.transition(with: animalImageView,
                             duration: 0.5,
                             options: .transitionCrossDissolve,
                             animations: {
                self.animalImageView.image = image
            }, completion: nil)
        } else {
            print("Failed to load image: \(currentQuestion.animalImage)")
            animalImageView.backgroundColor = .lightGray
        }
        
        // Create new letter buttons
        for letter in currentQuestion.options {
            let button = UIButton()
            button.setTitle(letter, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 50, weight: .bold)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 15
            
            // Make buttons square with equal width and height
            let buttonSize: CGFloat = 100  // Size for both width and height
            button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
            button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
            
            // Optional: Add a border
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.white.cgColor
            
            button.addTarget(self, action: #selector(letterTapped(_:)), for: .touchUpInside)
            letterButtons.append(button)
            lettersStackView.addArrangedSubview(button)
        }
    }
    
    @objc internal func letterTapped(_ sender: UIButton) {
        // Play click sound only
        clickAudioPlayer?.play()
        
        guard let selectedLetter = sender.title(for: .normal),
              let currentQuestion = gameManager.getCurrentQuestion() else { return }
        
        // Disable buttons first
        letterButtons.forEach { $0.isEnabled = false }
        
        if gameManager.checkAnswer(selectedLetter) {
            // Show green background for correct answer
            sender.backgroundColor = .systemGreen
            
            // Increment score
            gameManager.incrementScore()
            
            // Show feedback and confetti together
            showCorrectAnswerFeedback()
            
            // Move to next question after animations complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                guard let self = self else { return }
                if !self.gameManager.isGameComplete() {
                    self.gameManager.moveToNextQuestion()
                    self.updateUI()
                    self.letterButtons.forEach { $0.isEnabled = true }
                } else {
                    self.showGameComplete()
                }
            }
        } else {
            // Wrong answer
            currentAttempts += 1
            if currentAttempts == 1 {
                showTryAgainFeedback()
                sender.backgroundColor = .systemRed
                // Re-enable buttons after feedback
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
                    self?.letterButtons.forEach { $0.isEnabled = true }
                    sender.backgroundColor = .systemBlue
                }
            } else {
                gameManager.incrementWrongAnswers()
                showWrongAnswerFeedback()
                // Increased delay to 4.0 seconds before moving to next question
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
                    guard let self = self else { return }
                    if !self.gameManager.isGameComplete() {
                        self.gameManager.moveToNextQuestion()
                        DispatchQueue.main.async {
                            self.updateUI()
                            self.letterButtons.forEach { $0.isEnabled = true }
                        }
                    } else {
                        self.showGameComplete()
                    }
                }
            }
        }
    }
    
    internal func showCorrectAnswerFeedback() {
        guard let currentQuestion = gameManager.getCurrentQuestion() else { return }
        
        // Play success sound immediately
        successAudioPlayer?.play()
        
        // Show confetti with 0.3s delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showConfetti()
        }
        
        feedbackLabel.text = " כל הכבוד! \(currentQuestion.animalImage)! "
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
    
    internal func showTryAgainFeedback() {
        feedbackLabel.text = "נסה שוב..."
        feedbackLabel.textColor = .red
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
        
        // Fade out before next attempt
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 0.5) {
                self.feedbackLabel.alpha = 0
            }
        }
    }
    
    internal func showWrongAnswerFeedback() {
        guard let currentQuestion = gameManager.getCurrentQuestion() else { return }
        
        feedbackLabel.text = """
        הפעם טעית... 😔
        זה היה \(currentQuestion.animalImage)!
        """
        feedbackLabel.numberOfLines = 0
        feedbackLabel.textAlignment = .center
        feedbackLabel.textColor = .red
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
        
        // Fade out before next question - increased to 3.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            UIView.animate(withDuration: 0.5) {
                self.feedbackLabel.alpha = 0
            }
        }
    }
    
    internal func showGameComplete() {
        // Stop background music
        musicLoopPlayer?.stop()
        
        // Play applause sound
        applauseAudioPlayer?.play()
        
        // Add blur effect to background
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create completion overlay view
        let overlayView = UIView(frame: view.bounds)
        self.gameCompleteOverlay = overlayView
        
        let contentView = UIView()
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let percentage = Int(gameManager.getSuccessPercentage())
        let score = gameManager.getScore()
        let total = 10
        
        // Create labels without emojis
        let titleLabel = createLabel(text: "סיימת את המשחק!", fontSize: 32)
        
        let performanceMessage: String
        if percentage >= 90 {
            performanceMessage = "מדהים! כל הכבוד!"
        } else if percentage >= 70 {
            performanceMessage = "יפה מאוד!"
        } else if percentage >= 50 {
            performanceMessage = "כל הכבוד! נסה שוב"
        } else {
            performanceMessage = "המשך להתאמן!"
        }
        
        let performanceLabel = createLabel(text: performanceMessage, fontSize: 28)
        let scoreLabel = createLabel(text: "תשובות נכונות: \(score) מתוך \(total)", fontSize: 24)
        let percentageLabel = createLabel(text: "אחוז הצלחה: \(percentage)%", fontSize: 24)
        
        let playAgainButton = UIButton()
        playAgainButton.setTitle("משחק חדש", for: .normal)
        playAgainButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        playAgainButton.backgroundColor = .systemBlue
        playAgainButton.layer.cornerRadius = 15
        playAgainButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 30, bottom: 12, right: 30)
        playAgainButton.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
        
        // Add views to hierarchy
        view.addSubview(blurView)
        view.addSubview(overlayView)
        overlayView.addSubview(contentView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(performanceLabel)
        stackView.addArrangedSubview(scoreLabel)
        stackView.addArrangedSubview(percentageLabel)
        stackView.addArrangedSubview(playAgainButton)
        
        contentView.addSubview(stackView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            contentView.widthAnchor.constraint(equalTo: overlayView.widthAnchor, multiplier: 0.85),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        // Animate in
        blurView.alpha = 0
        contentView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        UIView.animate(withDuration: 0.3) {
            blurView.alpha = 1
            contentView.transform = .identity
        } completion: { _ in
            // Start confetti sequence after popup appears, with 0.3s delays
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.showConfetti()  // First burst
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.showConfetti()  // Second burst
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    self.showConfetti()  // Third burst
                }
            }
        }
    }
    
    internal func createLabel(text: String, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = .systemFont(ofSize: fontSize, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
    
    internal func showConfetti() {
        // Create confetti view with window bounds
        guard let window = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first else { return }
        
        // Remove any existing confetti views first - more thorough cleanup
        window.subviews.forEach { view in
            if view.tag == 999 {
                view.removeFromSuperview()
            }
        }
        
        let confettiView = UIView(frame: window.bounds)
        confettiView.tag = 999
        
        // Add to window and ensure it's on top
        window.addSubview(confettiView)
        window.bringSubviewToFront(confettiView)
        
        // Create and configure emitter
        let emitter = CAEmitterLayer()
        emitter.frame = confettiView.bounds
        emitter.emitterPosition = CGPoint(x: confettiView.bounds.width / 2, y: confettiView.bounds.height / 2)
        emitter.emitterShape = .point
        emitter.emitterSize = CGSize(width: 1, height: 1)
        emitter.renderMode = .additive
        
        // Create emitter cells
        let colors: [UIColor] = [.systemPink, .systemBlue, .systemPurple, .systemYellow, .systemGreen, .systemOrange, .systemRed, .systemTeal]
        let cells: [CAEmitterCell] = colors.map { color in
            let cell = CAEmitterCell()
            cell.birthRate = 150  // Adjusted for better visibility
            cell.lifetime = 3.0   // Adjusted duration
            cell.lifetimeRange = 0.5
            cell.velocity = 350
            cell.velocityRange = 80
            cell.emissionRange = .pi * 2.0
            cell.spin = 4
            cell.spinRange = 8
            cell.scale = 0.6
            cell.scaleRange = 0.3
            cell.scaleSpeed = -0.1
            cell.contents = createStarShape().cgImage
            cell.color = color.cgColor
            cell.alphaSpeed = -0.3
            return cell
        }
        
        emitter.emitterCells = cells
        confettiView.layer.addSublayer(emitter)
        
        // Ensure emission starts cleanly
        emitter.beginTime = CACurrentMediaTime()
        emitter.birthRate = 1.0
        
        // Stop emission after a short burst
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            emitter.birthRate = 0.0
        }
        
        // Remove the confetti view after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.3) {
                confettiView.alpha = 0
            } completion: { _ in
                confettiView.removeFromSuperview()
            }
        }
    }
    
    internal func createStarShape() -> UIImage {
        let size = CGSize(width: 20, height: 20) // Increased from 12x12
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            
            // Create a star path
            let path = UIBezierPath()
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let outerRadius = rect.width / 2
            let innerRadius = rect.width / 4
            let points = 4 // Number of star points
            
            for i in 0..<points * 2 {
                let radius = i % 2 == 0 ? outerRadius : innerRadius
                let angle = CGFloat(i) * .pi / CGFloat(points)
                let point = CGPoint(
                    x: center.x + radius * cos(angle),
                    y: center.y + radius * sin(angle)
                )
                
                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            path.close()
            
            UIColor.white.setFill()
            path.fill()
        }
    }
    
    @objc private func toggleMusic() {
        if musicLoopPlayer?.isPlaying == true {
            musicLoopPlayer?.pause()
            muteButton.setTitle("🔈", for: .normal) // Sound off emoji
        } else {
            musicLoopPlayer?.play()
            muteButton.setTitle("🔊", for: .normal) // Sound on emoji
        }
    }
    
    @objc private func exitTapped() {
        // Disable the button immediately to prevent multiple taps
        exitButton.isEnabled = false
        
        // Stop music if playing
        musicLoopPlayer?.stop()
        musicLoopPlayer = nil  // Clear the player
        
        // Ensure we're on the main thread for UI updates
        DispatchQueue.main.async {
            // Dismiss with completion handler
            self.dismiss(animated: true) {
                // Re-enable button after dismissal (in case dismissal fails)
                self.exitButton.isEnabled = true
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

class PaddedLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        numberOfLines = 0 // Allow multiple lines by default
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        numberOfLines = 0 // Allow multiple lines by default
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let padding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)  // Reduced padding
        return CGSize(width: size.width + padding.left + padding.right,
                     height: size.height + padding.top + padding.bottom)
    }
    
    override func drawText(in rect: CGRect) {
        let padding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)  // Reduced padding
        super.drawText(in: rect.inset(by: padding))
    }
}
