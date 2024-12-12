import UIKit

class DrawingView: UIView {
    private var path = UIBezierPath()
    private var lines: [UIBezierPath] = []
    private let drawingLayer = CAShapeLayer()
    private let templateImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 10
        
        // Setup drawing layer
        drawingLayer.fillColor = nil
        drawingLayer.strokeColor = UIColor.blue.cgColor
        drawingLayer.lineWidth = 15
        drawingLayer.lineCap = .round
        drawingLayer.lineJoin = .round
        layer.addSublayer(drawingLayer)
        
        // Setup template image view - add last to be on top
        templateImageView.contentMode = .scaleAspectFit
        templateImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(templateImageView)
        
        NSLayoutConstraint.activate([
            templateImageView.topAnchor.constraint(equalTo: topAnchor),
            templateImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            templateImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            templateImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setLetter(_ letter: String) {
        templateImageView.image = UIImage(named: "letter_template_\(letter)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        path = UIBezierPath()
        path.lineWidth = 15
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.move(to: touch.location(in: self))
        updateDrawingLayer()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        path.addLine(to: touch.location(in: self))
        updateDrawingLayer()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(path)
        updateDrawingLayer()
        checkDrawing()
    }
    
    private func updateDrawingLayer() {
        let combinedPath = UIBezierPath()
        lines.forEach { combinedPath.append($0) }
        combinedPath.append(path)
        drawingLayer.path = combinedPath.cgPath
    }
    
    func clear() {
        lines.removeAll()
        path = UIBezierPath()
        drawingLayer.path = nil
    }
    
    private func checkDrawing() {
        // Here we'll implement drawing recognition logic
        // For now, we'll just simulate success after drawing
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            NotificationCenter.default.post(name: .letterCompleted, object: nil)
        }
    }
}

extension Notification.Name {
    static let letterCompleted = Notification.Name("letterCompleted")
} 