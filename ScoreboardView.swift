import UIKit

class ScoreboardView: UIView {
    private let correctLabel = UILabel()
    private let wrongLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .black
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        
        // Setup labels with colored text and emojis
        correctLabel.textColor = .systemGreen
        correctLabel.font = .systemFont(ofSize: 24, weight: .bold)
        correctLabel.textAlignment = .center
        
        wrongLabel.textColor = .systemRed
        wrongLabel.font = .systemFont(ofSize: 24, weight: .bold)
        wrongLabel.textAlignment = .center
        
        // Change to horizontal stack view
        let stackView = UIStackView(arrangedSubviews: [correctLabel, wrongLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            stackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func updateScores(correct: Int, wrong: Int) {
        correctLabel.text = "👍 \(correct)"
        wrongLabel.text = "👎 \(wrong)"
    }
} 