//
// CarouselView.swift
// demo
//
// Created by Elvis on 2/01/23.
// Copyright (c) 2022. All rights reserved.
//


import UIKit
import SDWebImage

class MainView: UIViewController {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var textFilter: UITextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    private var viewModel:ProductViewModel = ProductViewModel()
    private var data: ProductList = []
    private var isPostBack:Bool = false
    private var currentPage = 0
     
    override func viewDidLoad() {
        super.viewDidLoad()
         
        self.setup()
        self.list()
    }
    
    private func list()  {
        
        self.loaderStatus(true)
        let text:String = self.textFilter.text ?? ""
        
        self.viewModel.list(value: text) { result in
            self.data = result ?? []
            
            DispatchQueue.main.async {
                self.collection.reloadData()
                self.loaderStatus(false)
            }
        }
    }
  
    @IBAction func onNext(_ sender: Any) {
        (sender as! UIButton).skipAnimation()
        goNext()
    }
}

extension MainView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collection.dequeueReusableCell(withReuseIdentifier: MovieViewCell.identifier, for: indexPath) as? MovieViewCell
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

extension MainView: UICollectionViewDelegate {
    
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

extension MainView: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension MainView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
            self.list()
    }
}

extension MainView {
    
    private func setup(){
        collection.showsHorizontalScrollIndicator = false
        collection.contentInsetAdjustmentBehavior = .always
        collection.collectionViewLayout = CollectionMovieLayout()
        collection.dataSource = self
        collection.delegate = self
        
        collection.register(UINib(nibName: MovieViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MovieViewCell.identifier)
         
        self.dismissKeyboard()
    }
    
    private func loaderStatus(_ value:Bool){
        if value{
            self.loader.isHidden = false
            self.loader.startAnimating()
        }else{
            self.loader.stopAnimating()
            self.loader.isHidden = true
        }
    }
    
    private func dismissKeyboard() {
        
        textFilter.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
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
}
