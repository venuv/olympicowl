//
//  YearPickerViewController.swift
//  OlympicLens
//
//  Created by Venu Vasudevan on 2/15/16.
//  Copyright © 2016 SO. All rights reserved.
//

import UIKit
import Parse

class YearPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var YearPickerView: UIPickerView!
    
    var yearData : [Int] = []
    var yearSelected = 1896
    
    var flagData: [Flag] = []
    var flagDictionary = [String:Flag]()

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nv = segue.destinationViewController as? UINavigationController {
            //print("break1")
            if let mg = nv.viewControllers[0] as? MedalsTableViewController {
                //print ("year = \(yearSelected)")
                mg.year = self.yearSelected
                mg.flagData = self.flagData
                mg.flagDictionary = self.flagDictionary
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //build olympic years array
        var year_elt:Int = 1896
        
        for i in 0...30 {
            year_elt = 1896 + 4*i
            yearData.append(year_elt)
        }
        
        YearPickerView.dataSource = self
        YearPickerView.delegate = self
        
        
        var flags_query = PFQuery(className:"flags")
        flags_query.limit = 200
        flags_query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                //                print("Successfully retrieved \(objects!.count) flags.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        //                        print(object.objectId)
                        //                        let cntry_string = object["Country"] as! String
                        // print(object["country"])
                        //                        print("Object is - \(object)")
                        var flag: Flag = Flag()
                        var ctry3 = object["country3"] as! String
                        flag.countryThreeLetterAbbreviation = object["country3"] as! String
                        flag.countryFullName = object["country"] as! String
                        //     flag.flagUrl = object["image"] as! String
                        let flagBlob = object["image"] as! PFFile
                        flagBlob.getDataInBackgroundWithBlock {
                            (imageData:NSData?, error:NSError?) -> Void in
                            
                            if error == nil {
                                flag.flagImage = UIImage(data: imageData!)!
                            }
                        }
                        
                        self.flagData.append(flag);
                        self.flagDictionary[ctry3] = flag
                    }
                    
                    /*
                    for (key,value) in self.flagDictionary {
                    print("--> \(key) \t \(value.countryFullName)")
                    print (" ---> \(self.flagDictionary[key]!.countryFullName)")
                    }
                    */
                    
                }
            } else {
                // Log details of the failure
                print("Flags Error: \(error!) \(error!.userInfo)")
            }
        }
        
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearData.count
    }

    
    // this allows for cool fonts
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = String(yearData[row])
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Avenir-Heavy", size: 26.0)!,NSForegroundColorAttributeName:UIColor.grayColor()])
        pickerLabel.attributedText = myTitle
        pickerLabel.textAlignment = .Center
        return pickerLabel
    }
   
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(yearData[row])
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        print("row to be printed")
        yearLabel.text = String(yearData[row])
        //print("year selected : \(yearSelected)")
        yearSelected = yearData[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
