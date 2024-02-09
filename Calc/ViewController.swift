//
//  ViewController.swift
//  Calc
//
//  Created by english on 2024-02-02.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitles()
        // Do any additional setup after loading the view.
    }

    //closure
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var num4: UIButton!
    
    
    @IBOutlet weak var num9: UIButton!
    
    @IBOutlet weak var num6: UIButton!
    
    @IBOutlet weak var num5: UIButton!
    
    @IBOutlet weak var num1: UIButton!
    
    @IBOutlet weak var num8: UIButton!
    
    @IBOutlet weak var num7: UIButton!
    
    @IBOutlet weak var num0: UIButton!
    
    @IBOutlet weak var num3: UIButton!
    
    @IBOutlet weak var num2: UIButton!
    
    @IBOutlet weak var operationLabel: UILabel!
    
    @IBOutlet var buttonsList: [UIButton]!
    
    //var currentInput: String = ""
    
    func currinput(_ text: String) -> (String) -> String {
        
        return { newinput in
            return text + newinput
        }
    }

    
    
    
    
    var pointpressed = false
    var results = [Double]()
    var currentIndex = 0
    var currentInput : String = ""

    @IBAction func digitPressed(_ sender: UIButton) {
        
        let input1 = currinput("")
        let title = sender.title(for: [])
        currentInput.append(input1(title!))
        //currentInput.append(title!)
        resultLabel.text = currentInput
        if !currentInput.isEmpty{
            pointpressed = true
        }
        }

    @IBAction func pressPoint(_ sender: Any) {
        if pointpressed{
            currentInput.append(".")
            pointpressed = false
        }
    }
    
    @IBAction func changeSign(_ sender: Any) {
        var number = Double(currentInput)
        number = number! * (-1)
    }
    
    
    @IBAction func clear(_ sender: Any) {
        currentInput = "0"
        operationLabel.text = ""
    }
    

    // Action to navigate to the previous result
    @IBAction func goToPreviousResult(_ sender: UIButton) {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }


    // Action to navigate to the next result
    @IBAction func goToNextResult(_ sender: UIButton) {
        if currentIndex < results.count - 1 {
            currentIndex += 1
        }
    }
    
    
    func setTitles(){
        
        var count = 0
        for num in buttonsList{
            num.setTitle("\(count)", for: [])
            count += 1
            
        }
    
    }
    
    


    func calculate(_ expression: String) -> Double? {
        var currentNumber = ""
        var numbers = [Double]()
        var operations = [Character]()
        //var (getResult, add, subtraction, multiplication, division) 

        for char in expression {
            if char.isNumber || char == "." {
                currentNumber.append(char)
            } else if "+-*/".contains(char) {
                if let number = Double(currentNumber) {
                    numbers.append(number)
                }
                currentNumber = ""
                operations.append(char)
            } else if char == "=" {
                if let number = Double(currentNumber) {
                    numbers.append(number)
                }
                currentNumber = ""


                var result = numbers.first ?? 0
                for (index, op) in operations.enumerated() {
                    let nextNumber = numbers[index + 1]
                    switch op {
                    case "+":
                        result += nextNumber
                    case "-":
                        result -= nextNumber
                    case "*":
                        result *= nextNumber
                    case "/":
                        result /= nextNumber
                    default:
                        break
                    }
                }
                results.append(result)
                
                return result
            }
        }


        return nil
    }
    
    func updateResultLabel() {
        if results.isEmpty {
            resultLabel.text = "0"
        } else {
            if let result = calculate(String(currentInput)) {
                
                resultLabel.text = String(result)
            } else {
                
                resultLabel.text = "Error"
            }
        }
    }
    


    //to show inside the label when someone clicks up arrow
    func accessMemory() -> Double?
    {
        if results.isEmpty{
            return nil
        }
        else{
            return results.last
        }
    }
    
    func calculation(_ num1: Double) -> (() -> Double, (Double) -> Void, (Double) -> Void, (Double) -> Void, (Double) -> Void) {
        var result = num1
    
        let add: (Double) -> Void = { num2 in
            result += num2
        }
    
        let multiplication: (Double) -> Void = { num2 in
            result *= num2
        }
    
        let subtraction: (Double) -> Void = { num2 in
            result -= num2
        }
    
        let division: (Double) -> Void = { num2 in
            result /= num2
        }
    
    
        let getResult: () -> Double = {
            return result
        }
    
        return (getResult, add, subtraction, multiplication, division)
    }
    

    
    
    
    
    
}
    
    
    
    


