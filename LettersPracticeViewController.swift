import UIKit

class LettersPracticeViewController: UIViewController {
    private let drawingView: DrawingView = {
        let view = DrawingView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let letterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 120, weight: .bold)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("הבא", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton()
        button.setTitle("הקודם", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("נקה", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var currentLetterIndex = 0
    private let hebrewLetters = ["א", "ב", "ג", "ד", "ה", "ו", "ז", "ח", "ט", "י",
                                "כ", "ל", "מ", "נ", "ס", "ע", "פ", "צ", "ק", "ר", "ש", "ת"]
    private var completedLetters: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNotifications()
        updateLetter()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(letterLabel)
        view.addSubview(drawingView)
        view.addSubview(nextButton)
        view.addSubview(previousButton)
        view.addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            letterLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            letterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            letterLabel.heightAnchor.constraint(equalToConstant: 150),
            
            drawingView.topAnchor.constraint(equalTo: letterLabel.bottomAnchor, constant: 20),
            drawingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            drawingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            drawingView.heightAnchor.constraint(equalTo: drawingView.widthAnchor),
            
            clearButton.topAnchor.constraint(equalTo: drawingView.bottomAnchor, constant: 20),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 100),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            
            previousButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            previousButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            previousButton.widthAnchor.constraint(equalToConstant: 100),
            previousButton.heightAnchor.constraint(equalToConstant: 44),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.widthAnchor.constraint(equalToConstant: 100),
            nextButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        
        previousButton.isEnabled = currentLetterIndex > 0
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(handleLetterCompleted),
                                             name: .letterCompleted,
                                             object: nil)
    }
    
    @objc private func handleLetterCompleted() {
        completedLetters.insert(currentLetterIndex)
        
        nextButton.isEnabled = currentLetterIndex < hebrewLetters.count - 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            if self.currentLetterIndex < self.hebrewLetters.count - 1 {
                self.nextButtonTapped()
            }
        }
    }
    
    private func updateLetter() {
        letterLabel.text = hebrewLetters[currentLetterIndex]
        drawingView.setLetter(hebrewLetters[currentLetterIndex])
        
        previousButton.isEnabled = currentLetterIndex > 0
        nextButton.isEnabled = completedLetters.contains(currentLetterIndex) && 
                             currentLetterIndex < hebrewLetters.count - 1
    }
    
    @objc private func nextButtonTapped() {
        guard currentLetterIndex < hebrewLetters.count - 1 else { return }
        currentLetterIndex += 1
        updateLetter()
        drawingView.clear()
    }
    
    @objc private func previousButtonTapped() {
        guard currentLetterIndex > 0 else { return }
        currentLetterIndex -= 1
        updateLetter()
        drawingView.clear()
    }
    
    @objc private func clearButtonTapped() {
        drawingView.clear()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
} 