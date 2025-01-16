import UIKit

class FontSizeSlider: UISlider {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSlider()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSlider()
    }
    
    private func setupSlider() {
        self.translatesAutoresizingMaskIntoConstraints = false
        minimumValue = 0
        maximumValue = 6
        
        let trackImage = UIImage(systemName: "circle.fill")?.withTintColor(.systemGray, renderingMode: .alwaysTemplate)
        setMinimumTrackImage(trackImage, for: .normal)
        setMaximumTrackImage(trackImage, for: .normal)
        
        let thumbImage = UIImage(named: "circle.fill")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        setThumbImage(thumbImage, for: .normal)
        
        addTarget(self, action: #selector(snapToValue), for: .valueChanged)
    }
    
    @objc private func snapToValue() {
        let roundedValue = round(value)
        setValue(roundedValue, animated: true)
    }
}
