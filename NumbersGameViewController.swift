import UIKit
import AVFoundation

class NumbersGameViewController: UIViewController {
    
    internal let feedbackLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal var successAudioPlayer: AVAudioPlayer?
    internal var applauseAudioPlayer: AVAudioPlayer?
    internal var musicLoopPlayer: AVAudioPlayer?
    internal var clickAudioPlayer: AVAudioPlayer?
    internal var gameCompleteOverlay: UIView?
    internal var letterButtons: [UIButton] = []
    internal var currentAttempts = 0
    
    private let newGameButton = UIButton()
    private let muteButton = UIButton()
    private let exitButton = UIButton()
    
    internal let expressionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 120, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal let lettersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    internal let scoreboardView: ScoreboardView = {
        let view = ScoreboardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameBackground5")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    internal var gameManager: GameManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if gameManager == nil {  // Only set if not already set by subclass
            gameManager = NumberGameManager()
        }
        setupButtons()
        setupUI()
        setupAudioPlayers()
        startNewGame()
    }
    
    private func setupButtons() {
        // Setup new game button
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        styleButton(newGameButton, withTitle: "משחק חדש")
        
        // Setup mute button
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        styleButton(muteButton, withTitle: "🔊", fontSize: 40)
        
        // Setup exit button
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        styleButton(exitButton, withTitle: "יציאה")
    }
    
    private func styleButton(_ button: UIButton, withTitle title: String, fontSize: CGFloat = 24) {
        button.setTitle(title, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .bold)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        
        view.addSubview(expressionLabel)
        
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
            
            expressionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            expressionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            expressionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            expressionLabel.heightAnchor.constraint(equalToConstant: 250),
            
            lettersStackView.topAnchor.constraint(equalTo: expressionLabel.bottomAnchor, constant: 80),
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
            exitButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        view.backgroundColor = .clear
        
        newGameButton.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
        muteButton.addTarget(self, action: #selector(toggleMusic), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
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
    
    @objc internal func startNewGame() {
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
    
    @objc internal func toggleMusic() {
        if musicLoopPlayer?.isPlaying == true {
            musicLoopPlayer?.pause()
            muteButton.setTitle("🔈", for: .normal)
        } else {
            musicLoopPlayer?.play()
            muteButton.setTitle("🔊", for: .normal)
        }
    }
    
    @objc internal func exitTapped() {
        musicLoopPlayer?.stop()
        dismiss(animated: true)
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
        
        // Show expression - use animalImage for the expression
        expressionLabel.text = "\(currentQuestion.animalImage) = ?"
        
        // Create number buttons
        for answer in currentQuestion.options {
            let button = UIButton()
            button.setTitle(answer, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 50, weight: .bold)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 15
            
            let buttonSize: CGFloat = 100
            button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
            button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
            
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.white.cgColor
            
            button.addTarget(self, action: #selector(numberTapped(_:)), for: .touchUpInside)
            letterButtons.append(button)
            lettersStackView.addArrangedSubview(button)
        }
    }
    
    @objc internal func numberTapped(_ sender: UIButton) {
        // Play click sound
        clickAudioPlayer?.play()
        
        guard let selectedNumber = sender.title(for: .normal),
              let currentQuestion = gameManager.getCurrentQuestion() else { return }
        
        // Disable buttons first
        letterButtons.forEach { $0.isEnabled = false }
        
        if gameManager.checkAnswer(selectedNumber) {
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
                // Move to next question after feedback
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [weak self] in
                    guard let self = self else { return }
                    if !self.gameManager.isGameComplete() {
                        self.gameManager.moveToNextQuestion()
                        self.updateUI()
                        self.letterButtons.forEach { $0.isEnabled = true }
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
        
        feedbackLabel.text = " כל הכבוד! התשובה \(currentQuestion.correctAnswer) נכונה! "
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
        התשובה הנכונה היא \(currentQuestion.correctAnswer)!
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
        
        // Fade out before next question
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
        
        // Animate in with confetti sequence
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
        // Create confetti view
        let confettiView = UIView(frame: view.bounds)
        confettiView.tag = 999
        
        // Remove any existing confetti views first
        view.subviews.forEach { if $0.tag == 999 { $0.removeFromSuperview() } }
        
        // Add to view hierarchy and ensure it's on top
        view.addSubview(confettiView)
        view.bringSubviewToFront(confettiView)
        
        // Create and configure emitter
        let emitter = CAEmitterLayer()
        emitter.frame = confettiView.bounds
        emitter.emitterPosition = CGPoint(x: confettiView.bounds.width / 2, y: confettiView.bounds.height / 2)
        emitter.emitterShape = .point
        emitter.emitterSize = CGSize(width: 1, height: 1)
        emitter.renderMode = .additive
        
        let colors: [UIColor] = [.systemPink, .systemBlue, .systemPurple, .systemYellow, .systemGreen, .systemOrange, .systemRed, .systemTeal]
        let cells: [CAEmitterCell] = colors.map { color in
            let cell = CAEmitterCell()
            cell.birthRate = 300
            cell.lifetime = 2.0
            cell.lifetimeRange = 0.5
            cell.velocity = 400
            cell.velocityRange = 100
            cell.emissionRange = .pi * 2.0
            cell.spin = 4
            cell.spinRange = 8
            cell.scale = 0.6
            cell.scaleRange = 0.3
            cell.scaleSpeed = -0.1
            cell.contents = createStarShape().cgImage
            cell.color = color.cgColor
            cell.alphaSpeed = -0.5
            return cell
        }
        
        emitter.emitterCells = cells
        confettiView.layer.addSublayer(emitter)
        
        // After setting up emitter, ensure confetti stays on top again
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(confettiView)
        }
        
        // Start emission immediately
        emitter.beginTime = CACurrentMediaTime()
        emitter.birthRate = 1.0
        
        // Stop emission after a short burst
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            emitter.birthRate = 0.0
            self.view.bringSubviewToFront(confettiView)  // Keep it on top
        }
        
        // Remove the confetti view after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view.bringSubviewToFront(confettiView)  // One last time before fade out
            UIView.animate(withDuration: 0.5) {
                confettiView.alpha = 0
            } completion: { _ in
                confettiView.removeFromSuperview()
            }
        }
    }
    
    internal func createStarShape() -> UIImage {
        let size = CGSize(width: 20, height: 20)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            
            // Create a star path
            let path = UIBezierPath()
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let outerRadius = rect.width / 2
            let innerRadius = rect.width / 4
            let points = 4
            
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
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
} 