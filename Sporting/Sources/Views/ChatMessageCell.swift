import UIKit
import AVFoundation

class ChatMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Sample Text for now"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.10, green:0.60, blue:0.91, alpha:1.0)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "person")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let sender : UILabel = {
        let sd = UILabel()
        sd.translatesAutoresizingMaskIntoConstraints = false
        return sd
    }()
    
    var bubbleviewWidthAnchor: NSLayoutConstraint?
    var bubbleviewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAncor: NSLayoutConstraint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        addSubview(sender)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true

        bubbleviewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant:-3)
        bubbleviewRightAnchor?.isActive = true
        bubbleviewWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleviewWidthAnchor?.isActive = true
        bubbleViewLeftAncor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant:8)
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor , constant:8).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        sender.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        sender.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
        sender.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

