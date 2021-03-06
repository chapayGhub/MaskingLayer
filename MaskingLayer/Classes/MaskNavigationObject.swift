//
//  MaskNavigationObject.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2018/09/01.
//

import Foundation
import MobileCoreServices

public protocol CViewProtocol {
    func maskPath(position: CGPoint, imageView: UIImageView)
    func maskAddLine(position: CGPoint, imageView: UIImageView)
    func tapped(view: UIView)
    func maskGif()
    func setURL()
}

public class MaskNavigationObject: NSObject, CViewProtocol {

    open var index = Int()
    open var image = UIImage()
    var vc = UIViewController()
    open var margin: CGFloat = 10
    open var imageView = UIImageView()
    open var imageBackView = UIImageView()
    open var maskLayer = MaskLayer()
    open var gifObject = MaskGifObject()
    open var vm = MaskCollectionViewModel()
    open lazy var cView: MaskCollectionView = {
        let cView = MaskCollectionView()
        cView.collectionView.delegate = self
        cView.collectionView.dataSource = self.vm
        cView.backgroundColor = .clear
        return cView
    }()

    public func imageResize(images: UIImage){
        image = images.ResizeUIImage(width: Margin.current.width, height: Margin.current.height)
        imageView.image = image
        imageView.frame = CGRect(x: Margin.current.xOrigin, y: Margin.current.yOrigin, width: Margin.current.width, height: Margin.current.height)
        imageBackView.frame = imageView.frame
    }

    public func resetCView() {
        vm.setVideoURLView.thumbnailViews.removeAll()
        vm.setVideoURLView.dataArray.removeAll()
        vm.checkLabel = UILabel()
        vm.checkArray.removeAllObjects()
        vm.rotate = 0
        cView.removeFromSuperview()
        cView = {
            let cView = MaskCollectionView()
            cView.collectionView.delegate = self
            cView.collectionView.dataSource = self.vm
            cView.backgroundColor = .clear
            return cView
        }()
    }

    public func maskPortraitMatte( ) {
        if #available(iOS 12.0, *) {
            let maskPortraitMatte = MaskPortraitMatte()
            maskPortraitMatte.portraitMatte(imageV: imageView, vc: vc)
        }
    }

    public func maskPath(position: CGPoint, imageView: UIImageView) {
        maskLayer.clipLayer.isHidden = false
        imageView.image = imageView.image!.ResizeUIImage(width: Margin.current.width, height: Margin.current.height)
        maskLayer.path.move(to: CGPoint(x: position.x, y: position.y))
        maskLayer.maskConvertPointFromView(viewPoint: position, bool:true)
    }

    public func maskAddLine(position: CGPoint,imageView: UIImageView) {
        maskLayer.path.addLine(to: CGPoint(x: position.x, y: position.y))
        maskLayer.maskConvertPointFromView(viewPoint: position, bool:false)
    }

    public func tapped(view: UIView) {
        guard let size = imageView.image?.size else { return }

        imageView.image = maskLayer.maskImage(color: maskLayer.maskColor, size: size, convertPath: maskLayer.convertPath)
        maskLayer.imageSet(view: view,imageView: imageView, image: image)

        guard vm.setVideoURLView.dataArray.count == 0 else {
            vm.setVideoURLView.imageAr[0] = (imageView.image?.cgImage?.resize(imageView.image!.cgImage!))!
            vm.setVideoURLView.imageAr[index] = (imageView.image?.cgImage?.resize(imageView.image!.cgImage!))!

            if !vm.checkArray.contains(index) {
                vm.checkArray.add(index)
                cView.collectionView.reloadData()
            }
            return
        }
    }

    public func setURL() {
        vm.setVideoURLView.setURL()
        vm.setVideoURLView.frame = CGRect(x:0,y:0,width: vc.view.frame.width, height: vc.view.frame.width/15)
    }

    public func maskGif() {
        let defo = UserDefaults.standard
        guard let url  = defo.url(forKey: "url") else { return }
        gifObject.makeGifImageMovie(url: url,frameY: 1, createBool: true, scale: UIScreen.main.scale, imageAr: (vm.setVideoURLView.imageAr))
    }
    
    public func gousei(){
        let top :UIImage = imageView.image!
        let bottom :UIImage = imageBackView.image!
        let nSize = CGSize(width:bottom.size.width, height:bottom.size.height)
        UIGraphicsBeginImageContextWithOptions(nSize, false, bottom.scale)
        bottom.draw(in: CGRect(x:0,y:0,width:nSize.width,height:nSize.height))
        top.draw(in: CGRect(x:0,y:0,width:nSize.width,height:nSize.height),blendMode:CGBlendMode.normal, alpha:1.0)
        let nImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        imageView.image = nImage
        imageView.setNeedsLayout()
    }
}

// MARK: UICollectionViewDelegate
extension MaskNavigationObject: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let defo = UserDefaults.standard
        let url = defo.url(forKey: "url")

        if indexPath.section == 0 {
            do {
                vm.rotate = 90
                maskGif()

                let data = try Data(contentsOf: url!)
                self.imageView.animateGIF(data: data, duration: Double(4)) { }

            } catch { print("error") }

        } else {
            vm.rotate = 0
            image = UIImage(data: vm.setVideoURLView.dataArray[indexPath.section-vm.editCount])!
            imageView.image = image

            maskLayer.mutablePathSet()

            index = indexPath.section-vm.editCount
            if vm.checkArray.contains(index) { vm.checkArray.remove(index) }
        }
        collectionView.reloadData()
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MaskNavigationObject: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
}
