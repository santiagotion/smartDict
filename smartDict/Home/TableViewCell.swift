//
//  TableViewCell.swift
//  smartDict
//
//  Created by Nathan Tuala on 8/17/20.
//  Copyright © 2020 Nathan Tuala. All rights reserved.
//

import UIKit

protocol TableViewDelegate {
    func playSound(url: String)
}
class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var myLabel: UILabel!
    var dict : MyDict!
    var delegate : TableViewDelegate?
    func setMeaning(dictionary: MyDict)
    {
        dict = dictionary
        myLabel.text = dictionary.word
    }
    @IBAction func play_sound(_ sender: Any) {
        delegate?.playSound(url: dict.audio)
    }
    
    
}
