//
//  BasePostContentView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 22/8/25.
//

import UIKit

class BasePostContentView: UIView {
    
    var didTapContentLabel: () -> Void = {}
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.font = .systemFont(ofSize: 15)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    func setupUI() {
        addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleContentLabelTap))
        contentLabel.addGestureRecognizer(tap)
    }

    @objc private func handleContentLabelTap() {
        didTapContentLabel()
    }
    
    // MARK: - Configure
    func configureContent(text: String?) {
        guard let text = text, !text.isEmpty else {
            contentLabel.text = nil
            contentLabel.isHidden = true
            return
        }
        contentLabel.isHidden = false
        
        // Determine if text exceeds 4 lines
        let labelWidth = contentLabel.bounds.width > 0 ? contentLabel.bounds.width : UIScreen.main.bounds.width - 32
        let font = contentLabel.font ?? UIFont.systemFont(ofSize: 15)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        let constraintRect = CGSize(width: labelWidth, height: .greatestFiniteMagnitude)
        let boundingRect = attributedText.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        let lineHeight = font.lineHeight
        let numberOfLines = Int(ceil(boundingRect.height / lineHeight))
        
        if numberOfLines > 4 {
            // Truncate text to fit 4 lines and add "… Xem thêm"
            let truncatedText = self.truncatedText(for: text, font: font, width: labelWidth, maxLines: 4, trailing: " … Xem thêm")
            let mutableAttr = NSMutableAttributedString(string: truncatedText)
            if let range = truncatedText.range(of: " … Xem thêm") {
                let nsRange = NSRange(range, in: truncatedText)
                mutableAttr.addAttribute(.foregroundColor, value: UIColor.colorACAFB2, range: nsRange)
            }
            contentLabel.attributedText = mutableAttr
        } else {
            contentLabel.text = text
        }
    }
    
    // MARK: - Configure Full Content
    func configureFullContent(text: String?) {
        guard let text = text, !text.isEmpty else {
            contentLabel.text = nil
            contentLabel.isHidden = true
            return
        }
        contentLabel.isHidden = false
        contentLabel.text = text
        contentLabel.numberOfLines = 0
    }

    private func truncatedText(for text: String, font: UIFont, width: CGFloat, maxLines: Int, trailing: String) -> String {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        var low = 0
        var high = text.count
        var best = text
        while low <= high {
            let mid = (low + high) / 2
            let candidate = String(text.prefix(mid)) + trailing
            let attr = NSAttributedString(string: candidate, attributes: attributes)
            let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
            let boundingRect = attr.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
            let lineHeight = font.lineHeight
            let numberOfLines = Int(ceil(boundingRect.height / lineHeight))
            if numberOfLines > maxLines {
                high = mid - 1
            } else {
                best = candidate
                low = mid + 1
            }
        }
        return best
    }
}
