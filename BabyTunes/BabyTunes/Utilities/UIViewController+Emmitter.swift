//
//  UIViewController+Emmitter.swift
//  BabyTunes
//
//  Created by Alan Aherne on 07.03.18.
//  Copyright © 2018 CCDimensions. All rights reserved.
//

extension UIViewController {
    
    func initEmitter(){
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = CGPoint(x: view.bounds.size.width * 0.5, y: -50.0)
        emitterLayer.emitterShape = kCAEmitterLayerLine
        emitterLayer.emitterSize = CGSize(width: UIScreen.main.bounds.size.width, height: 1.0)
        
        let emitterCell = CAEmitterCell()
        
        emitterCell.scale = 0.5; // 7
        emitterCell.scaleRange = 0.5; // 8
        emitterCell.emissionRange = CGFloat(Double.pi); // 9
        emitterCell.lifetime = 10.0; // 10
        emitterCell.birthRate = 2; // 11
        emitterCell.velocity = 0; // 12
        emitterCell.velocityRange = 0; // 13
        emitterCell.yAcceleration = 30; // 14
        emitterCell.spin = 0
        emitterCell.spinRange = 2.0
        let img = UIImage(named: "Note")
        emitterCell.contents = img?.cgImage as AnyObject
        
        let emitterCellBlur = CAEmitterCell()
        emitterCellBlur.scale = 1.5; // 7
        emitterCellBlur.scaleRange = 0.5; // 8
        emitterCellBlur.emissionRange = CGFloat(Double.pi); // 9
        emitterCellBlur.lifetime = 15.0; // 10
        emitterCellBlur.birthRate = 1; // 11
        emitterCellBlur.velocity = 0; // 12
        emitterCellBlur.velocityRange = 0; // 13
        emitterCellBlur.yAcceleration = 20; // 14
        emitterCellBlur.spin = 0
        emitterCellBlur.spinRange = 2.0
        emitterCellBlur.contents = UIImage(named: "NoteBlur")!.cgImage as AnyObject
        emitterCellBlur.alphaRange = 0.7
        emitterLayer.emitterCells = [emitterCell,emitterCellBlur]
        view.layer.insertSublayer(emitterLayer, at: 0)
    }
}
