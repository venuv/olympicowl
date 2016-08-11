//
//  MultipleChoiceViewController.swift
//  multipleChoiceQuestion
//
//  Created by Venu Vasudevan on 3/1/16.
//  Copyright © 2016 OL. All rights reserved.
//

import UIKit
import Foundation
import Parse

class MultipleChoiceViewController: UIViewController {


    @IBOutlet weak var answerButton: UIButton!
   
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet var answerButtons: [UIButton]!
    
    
    @IBAction func answerButtonHandler(sender: AnyObject) {
        //
        if sender.titleLabel!?.text == nextQuiz {
            print("** next quiz picked **")
            
/*
            answers = []
            var numbers = [20,30,40,50]
            for i in 0...3 {
               var str = String(numbers[i])
                
                if i==3 {
                    correctAnswer = str
                    print("correct answer will be \(str)")
                }
                answers.append(str)
            }
*/
            print("reloading view")

            self.viewDidLoad()
        }
        else if sender.titleLabel!?.text == correctAnswer {
            print("hooray")
            answerButton.setImage(UIImage(named:"check.png"), forState: .Normal)
            
        } else {
            print("picked \(sender.titleLabel!?.text) - better luck next time")
            answerButton.setImage(UIImage(named:"cross.png"), forState: .Normal)
        }
    }
    
    var nextQuiz = "Next Question"
    var correctAnswer = "$10M"

    var questions = [Question]()
    var answers = ["$10M","$100K","$35M","$1M"]
    var currentQuestion = "nil"
    var currentSport = "Junk"
    var flag:Bool = false //so getAllQuestions gets called exactly once
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // hide back button
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        //retrieve questions only once
        if flag==false {
            getAllQuestions()
        }
        else {
        // change titles for each refresh
        titlesForButtons()
        }
    }

    // generateAnswers:
    // - origin_yr : random value +/- 500 years
    // - first_olympic yr : random value +/- 7 olympics
    // - top salary : float factor of 0.0 to 5.0
    // - global player count : 0.2 to 5 randomize
    func generateAlternative (trueValue : String, questionType:String) -> String? {
        var plusminus = arc4random_uniform(UInt32(2))
        var fraction = drand48()
        
        if (questionType == "origin_yr") {
                var increment = Int(200*fraction)
            if Int(plusminus)==1 {
                return String(Int(trueValue)!+Int(increment))
            } else {
                return String(Int(trueValue)!-Int(increment))
            }
        } else if (questionType == "first_olympic_yr") {
            var increment = 28*fraction
            increment = 4 * round(increment/4)
            if Int(plusminus)==1 {
                return String(Int(trueValue)!+Int(increment))
            } else {
                return String(Int(trueValue)!-Int(increment))
            }
            
        } else if (questionType == "top_salary") {
            // assume number is in millions
            return String(Double(trueValue)! * 5 * fraction)
        } else if (questionType == "global_player_cnt") {
            //assume number in millions
            return String(Double(trueValue)! * 5 * fraction)
        }
        
        return nil
    }
    
    func composeQuestion (question_str:String) -> String {
        if (question_str == "first_olympic_yr") {
            return("Olympic inclusion year for : ")
        } else if (question_str == "origin_yr") {
            return ("Year sport originated : ")
        } else if (question_str == "top_salary") {
            return("Top salary in : ")
        } else if (question_str == "global_player_cnt") {
            return ("#People who play : ")
        }
        return ("Nonsense")
    }
    
    func getNextQuestion() {
       let arraySize = questions.count
        var index = arc4random_uniform(UInt32(arraySize))
        var correctAnswerString = questions[Int(index)].answer
        currentQuestion =  questions[Int(index)].question_string
        currentSport = questions[Int(index)].sport
        var correctAnswerIndex = arc4random_uniform(UInt32(4))
        
        for i in 0...3 {
            if i == Int(correctAnswerIndex) {
                answers[i] = correctAnswerString
                correctAnswer = correctAnswerString
            } else {
                //answers[i]="wrong answer"
                answers[i] = generateAlternative(correctAnswerString, questionType: currentQuestion)!
            }
        }
        print("in getNextQuestion, question is \(currentQuestion),\(currentSport)")
        print("arraysize - \(arraySize), index - \(index)")
    }
    
    func getAllQuestions() {
        var query = PFQuery(className:"sportfacts")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                //                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let sportfact_objects = objects {
                    
                    for object in sportfact_objects {
                        var qn : Question = Question()
                        qn.question_string = object["measure"] as! String
                        qn.answer = object["value"] as! String
                        qn.sport = object["sport"] as! String
                        
                        //print("Question sport - \(qn.sport)")
                        self.questions.append(qn)
                        
                    }
                    self.flag = true
                    self.titlesForButtons()
                    
                }
            } else {
                // Log details of the failure
                //print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func titlesForButtons() {

        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        
        getNextQuestion()
        
        for (idx,button) in EnumerateSequence(answerButtons) {
            button.setTitle(answers[idx], forState: .Normal)
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.titleLabel!.font =
                UIFont(name:"AppleSDGothicNeo-Bold",size:18.0)
            button.layer.borderColor = UIColor.whiteColor().CGColor
            
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.backgroundColor = UIColor.whiteColor()
            //button.layer.borderWidth = 2.0
            button.layer.borderColor = UIColor(white: 1, alpha: borderAlpha).CGColor
            button.layer.cornerRadius = cornerRadius
        }
        

        //questionLabel.text = "Highest Badminton Salary?"
        questionLabel.text = composeQuestion(currentQuestion)+currentSport+"?"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
