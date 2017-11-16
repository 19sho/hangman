//
//  ViewController.swift
//  hangmanapp
//
//  Created by Johnpaulho on 10/3/17.
//  Copyright © 2017 ShoShoCodes. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var guessedLetter: UITextField!
    var guessWord = ""
    var wordGuessedCorrectly = false
    var gameLevel = 0
    var MAX_ALLOWED_GUESSES = 6
    
    var currentGuessNumber = 1
    var numOfCorrectGuesses = 0
    var numOfWrongGuesses = 0
    var usedLetters: [Character] = []
    var wordList: [String]?

    
    @IBOutlet weak var guessedWordLabel: UILabel!
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var guessWordLabel: UILabel!
    //differentiate between variables with more unique names
    @IBAction func submitButton(_ sender: UIButton) {
        if (guessedLetter.text == "") {
            message.text = "Enter a letter"
            return
        }
        let msg = isLetterInWord((guessedLetter.text?.characters.first!)!)
        if wordGuessedCorrectly {
            message.text = "Yay you won!\nThe word was " + guessWord
            submitButton.isHidden = true
            playAgainButton.isHidden = false
        } else if currentGuessNumber >  MAX_ALLOWED_GUESSES {
            message.text = "Boo you lost!\nThe word was " + guessWord
            submitButton.isHidden = true
            playAgainButton.isHidden = false
            var imgName = "Hangman" + String(gameLevel+1) + String(MAX_ALLOWED_GUESSES-1)
            let newImg: UIImage? = UIImage(named: imgName)
            hangmanImage.image = newImg
        } else {
            message.text = msg
        }
        
        guessedLetter.text = ""
        guessedWordLabel.text = getmaskedGuessWord()
    }
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBAction func playAgain(_ sender: UIButton) {
        submitButton.isHidden = false
        playAgainButton.isHidden = true
        message.text = ""
        guessedLetter.text = ""
        wordGuessedCorrectly = false

        currentGuessNumber = 1
        numOfCorrectGuesses = 0
        numOfWrongGuesses = 0
        usedLetters = []
        guessWord = getWordToGuess()
        guessedWordLabel!.text = getmaskedGuessWord()
        //guessWordLabel.text = guessWord
        let imgName = "Hangman" + String(gameLevel+1) + "1"
        let newImg: UIImage? = UIImage(named: imgName)
        hangmanImage.image = newImg
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // load word list
        do {
            if let path = Bundle.main.path(forResource: "wordList", ofType: "txt"){
                let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                wordList = data.components(separatedBy: "\n")
                print(wordList)
            }
        } catch let err as NSError {
            // do something with Error
            print(err)
        }
        
        guessWord = getWordToGuess()
        //guessWordLabel.text = guessWord

        guessedWordLabel!.text = getmaskedGuessWord()
        
        submitButton.isHidden = false
        playAgainButton.isHidden = true
        
        // set MAX_ALLOWED_GUESSES based on gameLevel
        if gameLevel == 0 {
            MAX_ALLOWED_GUESSES = 6
        } else if gameLevel == 1 {
            MAX_ALLOWED_GUESSES = 12
        } else if gameLevel == 2 {
            MAX_ALLOWED_GUESSES = 16
        }
        print (">>> GAME LEVEL:" + String(gameLevel))
        message.text = "You have " + String(MAX_ALLOWED_GUESSES-currentGuessNumber+1) + " guesses left"
        self.guessedLetter.delegate = self;
        let imgName = "Hangman" + String(gameLevel+1) + "1"
        let newImg: UIImage? = UIImage(named: imgName)
        hangmanImage.image = newImg
    }

    func getmaskedGuessWord() -> String {
        var gwl = ""
        for c in guessWord.characters {
            if usedLetters.contains(c) {
                gwl += String(c) + " "
            } else {
                gwl += "_ "
            }
        }
        return gwl
    }
    func getWordToGuess() -> String {
//        var words = ["dog", "cat", "mouse", "casti","plate","nap","candy","the","tree","man","leash","red","blue","white","block","tail","fur","head","tile","zoo","punch","kick","nose","wet","dry","done","eye"]

//        let randomNumber = Int(arc4random_uniform(UInt32(words.count)) )
//        let word = words[randomNumber]
        let randomNumber = Int(arc4random_uniform(UInt32(wordList!.count)) )
        let word = wordList![randomNumber]
        return word
    }
    
    func isLetterInWord(_ letter: Character) -> String {
        var msg = ""
        if usedLetters.contains(letter) {
            return "BOO! You already used \(letter)."
        }
        
        // check if letter in guessWord
        if (guessWord.characters.contains(letter)) {
            usedLetters.append(letter)
            msg = "Great! \"\(letter)\" is contained within the word!"
    
            // check to see if the input letter is contained in the word multiple times
            var countHowManyTimesTheLetterExists = 0
            for char in guessWord.characters {
                if char == letter {
                    countHowManyTimesTheLetterExists += 1
                }
            }
            numOfCorrectGuesses += countHowManyTimesTheLetterExists
    
            msg += "\nYou have \(guessWord.characters.count - numOfCorrectGuesses) letter(s) to guess \nand \(MAX_ALLOWED_GUESSES - currentGuessNumber) guesses left."
            if (numOfCorrectGuesses == guessWord.characters.count) {
                wordGuessedCorrectly = true
            }
        } else { // letter not found in guessWord
            numOfWrongGuesses += 1
            msg = "Nope! \"\(letter)\" is not in the word."
            msg += "\nYou have \(MAX_ALLOWED_GUESSES - currentGuessNumber) guesses left."
            //Change image
            var imgName = "Hangman" + String(gameLevel+1) +  String(numOfWrongGuesses+1)
            let newImg: UIImage? = UIImage(named: imgName)
            hangmanImage.image = newImg
        }
        currentGuessNumber += 1
        return msg
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func playTheGame() {
        var currentGuessNumber = 1
        var words = ["dog", "cat", "mouse", "casti","plate","nap","candy","the","tree","man","leash","red","blue","white","block","tail","fur","head","tile","zoo","punch","kick","nose","wet","dry","done","eye"]
        let MAX_ALLOWED_GUESSES = 6
        var usedLetters: [Character] = []
        var numOfCorrectGuesses = 0
        var numOfWrongGuesses = 0
        // random integer between 0 and n-1
        print("Welcome. I am thinking of a word. You will have 6 guesses to guess all the letters in my word. Some words will have two letters, some will have 5. Be smart and strategic. Begin.")
        var randomNumber: Int
        var word = ""
        var lengthOfWord: Int
        randomNumber = Int(arc4random_uniform(UInt32(words.count)) + 1)
        word = words[randomNumber]
        lengthOfWord = word.characters.count
        var guessedCorrectly = false
        while (guessedCorrectly != true && currentGuessNumber <= MAX_ALLOWED_GUESSES) {
            
            print("Guess a letter: ", terminator: "")
            var userInput = readLine()
            
            while (userInput == nil || userInput?.characters.first == nil) {
                print("Guess a letter: ", terminator: "")
                userInput = readLine()
            }
            let userGuessLetter = userInput!.characters.first!
            
            if usedLetters.contains(userGuessLetter) {
                print("BOO! You already used \(userGuessLetter).")
                continue
            }
            
            if (word.characters.contains(userGuessLetter)) {
                print("Great! \"\(userGuessLetter)\" is contained within the word!")
                
                // check to see if the input letter is contained in the word multiple times
                var countHowManyTimesTheLetterExists = 0
                for char in word.characters {
                    if char == userGuessLetter {
                        countHowManyTimesTheLetterExists += 1
                    }
                }
                numOfCorrectGuesses += countHowManyTimesTheLetterExists
                print("You have \(lengthOfWord - numOfCorrectGuesses) letter(s) to guess and \(MAX_ALLOWED_GUESSES - currentGuessNumber) guesses left.")
                
            } else {
                print("Nope! \"\(userGuessLetter)\" is not in the word.")
                
                numOfWrongGuesses += 1
                print("You have \(MAX_ALLOWED_GUESSES - currentGuessNumber) guesses left.")
            }
            
            usedLetters.append(userGuessLetter)
            
            if numOfCorrectGuesses == lengthOfWord {
                guessedCorrectly = true
                
            }
            currentGuessNumber += 1
        }
        if guessedCorrectly {
            print("Yay you won!")
        } else {
            print("Boo you lost!")
        }
        print("The word was \"\(word)\".")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

