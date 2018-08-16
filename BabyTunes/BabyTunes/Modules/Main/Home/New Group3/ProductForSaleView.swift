//
//  ProductForSaleView.swift
//  BabyTunes
//
//  Created by Alan Aherne on 18.04.18.
//  Copyright © 2018 CCDimensions. All rights reserved.
//

import UIKit
import StoreKit

class ProductForSaleView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stateCheckMark: UIImageView!
    
    // MARK: - Properties
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var buyButtonHandler: ((_ product: SKProduct) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("ProductForSaleView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    var product: SKProduct? {
        
        didSet {
            guard let product = product else { return }
            
            // Set button handler
            if buyButton.allTargets.count == 0 {
                buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
            }
            
            productNameLabel.text = product.localizedDescription
            
            if BabyTunesProducts.store.isPurchased(product.productIdentifier) {
                buyButton.isHidden = true
                stateCheckMark.isHidden = false
            }
            else if BabyTunesProducts.productIDsNonRenewing.contains(product.productIdentifier) {
                buyButton.isHidden = false
                stateCheckMark.isHidden = true
                
                if BabyTunesProducts.daysRemainingOnSubscription(identifier: ProductsIdentifier(rawValue: product.productIdentifier)!) > 0 {
                    buyButton.setTitle("Renew", for: .normal)
                    buyButton.setImage(UIImage(named: "IconRenew"), for: .normal)
                } else {
                    buyButton.setTitle("Buy", for: .normal)
                    buyButton.setImage(UIImage(named: "IconBuy"), for: .normal)
                }
                
                ProductForSaleView.priceFormatter.locale = product.priceLocale
                priceLabel.text = ProductForSaleView.priceFormatter.string(from: product.price)
            }
            else if IAPHelper.canMakePayments() {
                ProductForSaleView.priceFormatter.locale = product.priceLocale
                priceLabel.text = ProductForSaleView.priceFormatter.string(from: product.price)
                
                buyButton.isHidden = false
                stateCheckMark.isHidden = true
                buyButton.setTitle("Buy", for: .normal)
                buyButton.setImage(UIImage(named: "IconBuy"), for: .normal)
            } else {
                priceLabel.text = "Not available"
                buyButton.isHidden = true
                stateCheckMark.isHidden = true
            }
        }
    }
    
    @objc func buyButtonTapped(_ sender: AnyObject) {
        buyButtonHandler?(product!)
    }
}
