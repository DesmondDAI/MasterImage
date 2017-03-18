//
//  MainViewController.swift
//  MasterImage
//
//  Created by DAIXinming on 18/03/2017.
//  Copyright © 2017 Xinming DAI. All rights reserved.
//

import UIKit
import NYTPhotoViewer

class MainViewController: UIViewController, NYTPhotosViewControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var samplePhotos: Array = [FocusableImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.setupImageView()
        self.initSamplePhotos()
        self.setupScrollViewData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("scroll view content size in viewDidAppear: ", self.scrollView.contentSize)
        print("scroll view frame in view did appear: ", self.scrollView.frame)
    }
    
    
    // MARK: Internal Methods
    func setupImageView()
    {
        let tapOnImageView = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        tapOnImageView.numberOfTapsRequired = 1
        self.imageView.addGestureRecognizer(tapOnImageView)
    }
    
    func setupScrollViewData()
    {
        self.scrollView.backgroundColor = .black
        let pageWidth: CGFloat = UIScreen.main.bounds.width
        let pageHeight: CGFloat = pageWidth * 9 / 16
        print("scroll view frame in view did load: ", self.scrollView.frame)
        self.scrollView.contentSize = CGSize(width: pageWidth * CGFloat(self.samplePhotos.count), height: pageHeight)
        print("scrollView content size: ", self.scrollView.contentSize)
        for (index, photo) in self.samplePhotos.enumerated() {
            let imagePage = UIImageView(frame: CGRect(x: pageWidth * CGFloat(index), y: 0, width: pageWidth, height: pageHeight))
            print(index, " image frame: ", imagePage.frame)
            imagePage.image = photo.image
            imagePage.clipsToBounds = true
            imagePage.contentMode = .scaleAspectFill
            self.scrollView.addSubview(imagePage)
        }
    }
    
    func initSamplePhotos()
    {
        self.samplePhotos.append(FocusableImage(image: UIImage.init(named: "cat_dog_2"), imageData: nil, attributedCaptionTitle: NSAttributedString(string: "hello_1")))
        self.samplePhotos.append(FocusableImage(image: UIImage.init(named: "cat_dog_3"), imageData: nil, attributedCaptionTitle: NSAttributedString(string: "hello_1")))
        self.samplePhotos.append(FocusableImage(image: UIImage.init(named: "cat_dog_4"), imageData: nil, attributedCaptionTitle: NSAttributedString(string: "hello_1")))
        self.samplePhotos.append(FocusableImage(image: UIImage.init(named: "cat_dog_5"), imageData: nil, attributedCaptionTitle: NSAttributedString(string: "hello_1")))
        self.samplePhotos.append(FocusableImage(image: UIImage.init(named: "cat_dog_6"), imageData: nil, attributedCaptionTitle: NSAttributedString(string: "hello_1")))
    }
    
    
    // MARK: Actions
    func imageViewTapped(_ sender: UITapGestureRecognizer)
    {
        let photosVC = NYTPhotosViewController(photos: self.samplePhotos)
        photosVC.delegate = self
        self.present(photosVC, animated: true, completion: nil)
    }
}


extension MainViewController
{
    // MARK: NYTPhotosViewControllerDelegate
    func photosViewController(_ photosViewController: NYTPhotosViewController, referenceViewFor photo: NYTPhoto) -> UIView? {
        return self.imageView
    }
}


class FocusableImage: NSObject, NYTPhoto
{
    var image: UIImage?
    var imageData: Data?
    var placeholderImage: UIImage?
    let attributedCaptionTitle: NSAttributedString?
    let attributedCaptionSummary: NSAttributedString? = nil
    let attributedCaptionCredit: NSAttributedString? = nil
    
    init(image: UIImage? = nil, imageData: Data? = nil, attributedCaptionTitle: NSAttributedString) {
        self.image = image
        self.imageData = imageData
        self.attributedCaptionTitle = attributedCaptionTitle
        super.init()
    }
}
