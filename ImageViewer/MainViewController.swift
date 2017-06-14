//
//  MainViewController.swift
//  MasterImage
//
//  Created by DAIXinming on 18/03/2017.
//  Copyright © 2017 Xinming DAI. All rights reserved.
//

import UIKit
import NYTPhotoViewer

class MainViewController: UIViewController, NYTPhotosViewControllerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var transitionContainerView: UIView!
    @IBOutlet weak var transitionImageView: UIImageView!
    
    let transitioningLayer = CATextLayer()
    var imageViewTransitionSwitch = false
    
    var samplePhotos: Array = [FocusableImage]()
    var focusableImageViews: Array = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        self.initSamplePhotos()
        self.setupScrollViewData()
    }
    
    
    // MARK: Internal Methods
    func setupScrollViewData() {
        self.scrollView.delegate = self
        let pageWidth: CGFloat = UIScreen.main.bounds.width
        let pageHeight: CGFloat = pageWidth * 9 / 16
        
        self.scrollView.contentSize = CGSize(width: pageWidth * CGFloat(self.samplePhotos.count), height: pageHeight)
        for (index, photo) in self.samplePhotos.enumerated() {
            let imagePage = UIImageView(frame: CGRect(x: pageWidth * CGFloat(index), y: 0, width: pageWidth, height: pageHeight))
            imagePage.image = photo.image
            imagePage.clipsToBounds = true
            imagePage.contentMode = .scaleAspectFill
            imagePage.isUserInteractionEnabled = true
            self.setupImageView(imagePage)
            
            self.focusableImageViews.append(imagePage)
            self.scrollView.addSubview(imagePage)
        }
    }
    
    func initSamplePhotos() {
        self.samplePhotos.append(FocusableImage(image: UIImage.init(named: "cat_dog_2"), imageData: nil, attributedCaptionTitle: NSAttributedString(string: "hello_1")))
        self.samplePhotos.append(FocusableImage(image: UIImage.init(named: "cat_dog_3"), imageData: nil, attributedCaptionTitle: NSAttributedString(string: "hello_1")))
        self.samplePhotos.append(FocusableImage(image: UIImage.init(named: "cat_dog_4"), imageData: nil, attributedCaptionTitle: NSAttributedString(string: "hello_1")))
        self.samplePhotos.append(FocusableImage(image: UIImage.init(named: "cat_dog_5"), imageData: nil, attributedCaptionTitle: NSAttributedString(string: "hello_1")))
        self.samplePhotos.append(FocusableImage(image: UIImage.init(named: "cat_dog_6"), imageData: nil, attributedCaptionTitle: NSAttributedString(string: "hello_1")))
    }
    
    func setupImageView(_ imageView: UIImageView) {
        let tapOnImageView = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        tapOnImageView.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapOnImageView)
    }
    
    
    // MARK: Actions
    func imageViewTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedImageView = sender.view as? UIImageView else { return }
        
        guard let tappedViewIndex = self.focusableImageViews.index(of: tappedImageView) else { return }
        
        let photosVC = NYTPhotosViewController(photos: self.samplePhotos, initialPhoto: self.samplePhotos[tappedViewIndex], delegate: self)
        self.present(photosVC, animated: true, completion: nil)
    }
    
    @IBAction func startTransitionBtnDidTap(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromTop
        transitionImageView.layer.add(transition, forKey: "keyToIdentifyTransition")
        if imageViewTransitionSwitch {
            imageViewTransitionSwitch = false
            transitionImageView.image = UIImage(named: "cat_dog_4")
        } else {
            imageViewTransitionSwitch = true
            transitionImageView.image = UIImage(named: "cat_dog_3")
        }
    }
}


extension MainViewController {
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // TODO
    }
    
    // MARK: NYTPhotosViewControllerDelegate
    func photosViewController(_ photosViewController: NYTPhotosViewController, referenceViewFor photo: NYTPhoto) -> UIView? {
        guard let focusableImage = photo as? FocusableImage, let imageIndex = self.samplePhotos.index(of: focusableImage) else { return nil }
        
        let imageView = self.focusableImageViews[imageIndex]
        
        return imageView
    }
    
    func photosViewController(_ photosViewController: NYTPhotosViewController, didNavigateTo photo: NYTPhoto, at photoIndex: UInt) {
        let pageWidth = UIScreen.main.bounds.width
        let pageHeight = pageWidth * 9 / 16
        let visibleRect = CGRect(x: pageWidth * CGFloat(photoIndex), y: 0, width: pageWidth, height: pageHeight)
        self.scrollView.scrollRectToVisible(visibleRect, animated: false)
    }
}


class FocusableImage: NSObject, NYTPhoto {
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
