import UIKit
import ImageIO

class GIFImageView: UIView {
    private var imageView = UIImageView()
    private var gifImages: [UIImage] = []
    private var currentImageIndex = 0
    private var displayLink: CADisplayLink?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImageView()
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func loadGIF(name: String) {
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif"),
              let imageSource = CGImageSourceCreateWithURL(bundleURL as CFURL, nil) else {
            return
        }
        
        let frameCount = CGImageSourceGetCount(imageSource)
        gifImages.removeAll()
        
        for i in 0..<frameCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) {
                let image = UIImage(cgImage: cgImage)
                gifImages.append(image)
            }
        }
        
        if !gifImages.isEmpty {
            imageView.image = gifImages[0]
            startAnimating()
        }
    }
    
    private func startAnimating() {
        stopAnimating()
        displayLink = CADisplayLink(target: self, selector: #selector(updateFrame))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func updateFrame() {
        guard !gifImages.isEmpty else { return }
        currentImageIndex = (currentImageIndex + 1) % gifImages.count
        imageView.image = gifImages[currentImageIndex]
    }
    
    func stopAnimating() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    deinit {
        stopAnimating()
    }
} 