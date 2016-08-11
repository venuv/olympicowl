//
//  MedalsTableViewController.swift
//  splitViewUsingSeques
//
//  Created by Venu Vasudevan on 1/30/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class MedalsTableViewController: UITableViewController {

    var countryData: [Country] = []
    var flagData: [Flag] = []
    var year = 1972
    var rowOffset = 0
    var flagDictionary = [String:Flag]()
    var top3Dictionary = [String:Top3Sports]()
    
    
    @IBOutlet weak var backToYear: UIBarButtonItem!
    
    let medalsSegueIdentifier = "ShowMedalSegue"
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("******* segue = \(segue.identifier)")
        
        if segue.identifier == "toYearSelect" {
            
            if let ypv = segue.destinationViewController as? YearPickerViewController {
                self.year=1896
                
            }
        }
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        var query = PFQuery(className:"weighted_medal_score")
        query.whereKey("year", equalTo:Int(year))
        query.limit = 150
        query.addDescendingOrder("score")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
//                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let wms_objects = objects {
                    for object in wms_objects {
                        //                        print(object.objectId)
                        //                        let cntry_string = object["Country"] as! String
                        // print(object["country"])
                        var cntry: Country = Country()
                        cntry.countryThreeLetterAbbreviation = object["country"] as! String
                        cntry.weightedScore = object["score"] as! Int
                        self.countryData.append(cntry)
                    }
                     //print("countries done")
                    self.tableView.reloadData()

                }
            } else {
                // Log details of the failure
                //print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        
        var top3_query = PFQuery(className:"top3")
        top3_query.whereKey("year", equalTo:Int(year))
        top3_query.limit = 150
        top3_query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in

            if error==nil {
                var firstSport, secondSport, thirdSport : String?
                if let top3_objects = objects {
                    for object in top3_objects {
                        var top3Item = Top3Sports()
                        top3Item.firtSport = object["first"] as! String
                        top3Item.secondSport = object["second"] as! String
                        top3Item.thirdSport = object["third"] as! String
                        if let ctry3 = object["country"] as? String {
                            self.top3Dictionary[ctry3]=top3Item
                        }
                    }
                }
                //print("top3 size - \(self.top3Dictionary.count)")
                self.tableView.reloadData()
            }
            else {
                print("error in top3 retrieval")
            }

        }

//        print("IN VIEW DID LOAD")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print("setting #rows to \(countryData.count)")
        return countryData.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(year) Olympics"
    }
    
    /*
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Tabs here"
    }
    */
    
    /*
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset) <= 40 {
            rowOffset += 5
            print("rowoffset = \(rowOffset)")
        }
    }
    */
    
    // return closest matching Sport category to sport name
    func mapStringToCategory (value:String) -> String? {
        //TODO: separate freestyle and Greco wrestling
        // cycling road vs cycling track
        
        var lowerCaseValue = value.lowercaseString
        
        if (lowerCaseValue == "") {
            return nil
        }
        if lowerCaseValue.containsString("athle") {
            return "athletics"
        }
        else if lowerCaseValue.containsString("swim") {
            return "swimming"
        }
        else if lowerCaseValue.containsString("box") {
            return "boxing"
        }
        else if lowerCaseValue.containsString("wrest") {
            return "wrestling"
        }
        else if lowerCaseValue.containsString("weight") {
            return "weightlifting"
        }
        else if lowerCaseValue.containsString("cycl") {
            return "cycling"
        }
        else if lowerCaseValue.containsString("fenc") {
            return "fencing"
        }
        else if lowerCaseValue.containsString("shoo") {
            return "shooting"
        }
        else if lowerCaseValue.containsString("row") {
            return "rowing"
        }
        else if lowerCaseValue.containsString("cano") {
            return "canoeing"
        }
        else if lowerCaseValue.containsString("judo") {
            return "judo"
        }
        else if lowerCaseValue.containsString("voll") {
            return "volleyball"
        }
        else if lowerCaseValue.containsString("waterp") {
            return "waterpolo"
        }
        else if lowerCaseValue.containsString("artist") {
            return "gymnastics"
        }
        else if lowerCaseValue.containsString("foot") {
            return "football"
        }
        else if lowerCaseValue.containsString("divi") {
            return "diving"
        }
        else if lowerCaseValue.containsString("sail") {
            return "sailing"
        }
        else if lowerCaseValue.containsString("hock") {
            return "hockey"
        }
        else if lowerCaseValue.containsString("hand") {
            return "handball"
        }
        else if lowerCaseValue.containsString("bask") {
            return "basketball"
        }
        else if lowerCaseValue.containsString("arch") {
            return "archery"
        }
        else if lowerCaseValue.containsString("arti") {
            return "gymnastics"
        }
        else if lowerCaseValue.containsString("beach") {
            return "beach volleyball"
        }
        else if lowerCaseValue.containsString("taek") {
            return "taekwondo"
        }
        else if lowerCaseValue.containsString("mount") {
            return "mountain bike"
        }
        else if lowerCaseValue.containsString("bmx") {
            return "bmx"
        }
        else if lowerCaseValue.containsString("tram") {
            return "trampoline"
        }
        else if lowerCaseValue.containsString("base") {
            return "baseball"
        }
        else if lowerCaseValue.containsString("water") {
            return "waterpolo"
        }
        else if lowerCaseValue.containsString("tenni") {
            return "tennis"
        }
        else if lowerCaseValue.containsString("polo") {
            return "polo"
        }
        else if lowerCaseValue.containsString("figu") {
            return "figure skating"
        }
        return "unknown"

    }
    
    //return image url from Images.assets corresponding to sport
    func mapCategoryToImage (category:String)->String {

        switch category
        {
            case "athletics":
                return "running.png"
            case "boxing":
                return "boxing.png"
            case "swimming":
                return "swimming.png"
            case "weightlifting":
                return "weightlifting.png"
            case "wrestling":
                return "wrestlers-two-color.png"
            case "cycling":
                return "cycling.png"
            case "fencing":
                return "fencing.png"
            case "shooting":
                return "shooting.png"
            case "rowing":
                return "rowing.png"
            case "canoeing":
                return "canoeing.png"
            case "judo":
                return "judo.png"
            case "volleyball":
                return "volleyball.png"
            case "diving":
                return "diving.png"
            case "waterpolo":
                return "waterpolo.png"
            case "gymnastics":
                return "gymnastics.png"
            case "football":
                return "football.png"
            case "hockey":
                return "hockey.png"
            case "sailing":
                return "sailing.png"
            case "handball":
                return "handball.png"
            case "basketball":
                return "basketball.png"
            case "archery":
                return "archery.png"
            case "beach volleyball":
                return "beach volleyball.png"
            case "taekwondo":
                return "taekwondo.png"
            case "mountain bike":
                return "mountain bike.png"
            case "bmx":
                return "bmx.png"
            case "trampoline":
                return "trampoline.png"
            case "baseball":
                return "baseball.png"
            case "tennis":
                return "tennis.png"
            case "polo":
                return "polo.png"
            case "figure skating":
                return "figure skating.png"
        
            default:
                return "olympic torch.png"
        }

    }
    
    func lend<T where T:NSObject> (closure:(T)->()) -> T {
        let orig = T()
        closure(orig)
        return orig
    }
    
    func handleTap(sender: UIGestureRecognizer) {
        print("tapped")
        let tapLocation = sender.locationInView(self.tableView)
        
        //using the tapLocation, we retrieve the corresponding indexPath
        let indexPath = self.tableView.indexPathForRowAtPoint(tapLocation)
        
        //finally, we print out the value
        //print(indexPath)
        
        //we could even get the cell from the index, too.
        var cell = tableView.cellForRowAtIndexPath(indexPath!) as? MedalTableViewCell
        var cntry = cell?.countryNameFull.text
        print("\(cntry!) in \(year)")
        
        var cellRect : CGRect = self.tableView.rectForRowAtIndexPath(indexPath!)
        cellRect = CGRectOffset(cellRect, -tableView.contentOffset.x, -tableView.contentOffset.y);
        
        var cntry3 = cell?.countryNameAbbrev.text
        var top3Value = top3Dictionary[cntry3!]! as Top3Sports
        print(" top sport - \(top3Value.firtSport)")
        
        // this code is attempt to replicate the overlaid buttin
        // over cell UX, with Text instead
        // 1. create attributed string
        var cntryLine = "Top Sports for "+cntry!+"\r\n" + "1."+top3Value.firtSport + "\r\n" + "2." + top3Value.secondSport + "\r\n" + "3."+top3Value.thirdSport
        
        let mas = NSMutableAttributedString(string: cntryLine, attributes:
            [NSFontAttributeName: UIFont(name:"Chalkduster",size:16)!])
        
        mas.addAttribute(NSParagraphStyleAttributeName,
            value:lend(){
                (para:NSMutableParagraphStyle) in
                para.alignment = .Left
                para.lineBreakMode = .ByWordWrapping
                para.hyphenationFactor = 1
            },
            range:NSMakeRange(0,3))
        
        // 2. add it to TextStorage
        let ts = NSTextStorage(attributedString: mas)
        
        // 3. create layout manager and associate with TextStorage
        let lm = NSLayoutManager()
        ts.addLayoutManager(lm)
        
        // 4. create textcontainer with cellrect size
        var tcSize : CGSize = cellRect.size
        let tc = NSTextContainer(size: tcSize)
        
        // 5. add text container to layout mgr
        lm.addTextContainer(tc)
        
        // 6. create UITextView with cellRect as frame & textContainer
        let tv = UITextView(frame: cellRect, textContainer: tc)
        tv.backgroundColor = UIColor.whiteColor()
        
        // 7. add UITextView as subview and animate
        tv.alpha = 0.9
        self.navigationController?.view.addSubview(tv)
        UIView.animateWithDuration(5, animations: {
            tv.alpha = 0.0
        })

    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let gestureRecognizer = UITapGestureRecognizer(target: self,
            action: "handleTap:")
        self.view.addGestureRecognizer(gestureRecognizer)
        
        
        // get medalsGallery[row]
//        print("***tableView cellForRowAtIndexPath at \(indexPath.row), array size = \(self.countryData.count)")


        // Configure the cell...
        
        let cell = tableView.dequeueReusableCellWithIdentifier("medalgallerycell", forIndexPath: indexPath) as UITableViewCell


        
        var cellValue: Country
        if self.countryData.count > 0 {
            cellValue = countryData[rowOffset + Int(indexPath.row)]
//            cell.textLabel?.text = cellValue.countryThreeLetterAbbreviation
//            cell.detailTextLabel?.text = String(cellValue.weightedScore)
            var medalCell : MedalTableViewCell = cell as! MedalTableViewCell
            

            var country3 = cellValue.countryThreeLetterAbbreviation
            
            medalCell.countryNameAbbrev?.text = cellValue.countryThreeLetterAbbreviation
            
            let cntry3 = cellValue.countryThreeLetterAbbreviation
            

            
            //print("looking for full name for \(cntry3)")
            if let cntryFlag = self.flagDictionary[cntry3] {
                //            print("#### dictionary - \(self.flagDictionary.count)")
                //print (" +++---> \(cntryFlag.countryFullName)")
                medalCell.countryNameFull?.text = cntryFlag.countryFullName
                medalCell.countryImage.image = cntryFlag.flagImage
            }
            else {
                medalCell.countryNameFull?.text = ""
            }

            if let top3Value = top3Dictionary[country3] {
                
                var firstSport = top3Value as Top3Sports
                if firstSport.firtSport != "" {
                    //print ("firstSport is for \(country3) is \(firstSport.firtSport)")
                    //print ("image url : \(mapCategoryToImage(mapStringToCategory(firstSport.firtSport)!))")
                
                    if let imageString = mapStringToCategory(firstSport.firtSport) {
                        medalCell.firstSportImage.image = UIImage(named: mapCategoryToImage(imageString))
                    }
                    
                    //medalCell.firstSportImage.image = UIImage(named:mapCategoryToImage(mapStringToCategory(firstSport.firtSport)!))
                }
                else {
                    medalCell.firstSportImage.image = UIImage(named: "zazaza.png")
                }
                
                if firstSport.secondSport != "" {
                    //print ("secondSport is for \(country3) is \(firstSport.secondSport)")
                    //print ("image url : \(mapCategoryToImage(mapStringToCategory(firstSport.secondSport)!))")
                   // medalCell.secondSportImage.image = UIImage(named:mapCategoryToImage(mapStringToCategory(firstSport.secondSport)!))
                    
                    if let imageString = mapStringToCategory(firstSport.secondSport) {
                        medalCell.secondSportImage.image = UIImage(named: mapCategoryToImage(imageString))
                    }
                }
                else {
                    medalCell.secondSportImage.image = UIImage(named: "zazaza.png")
                }
                
                if firstSport.thirdSport != "" {
                    //print ("thirdSport is for \(country3) is \(firstSport.thirdSport)")
                    //print ("image url : \(mapCategoryToImage(mapStringToCategory(firstSport.thirdSport)!))")
        //            medalCell.thirdSportImage.image = UIImage(named:mapCategoryToImage(mapStringToCategory(firstSport.thirdSport)!))
                    if let imageString = mapStringToCategory(firstSport.thirdSport) {
                        medalCell.thirdSportImage.image = UIImage(named: mapCategoryToImage(imageString))
                        //let gestureRecognizer = UITapGestureRecognizer(target: self,
                        //    action: "handleTap:")
                        //self.view.addGestureRecognizer(gestureRecognizer)
                    }
                }
                else {
                    medalCell.thirdSportImage.image = UIImage(named: "zazaza.png")
                }
            }
            

            
        }
        

        
        return cell
    }
    

    

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */



}
