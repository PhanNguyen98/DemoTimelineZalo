//
//  TextInputView.swift
//  DemoTimelineZalo
//
//  Created by NguyenPhan on 23/8/25.
//

import UIKit

protocol TextInputViewDelegate: AnyObject {
    func textInputView(_ inputView: TextInputView, didChangeText text: String)
}

class TextInputView: UIView, UITextViewDelegate {
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        return textView
    }()

    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Bạn đang nghĩ gì?"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .colorACAFB2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var heightChanged: ((CGFloat) -> Void)?
    weak var delegate: TextInputViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) { super.init(coder: coder); setupUI() }

    private func setupUI() {
        textView.delegate = self
        addSubview(textView)
        textView.addSubview(placeholderLabel)

        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 8)
        ])
    }

    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        heightChanged?(size.height)
        placeholderLabel.isHidden = !textView.text.isEmpty
        delegate?.textInputView(self, didChangeText: textView.text)
    }
}
