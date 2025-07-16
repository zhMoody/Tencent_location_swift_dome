import UIKit

class BaseMapViewController: UIViewController {
    func initTitle(_ title: String?) {
        let titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .white
        titleLabel.text = title
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initTitle(self.title)
    }
}
