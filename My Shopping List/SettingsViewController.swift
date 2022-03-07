//
//  SettingsViewController.swift
//  My Shopping List
//
//  Created by Kathryn Fieg on 6/11/19.
//  Copyright © 2019 Kathryn Fieg. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let colorArray = [ 0x000000, 0xfe0000, 0xff7900, 0xffb900, 0xffde00, 0xfcff00, 0xd2ff00, 0x05c000, 0x00c0a7, 0x0600ff, 0x6700bf, 0x9500c0, 0xbf0199, 0xffffff ]
    
    func uiColorFromHex(rgbValue: Int) -> UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
        let blue = CGFloat(rgbValue & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var selectedColourView: UIView!
    @IBOutlet weak var colourSlider: UISlider!
    @IBOutlet weak var changeColourLabel: UILabel!
    @IBOutlet weak var changeFontBtn: UIButton!
    
    
    @IBAction func sliderChanged(_ sender: Any) {
        selectedColourView.backgroundColor = uiColorFromHex(rgbValue: colorArray[Int(colourSlider.value)])
    }
    
    
    @IBAction func changeFontClicked(_ sender: UIButton) {
        Colour.sharedInstance.selectedColour = uiColorFromHex(rgbValue: colorArray[Int(colourSlider.value)])
        settingsLabel.textColor = Colour.sharedInstance.selectedColour
        changeColourLabel.textColor = Colour.sharedInstance.selectedColour
        changeFontBtn.backgroundColor = Colour.sharedInstance.selectedColour
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
