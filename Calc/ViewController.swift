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
        settitleOp()
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
    
    
    
    @IBOutlet weak var div: UIButton!
    
    
    @IBOutlet weak var mult: UIButton!
    
    @IBOutlet weak var minus: UIButton!
    
    
    @IBOutlet weak var sum: UIButton!
    
    
    @IBOutlet weak var equal: UIButton!
    
    
    @IBOutlet weak var poimt: UIButton!
    
    func currinput(_ text: String) -> (String) -> String {
        
        return { newinput in
            return text + newinput
        }
    }
    
    
    
    
    
    var pointpressed = false
    var results = [Double]()
    var operation = [String]()
    var currentIndex = 0
    var currentInput : String = ""
    
    @IBAction func digitPressed(_ sender: UIButton) {
        
        let input1 = currinput("")
        let title = sender.title(for: [])
        currentInput.append(input1(title!))
        resultLabel.text = currentInput
        resultLabel.adjustsFontSizeToFitWidth = true
        if !currentInput.isEmpty{
            pointpressed = true
        }
    }
    @IBAction func operatorPressed(_ sender: UIButton) {
        if let resultText = resultLabel.text, !resultText.isEmpty {
            if let lastCharacter = resultText.last, let _ = Int(String(lastCharacter)) {
                currentInput.append(sender.currentTitle!)
                resultLabel.text = currentInput
                resultLabel.adjustsFontSizeToFitWidth = true
            }
        }
        
    }
    
    @IBAction func pressPoint(_ sender: Any) {
        if pointpressed, let resultP = resultLabel.text, !resultP.isEmpty{
            currentInput.append(".")
            pointpressed = false
            resultLabel.text = currentInput
        }
        
    }
    
    @IBAction func changeSign(_ sender: Any) {
        guard !currentInput.isEmpty else { return }
            toggleFirstCharacter(for: &currentInput)
            resultLabel.text = currentInput
    }
    
    
    
    @IBAction func clear(_ sender: Any) {
        currentInput = ""
        resultLabel.text = ""
        operationLabel.text = ""
    }
    
    
    // Action to navigate to the previous result
    @IBAction func goToPreviousResult(_ sender: UIButton) {
        if !results.isEmpty {
            if currentIndex > 0 {
                currentIndex -= 1
                operationLabel.text = results[currentIndex].description
                resultLabel.text = operation[currentIndex].description
            }
        }
        
    }
    
    
    // Action to navigate to the next result
    @IBAction func goToNextResult(_ sender: UIButton) {
        if !results.isEmpty {
            if currentIndex < results.count - 1 {
                currentIndex += 1
                operationLabel.text = results[currentIndex].description
                resultLabel.text = operation[currentIndex].description
            }
        }
    }
    
    
    @IBAction func equal(_ sender: UIButton) {
        
        if var resulting = resultLabel.text {
                resulting.append("=")
                if let result = calculate(resulting) {
                    // Update currentInput to the result of the previous calculation
                    currentInput = String(result)
                    resultLabel.text = currentInput
                }
            }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    func setTitles(){
        
        var count = 0
        for num in buttonsList{
            num.setTitle("\(count)", for: [])
            count += 1
            
        }
        
    }
    func settitleOp(){
        sum.setTitle("+", for: [])
        div.setTitle("/", for: [])
        mult.setTitle("*", for: [])
        minus.setTitle("-", for: [])
        equal.setTitle("=", for: [])
        poimt.setTitle(".", for: [])
    }
    
    
    func calculate(_ expression: String) -> Double? {
        var newExpression = expression
        if expression.starts(with: "-") || expression.starts(with: "+"){
            newExpression = "0" + expression
        }
            
        
        var currentNumber = ""
        var numbers = [Double]()
        var operations = [Character]()

        for char in newExpression {
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

                // Perform the calculations using the calculation function
                if let firstNumber = numbers.first {
                    let (getResult, add, subtraction, multiplication, division) = calculation(firstNumber)

                    for (index, op) in operations.enumerated() {
                        let nextNumber = numbers[index + 1]
                        switch op {
                        case "+":
                            add(nextNumber)
                        case "-":
                            subtraction(nextNumber)
                        case "*":
                            multiplication(nextNumber)
                        case "/":
                            division(nextNumber)
                        default:
                            break
                        }
                    }
                    results.append(getResult())
                    operation.append(currentInput)
                    return getResult()

                }
            }
        }

        return nil
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
    func updateResultLabel() {
        if currentInput.isEmpty {
            resultLabel.text = "0"
        } else {
            if let result = calculate(String(currentInput)) {
                // Update the current input to show the result
                currentInput = String(result)
                resultLabel.text = currentInput
            } else {
                resultLabel.text = "Error"
            }
        }
    }

//    func updateResultLabel() {
//        if results.isEmpty {
//            resultLabel.text = "0"
//        } else {
//            if let result = calculate(String(currentInput)) {
//
//                resultLabel.text = String(result)
//            } else {
//
//                resultLabel.text = "Error"
//            }
//        }
//    }
    
    //    func toggleFirstCharacter() {
    //        if var resultC = resultLabel.text ,let firstChar = resultC.first {
    //            switch firstChar {
    //            case "+":
    //                resultC.removeFirst()
    //                resultC.insert("-", at: resultC.startIndex)
    //            case "-":
    //                resultC.removeFirst()
    //                resultC.insert("+", at: resultC.startIndex)
    //            default:
    //                resultC.insert("-", at: resultC.startIndex)
    //            }
    //        }
    //    }
    func toggleFirstCharacter(for string: inout String) {
        guard !string.isEmpty else { return }
        switch string.first! {
        case "+":
            string.removeFirst()
            string.insert("-", at: string.startIndex)
        case "-":
            string.removeFirst()
            string.insert("+", at: string.startIndex)
        default:
            string.insert("-", at: string.startIndex)
        }
    }
}
    
    
    


