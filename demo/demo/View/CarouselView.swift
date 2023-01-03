//
// CarouselView.swift
// demo
//
// Created by Elvis on 2/01/23.
// Copyright (c) 2022. All rights reserved.
//


import UIKit
import SDWebImage

class CarouselView: UIViewController {
    
    private var viewModel:ProductViewModel = ProductViewModel()
    
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var textFilter: UITextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    private var data: ProductList = []
    private var isPostBack:Bool = false
    
    let movieLayout = CollectionMovieLayout()
    
    private var currentPage = 0
     
    override func viewDidLoad() {
        super.viewDidLoad()
         
        collection.showsHorizontalScrollIndicator = false
        collection.contentInsetAdjustmentBehavior = .always
        collection.collectionViewLayout = movieLayout
        collection.dataSource = self
        collection.delegate = self
        
        collection.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieViewCell1")
                 
        self.list()
        self.dismissKeyboard()
    }
    
    private func list()  {
        self.loader.isHidden = false
        self.loader.startAnimating()
        
        let text:String = self.textFilter.text ?? ""
        
        self.viewModel.list(value: text) { result in
            self.data = result ?? []
            
            DispatchQueue.main.async {
                self.collection.reloadData()
                self.loader.stopAnimating()
                self.loader.isHidden = true
            }
        }
    }
  
    @IBAction func onNext(_ sender: Any) {
        (sender as! UIButton).skipAnimation()
        goNext()
    }
    
    
    private func goNext(){
      
        let vc = DetailView.instantiate(StoryboardIdentifiers.Detail)
        vc.item = data[currentPage]
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.present(vc, animated: true)
        }
    }
    
//    func curvedShapeFor(view: UIImageView, curvedPercent:CGFloat) ->UIBezierPath
//    {
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x:0, y:0))
//        path.addLine(to: CGPoint(x:view.bounds.size.width, y:0))
//        path.addLine(to: CGPoint(x:view.bounds.size.width, y:view.bounds.size.height - (view.bounds.size.height*curvedPercent)))
//        
//        path.addQuadCurve(to: CGPoint(x:0, y:view.bounds.size.height - (view.bounds.size.height*curvedPercent)), controlPoint: CGPoint(x:view.bounds.size.width/2, y:view.bounds.size.height))
//        
//        path.addLine(to: CGPoint(x:0, y:0))
//        path.close()
//        
//        return path
//    }
}

extension CarouselView: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension CarouselView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (self.data.count > 0){
            return 1
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collection.dequeueReusableCell(withReuseIdentifier: "MovieViewCell1", for: indexPath) as? MovieViewCell
        
        cell?.setValue(data[indexPath.row])
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (isPostBack){
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -100, 0)
            
            cell.alpha = 0
            cell.layer.transform = rotationTransform
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                cell.alpha = 1.0
                cell.layer.transform = CATransform3DIdentity
            }, completion: nil)
            
        }else{
            isPostBack = true
        }
    }
}

extension CarouselView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if let cell = collection.cellForItem(at: indexPath) as? MovieViewCell{
            cell.contentImage.flipAnimation()
        }
        
        currentPage = indexPath.row
        collection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        
        self.goNext()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currentPage = getCurrentPage()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.currentPage = getCurrentPage()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.currentPage = getCurrentPage()
    }
    
    func getCurrentPage() -> Int {
        
        let visibleRect = CGRect(origin: collection.contentOffset, size: collection.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = collection.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        
        return currentPage
    }
}

extension CarouselView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {

            self.list()
    }
}

extension CarouselView {
    func dismissKeyboard() {
        
        textFilter.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
