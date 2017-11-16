//
//  EntryViewController.swift
//  hangmanapp
//
//  Created by Johnpaulho on 11/10/17.
//  Copyright © 2017 ShoShoCodes. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {
    @IBOutlet weak var gameLevel: UISegmentedControl!
    var gameLevelVal = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gameLevelSelector(_ sender: UISegmentedControl) {
        gameLevelVal = gameLevel.selectedSegmentIndex
//        if(gameLevel.selectedSegmentIndex == 0)
//        {
//            gameLevelVal = 6
//        }
//        else if(gameLevel.selectedSegmentIndex == 1)
//        {
//            gameLevelVal = 12
//        }
//        else if(gameLevel.selectedSegmentIndex == 2)
//        {
//            gameLevelVal = 15
//        }
    }
    @IBAction func submitLevel(_ sender: UIButton) {

        let myVC = storyboard?.instantiateViewController(withIdentifier:"Hangman1") as! GameViewController
        myVC.gameLevel = gameLevel.selectedSegmentIndex
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
