import UIKit

public class ImageCollectionViewCell: UICollectionViewCell {
    var image: UIImage? {
        willSet {
            let imageView = UIImageView(frame: contentView.bounds)
            
            imageView.image = newValue
            imageView.contentMode = .scaleAspectFill
            contentView.subviews.forEach { $0.removeFromSuperview() }
            contentView.addSubview(imageView)
            imageView.layer.cornerRadius = 10
            imageView.layer.masksToBounds = true
            imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
}

public class HorizontalCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    fileprivate let bottomSpaceBetweenCells: CGFloat = 10
    fileprivate let leftPadding: CGFloat = 10
    fileprivate let middleSpaceBetweenCells: CGFloat = 3
    fileprivate let rightPadding: CGFloat = 10
    fileprivate let topPadding: CGFloat = 10
    let reuseIdentifier = String(describing: ImageCollectionViewCell.self)
    var collectionView: UICollectionView!
    
    public override func viewDidLoad() {
        let viewFlowLayout = UICollectionViewFlowLayout()
        
        view.backgroundColor = UIColor.white
        viewFlowLayout.minimumInteritemSpacing = middleSpaceBetweenCells
        viewFlowLayout.minimumLineSpacing = bottomSpaceBetweenCells
        viewFlowLayout.sectionInset = UIEdgeInsets(top: topPadding, left: leftPadding, bottom: 0, right: rightPadding)
        viewFlowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: view.bounds,
                                              collectionViewLayout: viewFlowLayout)
        
        self.collectionView = collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        let imageName = String(describing: indexPath.row) + ".jpeg"
        
        cell.image = UIImage(named: imageName)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let blankSpaces = leftPadding + middleSpaceBetweenCells
        let width = bounds.width - blankSpaces
        let heigth = bounds.height - blankSpaces
        
        print(CGSize(width: width, height: heigth))
        return CGSize(width: width, height: heigth)
    }
}
