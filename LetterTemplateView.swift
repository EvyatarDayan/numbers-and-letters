import UIKit

class LetterTemplateView: UIView {
    private let backgroundLayer = CAShapeLayer()
    private let arrowsLayer = CAShapeLayer()
    private let dotsLayer = CAShapeLayer()
    private let startPointLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(dotsLayer)
        layer.addSublayer(arrowsLayer)
        layer.addSublayer(startPointLayer)
        
        // Set up background layer style
        backgroundLayer.fillColor = UIColor.systemPink.withAlphaComponent(0.2).cgColor
        backgroundLayer.strokeColor = nil
        
        // Set up dots layer style
        dotsLayer.fillColor = UIColor.white.cgColor
        dotsLayer.strokeColor = nil
        
        // Set up arrows layer style
        arrowsLayer.strokeColor = UIColor.red.cgColor
        arrowsLayer.fillColor = UIColor.red.cgColor
        arrowsLayer.lineWidth = 2
        
        // Set up start point style
        startPointLayer.fillColor = UIColor.systemBlue.cgColor
        startPointLayer.strokeColor = nil
    }
    
    func setLetter(_ letter: String) {
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLetterPath()
    }
    
    private func updateLetterPath() {
        let width = bounds.width
        let height = bounds.height
        
        // Example for letter א (Alef)
        let backgroundPath = UIBezierPath()
        let arrowsPath = UIBezierPath()
        let dotsPath = UIBezierPath()
        
        // Main diagonal stroke
        let startPoint = CGPoint(x: width * 0.3, y: height * 0.2)
        let endPoint = CGPoint(x: width * 0.7, y: height * 0.8)
        
        // Background path (wider stroke)
        let backgroundStroke = UIBezierPath()
        backgroundStroke.move(to: startPoint)
        backgroundStroke.addLine(to: endPoint)
        backgroundStroke.lineWidth = 40
        backgroundLayer.path = backgroundStroke.cgPath
        
        // Add dots along the path
        let numberOfDots = 4
        for i in 0...numberOfDots {
            let progress = CGFloat(i) / CGFloat(numberOfDots)
            let x = startPoint.x + (endPoint.x - startPoint.x) * progress
            let y = startPoint.y + (endPoint.y - startPoint.y) * progress
            let dotPath = UIBezierPath(arcCenter: CGPoint(x: x, y: y),
                                     radius: 3,
                                     startAngle: 0,
                                     endAngle: .pi * 2,
                                     clockwise: true)
            dotsPath.append(dotPath)
        }
        dotsLayer.path = dotsPath.cgPath
        
        // Add arrow
        addArrow(to: arrowsPath, from: startPoint, to: endPoint, arrowSize: 15)
        arrowsLayer.path = arrowsPath.cgPath
        
        // Add start point (blue dot)
        let startDot = UIBezierPath(arcCenter: startPoint,
                                  radius: 8,
                                  startAngle: 0,
                                  endAngle: .pi * 2,
                                  clockwise: true)
        startPointLayer.path = startDot.cgPath
    }
    
    private func addArrow(to path: UIBezierPath, from start: CGPoint, to end: CGPoint, arrowSize: CGFloat) {
        // Draw line
        path.move(to: start)
        path.addLine(to: end)
        
        // Calculate arrow head
        let angle = atan2(end.y - start.y, end.x - start.x)
        let arrowAngle: CGFloat = .pi / 6
        
        let arrowPoint1 = CGPoint(
            x: end.x - arrowSize * cos(angle - arrowAngle),
            y: end.y - arrowSize * sin(angle - arrowAngle)
        )
        let arrowPoint2 = CGPoint(
            x: end.x - arrowSize * cos(angle + arrowAngle),
            y: end.y - arrowSize * sin(angle + arrowAngle)
        )
        
        // Draw arrow head
        path.move(to: end)
        path.addLine(to: arrowPoint1)
        path.move(to: end)
        path.addLine(to: arrowPoint2)
    }
} 