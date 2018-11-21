import UIKit

class RoomCell:UITableViewCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(origin: CGPoint(x:17,y:textLabel!.frame.origin.y - 2),
                                  size: CGSize(width: textLabel!.frame.width, height: textLabel!.frame.height))
        
        detailTextLabel?.frame = CGRect(origin: CGPoint(x:17,y:textLabel!.frame.origin.y + 30 ),
                                size: CGSize(width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height))
    }
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
//        addSubview(profileImageView)
//        addSubview(timeLabel)
//
//        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant:8).isActive = true
//        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
//
//        //need x,y,width,height anchors
//        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
//        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
