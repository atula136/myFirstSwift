/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class ChocolateCell: UITableViewCell {
    
    static let Identifier = "ChocolateCell"
    
    var countryNameLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    var emojiLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    var priceLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 18)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.green
        
        addSubview(countryNameLabel)
        addSubview(emojiLabel)
        addSubview(priceLabel)
        
        countryNameLabel.frame = CGRect(x: 11, y: 11, width: 111, height: 22)
        emojiLabel.frame = CGRect(x: countryNameLabel.frame.maxX + 11, y: countryNameLabel.frame.origin.y, width: 88, height: 22)
        priceLabel.frame = CGRect(x: emojiLabel.frame.maxX + 11, y: countryNameLabel.frame.origin.y, width: 44, height: 22)
    }
    
    func configureWithChocolate(chocolate: Chocolate) {
        countryNameLabel.text = chocolate.countryName
        emojiLabel.text = "🍫" + chocolate.countryFlagEmoji
        priceLabel.text = CurrencyFormatter.dollarsFormatter.rw_string(from: chocolate.priceInDollars)
        
    }
}
