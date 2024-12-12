import UIKit
import AVFoundation

class WelcomePage: UIViewController {
    
    private var selectAudioPlayer: AVAudioPlayer?
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "abashelariCentered")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 40  // Space between buttons
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func createGameButton(withText text: String, coloredWord: String, backgroundImage: String? = nil) -> UIButton {
        let button = UIButton()
        
        // Split text into parts
        let parts = text.components(separatedBy: coloredWord)
        let attributedString = NSMutableAttributedString()
        
        // Create paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 20
        
        // Add first part in black with smaller font
        let firstPart = NSAttributedString(
            string: parts[0],
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 30, weight: .bold),
                .foregroundColor: UIColor.black
            ]
        )
        attributedString.append(firstPart)
        
        // Add colored word in black with smaller font
        let coloredPart = NSAttributedString(
            string: coloredWord,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.systemFont(ofSize: 30, weight: .bold),
                .foregroundColor: UIColor.black
            ]
        )
        attributedString.append(coloredPart)
        
        button.setAttributedTitle(attributedString, for: .normal)
        button.titleLabel?.numberOfLines = 0
        
        // Rest of button setup remains the same
        if let imageName = backgroundImage, let image = UIImage(named: imageName) {
            button.setBackgroundImage(image, for: .normal)
            button.backgroundColor = .clear
        } else {
            button.backgroundColor = .black
        }
        
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.masksToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 8)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    private lazy var lettersButton = createGameButton(
        withText: "לומדים אותיות חיות",
        coloredWord: "חיות",
        backgroundImage: "pencil"
    )
    private lazy var numbersButton = createGameButton(
        withText: "לומדים מספרים שלב 1",
        coloredWord: "שלב 1",
        backgroundImage: "pencil"
    )
    private lazy var transportationButton = createGameButton(
        withText: "לומדים אותיות תחבורה",
        coloredWord: "תחבורה",
        backgroundImage: "pencil"
    )
    private lazy var numbersStage2Button = createGameButton(
        withText: "לומדים מספרים שלב 2",
        coloredWord: "שלב 2",
        backgroundImage: "pencil"
    )
    private lazy var lettersPracticeButton = createGameButton(
        withText: "לומדים לכתוב אותיות",
        coloredWord: "לכתוב",
        backgroundImage: "pencil"
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAudioPlayer()
    }
    
    private func setupAudioPlayer() {
        if let soundURL = Bundle.main.url(forResource: "click", withExtension: "mp3") {
            selectAudioPlayer = try? AVAudioPlayer(contentsOf: soundURL)
            selectAudioPlayer?.prepareToPlay()
        }
    }
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(buttonsStackView)
        
        // Add buttons to stack view in new order (from left to right):
        // Transportation Letters -> Animal Letters -> Numbers -> Numbers Stage 2 -> Letters Practice
        buttonsStackView.addArrangedSubview(transportationButton)
        buttonsStackView.addArrangedSubview(lettersButton)
        buttonsStackView.addArrangedSubview(numbersButton)
        buttonsStackView.addArrangedSubview(numbersStage2Button)
        buttonsStackView.addArrangedSubview(lettersPracticeButton)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Position stack view
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            // Set height for buttons
            lettersButton.heightAnchor.constraint(equalToConstant: 300),
            numbersButton.heightAnchor.constraint(equalToConstant: 300),
            transportationButton.heightAnchor.constraint(equalToConstant: 300),
            numbersStage2Button.heightAnchor.constraint(equalToConstant: 300),
            lettersPracticeButton.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // Update gradient layers in the same order
        [transportationButton, lettersButton, numbersButton, numbersStage2Button, lettersPracticeButton].forEach { button in
            if let gradientLayer = button.layer.sublayers?.first as? CAGradientLayer {
                gradientLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
            }
        }
        
        // Add targets for buttons in the same order
        transportationButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        transportationButton.addTarget(self, action: #selector(transportationButtonTouchUp), for: [.touchUpInside, .touchUpOutside])
        
        lettersButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        lettersButton.addTarget(self, action: #selector(letterButtonTouchUp), for: [.touchUpInside, .touchUpOutside])
        
        numbersButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        numbersButton.addTarget(self, action: #selector(numberButtonTouchUp), for: [.touchUpInside, .touchUpOutside])
        
        numbersStage2Button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        numbersStage2Button.addTarget(self, action: #selector(numbersStage2ButtonTouchUp), for: [.touchUpInside, .touchUpOutside])
        
        lettersPracticeButton.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        lettersPracticeButton.addTarget(self, action: #selector(lettersPracticeButtonTouchUp), for: [.touchUpInside, .touchUpOutside])
    }
    
    @objc private func buttonTouchDown(_ sender: UIButton) {
        selectAudioPlayer?.play()
        
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            sender.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    
    @objc private func letterButtonTouchUp() {
        animateButtonRelease(lettersButton) {
            self.showInstructions()
        }
    }
    
    @objc private func numberButtonTouchUp() {
        animateButtonRelease(numbersButton) {
            self.showNumbersInstructions()
        }
    }
    
    @objc private func transportationButtonTouchUp() {
        animateButtonRelease(transportationButton) {
            self.showTransportationInstructions()
        }
    }
    
    @objc private func numbersStage2ButtonTouchUp() {
        animateButtonRelease(numbersStage2Button) {
            self.showNumbersStage2Instructions()
        }
    }
    
    @objc private func lettersPracticeButtonTouchUp() {
        animateButtonRelease(lettersPracticeButton) {
            self.showLettersPracticeInstructions()
        }
    }
    
    private func animateButtonRelease(_ button: UIButton, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = .identity
            button.layer.shadowOffset = CGSize(width: 0, height: 8)
        }) { _ in
            completion()
        }
    }
    
    private func showInstructions() {
        // Create the popup view
        let popupView = UIView()
        popupView.backgroundColor = .black
        popupView.layer.cornerRadius = 20
        popupView.layer.borderWidth = 2
        popupView.layer.borderColor = UIColor.white.cgColor
        popupView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create instructions label with bigger text
        let instructionsLabel = UILabel()
        instructionsLabel.text = "במשחק זה נצפה בתמונות של חיות וננסה לבחור את האות שמתחילה את שמם, אם טעית לא נורא, נסה שוב, בסיום 10 סיבובים יוצג לוח התוצאות. בהצלחה!"
        instructionsLabel.textColor = .white
        instructionsLabel.font = .systemFont(ofSize: 32, weight: .regular)  // Increased from 24 to 32
        instructionsLabel.numberOfLines = 0
        instructionsLabel.textAlignment = .center
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create buttons stack view for horizontal layout
        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 20
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create start button
        let startButton = UIButton()
        startButton.setTitle("בואו נתחיל!", for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.layer.cornerRadius = 15
        startButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startGameFromInstructions), for: .touchUpInside)
        
        // Create back button
        let backButton = UIButton()
        backButton.setTitle("חזרה", for: .normal)
        backButton.backgroundColor = .systemGray
        backButton.layer.cornerRadius = 15
        backButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(dismissInstructions), for: .touchUpInside)
        
        // Add blur effect to background
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add views to hierarchy
        view.addSubview(blurView)
        view.addSubview(popupView)
        popupView.addSubview(instructionsLabel)
        buttonsStackView.addArrangedSubview(backButton)
        buttonsStackView.addArrangedSubview(startButton)
        popupView.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            // Blur view constraints
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Popup view constraints
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            // Instructions label constraints
            instructionsLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 40),
            instructionsLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 30),
            instructionsLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -30),
            
            // Buttons stack view constraints
            buttonsStackView.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 40),
            buttonsStackView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 30),
            buttonsStackView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -30),
            buttonsStackView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -40),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Animate popup appearance
        popupView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        blurView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            popupView.transform = .identity
            blurView.alpha = 1
        }
    }
    
    @objc private func startGameFromInstructions() {
        // Remove popup and start game
        view.subviews.forEach { view in
            if view is UIVisualEffectView || view.layer.cornerRadius == 20 {
                UIView.animate(withDuration: 0.2, animations: {
                    view.alpha = 0
                }) { _ in
                    view.removeFromSuperview()
                }
            }
        }
        
        // Start the actual game
        let gameVC = GameViewController()
        gameVC.modalPresentationStyle = .fullScreen
        present(gameVC, animated: true)
    }
    
    // Add this method to handle back button tap
    @objc private func dismissInstructions() {
        view.subviews.forEach { view in
            if view is UIVisualEffectView || view.layer.cornerRadius == 20 {
                UIView.animate(withDuration: 0.2, animations: {
                    view.alpha = 0
                }) { _ in
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    private func showNumbersInstructions() {
        // Create the popup view
        let popupView = UIView()
        popupView.backgroundColor = .black
        popupView.layer.cornerRadius = 20
        popupView.layer.borderWidth = 2
        popupView.layer.borderColor = UIColor.white.cgColor
        popupView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create instructions label with bigger text
        let instructionsLabel = UILabel()
        instructionsLabel.text = "במשחק זה נתרגל חיבור וחיסור של מספרים, אם טעית לא נורא, נסה שוב, בסיום 10 סיבובים יוצג לוח התוצאות. בהצלחה!"
        instructionsLabel.textColor = .white
        instructionsLabel.font = .systemFont(ofSize: 32, weight: .regular)  // Increased from 24 to 32
        instructionsLabel.numberOfLines = 0
        instructionsLabel.textAlignment = .center
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create buttons stack view for horizontal layout
        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 20
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create start button
        let startButton = UIButton()
        startButton.setTitle("בואו נתחיל!", for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.layer.cornerRadius = 15
        startButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startNumbersGameFromInstructions), for: .touchUpInside)
        
        // Create back button
        let backButton = UIButton()
        backButton.setTitle("חזרה", for: .normal)
        backButton.backgroundColor = .systemGray
        backButton.layer.cornerRadius = 15
        backButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(dismissNumbersInstructions), for: .touchUpInside)
        
        // Add blur effect to background
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add views to hierarchy
        view.addSubview(blurView)
        view.addSubview(popupView)
        popupView.addSubview(instructionsLabel)
        buttonsStackView.addArrangedSubview(backButton)
        buttonsStackView.addArrangedSubview(startButton)
        popupView.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            // Blur view constraints
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Popup view constraints
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            // Instructions label constraints
            instructionsLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 40),
            instructionsLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 30),
            instructionsLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -30),
            
            // Buttons stack view constraints
            buttonsStackView.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 40),
            buttonsStackView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 30),
            buttonsStackView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -30),
            buttonsStackView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -40),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Animate popup appearance
        popupView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        blurView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            popupView.transform = .identity
            blurView.alpha = 1
        }
    }
    
    @objc private func startNumbersGameFromInstructions() {
        // Remove popup
        view.subviews.forEach { view in
            if view is UIVisualEffectView || view.layer.cornerRadius == 20 {
                UIView.animate(withDuration: 0.2, animations: {
                    view.alpha = 0
                }) { _ in
                    view.removeFromSuperview()
                }
            }
        }
        
        // Start the numbers game
        let gameVC = NumbersGameViewController()
        gameVC.modalPresentationStyle = .fullScreen
        present(gameVC, animated: true)
    }
    
    // Add this method to handle back button tap
    @objc private func dismissNumbersInstructions() {
        view.subviews.forEach { view in
            if view is UIVisualEffectView || view.layer.cornerRadius == 20 {
                UIView.animate(withDuration: 0.2, animations: {
                    view.alpha = 0
                }) { _ in
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    private func showTransportationInstructions() {
        // Create the popup view
        let popupView = UIView()
        popupView.backgroundColor = .black
        popupView.layer.cornerRadius = 20
        popupView.layer.borderWidth = 2
        popupView.layer.borderColor = UIColor.white.cgColor
        popupView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create instructions label with bigger text
        let instructionsLabel = UILabel()
        instructionsLabel.text = "במשחק זה נצפה בתמונות של כלי תחבורה וננסה לבחור את האות שמתחילה את שמם, אם טעית לא נורא, נסה שוב, בסיום 10 סיבובים יוצג לוח התוצאות. בהצלחה!"
        instructionsLabel.textColor = .white
        instructionsLabel.font = .systemFont(ofSize: 32, weight: .regular)  // Increased from 24 to 32
        instructionsLabel.numberOfLines = 0
        instructionsLabel.textAlignment = .center
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create buttons stack view for horizontal layout
        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 20
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create start button
        let startButton = UIButton()
        startButton.setTitle("בואו נתחיל!", for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.layer.cornerRadius = 15
        startButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startTransportationGameFromInstructions), for: .touchUpInside)
        
        // Create back button
        let backButton = UIButton()
        backButton.setTitle("חזרה", for: .normal)
        backButton.backgroundColor = .systemGray
        backButton.layer.cornerRadius = 15
        backButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(dismissTransportationInstructions), for: .touchUpInside)
        
        // Add blur effect to background
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add views to hierarchy
        view.addSubview(blurView)
        view.addSubview(popupView)
        popupView.addSubview(instructionsLabel)
        buttonsStackView.addArrangedSubview(backButton)
        buttonsStackView.addArrangedSubview(startButton)
        popupView.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            // Blur view constraints
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Popup view constraints
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            // Instructions label constraints
            instructionsLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 40),
            instructionsLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 30),
            instructionsLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -30),
            
            // Buttons stack view constraints
            buttonsStackView.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 40),
            buttonsStackView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 30),
            buttonsStackView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -30),
            buttonsStackView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -40),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Animate popup appearance
        popupView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        blurView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            popupView.transform = .identity
            blurView.alpha = 1
        }
    }
    
    @objc private func startTransportationGameFromInstructions() {
        // Remove popup
        view.subviews.forEach { view in
            if view is UIVisualEffectView || view.layer.cornerRadius == 20 {
                UIView.animate(withDuration: 0.2, animations: {
                    view.alpha = 0
                }) { _ in
                    view.removeFromSuperview()
                }
            }
        }
        
        // Start the transportation game
        let gameVC = TransportationGameViewController()
        gameVC.modalPresentationStyle = .fullScreen
        present(gameVC, animated: true)
    }
    
    // Add this method to handle back button tap
    @objc private func dismissTransportationInstructions() {
        view.subviews.forEach { view in
            if view is UIVisualEffectView || view.layer.cornerRadius == 20 {
                UIView.animate(withDuration: 0.2, animations: {
                    view.alpha = 0
                }) { _ in
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    private func showNumbersStage2Instructions() {
        // Create the popup view
        let popupView = UIView()
        popupView.backgroundColor = .black
        popupView.layer.cornerRadius = 20
        popupView.layer.borderWidth = 2
        popupView.layer.borderColor = UIColor.white.cgColor
        popupView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create instructions label
        let instructionsLabel = UILabel()
        instructionsLabel.text = "במשחק זה נתרגל חיבור וחיסור של מספרים עד 20, אם טעית לא נורא, נסה שוב, בסיום 10 סיבובים יוצג לוח התוצאות. בהצלחה!"
        instructionsLabel.textColor = .white
        instructionsLabel.font = .systemFont(ofSize: 32, weight: .regular)
        instructionsLabel.numberOfLines = 0
        instructionsLabel.textAlignment = .center
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create buttons stack view for horizontal layout
        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 20
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create start button
        let startButton = UIButton()
        startButton.setTitle("בואו נתחיל!", for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.layer.cornerRadius = 15
        startButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startNumbersStage2GameFromInstructions), for: .touchUpInside)
        
        // Create back button
        let backButton = UIButton()
        backButton.setTitle("חזרה", for: .normal)
        backButton.backgroundColor = .systemGray
        backButton.layer.cornerRadius = 15
        backButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(dismissNumbersStage2Instructions), for: .touchUpInside)
        
        // Add blur effect to background
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add views to hierarchy
        view.addSubview(blurView)
        view.addSubview(popupView)
        popupView.addSubview(instructionsLabel)
        buttonsStackView.addArrangedSubview(backButton)
        buttonsStackView.addArrangedSubview(startButton)
        popupView.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            // Blur view constraints
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Popup view constraints
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            // Instructions label constraints
            instructionsLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 40),
            instructionsLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 30),
            instructionsLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -30),
            
            // Buttons stack view constraints
            buttonsStackView.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 40),
            buttonsStackView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 30),
            buttonsStackView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -30),
            buttonsStackView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -40),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Animate popup appearance
        popupView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        blurView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            popupView.transform = .identity
            blurView.alpha = 1
        }
    }
    
    @objc private func startNumbersStage2GameFromInstructions() {
        // Remove popup
        view.subviews.forEach { view in
            if view is UIVisualEffectView || view.layer.cornerRadius == 20 {
                UIView.animate(withDuration: 0.2, animations: {
                    view.alpha = 0
                }) { _ in
                    view.removeFromSuperview()
                }
            }
        }
        
        // Start the numbers stage 2 game
        let gameVC = NumbersStage2ViewController()
        gameVC.modalPresentationStyle = .fullScreen
        present(gameVC, animated: true)
    }
    
    // Add this method to handle back button tap
    @objc private func dismissNumbersStage2Instructions() {
        view.subviews.forEach { view in
            if view is UIVisualEffectView || view.layer.cornerRadius == 20 {
                UIView.animate(withDuration: 0.2, animations: {
                    view.alpha = 0
                }) { _ in
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    private func showLettersPracticeInstructions() {
        // Create the popup view
        let popupView = UIView()
        popupView.backgroundColor = .black
        popupView.layer.cornerRadius = 20
        popupView.layer.borderWidth = 2
        popupView.layer.borderColor = UIColor.white.cgColor
        popupView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create instructions label
        let instructionsLabel = UILabel()
        instructionsLabel.text = "במשחק זה נלמד לכתוב את האותיות בעברית, נתרגל כתיבה נכונה של כל אות. אחרי שנצליח לכתוב את האות נוכל להמשיך לאות הבאה. בהצלחה!"
        instructionsLabel.textColor = .white
        instructionsLabel.font = .systemFont(ofSize: 32, weight: .regular)
        instructionsLabel.numberOfLines = 0
        instructionsLabel.textAlignment = .center
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create buttons stack view for horizontal layout
        let buttonsStackView = UIStackView()
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 20
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create start button
        let startButton = UIButton()
        startButton.setTitle("בואו נתחיל!", for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.layer.cornerRadius = 15
        startButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startLettersPracticeFromInstructions), for: .touchUpInside)
        
        // Create back button
        let backButton = UIButton()
        backButton.setTitle("חזרה", for: .normal)
        backButton.backgroundColor = .systemGray
        backButton.layer.cornerRadius = 15
        backButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(dismissLettersPracticeInstructions), for: .touchUpInside)
        
        // Add blur effect to background
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add views to hierarchy
        view.addSubview(blurView)
        view.addSubview(popupView)
        popupView.addSubview(instructionsLabel)
        buttonsStackView.addArrangedSubview(backButton)
        buttonsStackView.addArrangedSubview(startButton)
        popupView.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            // Blur view constraints
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Popup view constraints
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popupView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            // Instructions label constraints
            instructionsLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 40),
            instructionsLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 30),
            instructionsLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -30),
            
            // Buttons stack view constraints
            buttonsStackView.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 40),
            buttonsStackView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 30),
            buttonsStackView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -30),
            buttonsStackView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -40),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Animate popup appearance
        popupView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        blurView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            popupView.transform = .identity
            blurView.alpha = 1
        }
    }
    
    @objc private func startLettersPracticeFromInstructions() {
        // Remove popup
        view.subviews.forEach { view in
            if view is UIVisualEffectView || view.layer.cornerRadius == 20 {
                UIView.animate(withDuration: 0.2, animations: {
                    view.alpha = 0
                }) { _ in
                    view.removeFromSuperview()
                }
            }
        }
        
        // Start the letters practice game
        let gameVC = LettersPracticeViewController()
        gameVC.modalPresentationStyle = .fullScreen
        present(gameVC, animated: true)
    }
    
    @objc private func dismissLettersPracticeInstructions() {
        view.subviews.forEach { view in
            if view is UIVisualEffectView || view.layer.cornerRadius == 20 {
                UIView.animate(withDuration: 0.2, animations: {
                    view.alpha = 0
                }) { _ in
                    view.removeFromSuperview()
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
