//
//  HomeScreenViewController.swift
//  kinveyNativePushApp
//
//  Created by Harikrishna Tirunagari on 20/03/18.
//  Copyright © 2018 iOS App Templates. All rights reserved.
//

import UIKit
import Kinvey

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var Msg: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkGray
        guard let name = Kinvey.sharedClient.activeUser?.username, !name.isEmpty else {
            print("String is nil or empty.")
            return // or break, continue, throw
        }
        Msg.text = "Hello " + name
        /// myString is neither nil nor empty (if this point is reached)
//        print(name)
    }

    @IBAction func logout(_ sender: Any) {
                Kinvey.sharedClient.activeUser?.logout()
                self.performSegue(withIdentifier: "navigateToLoginScreen", sender: sender)
    }
    
//    @IBAction func logoutAction(_ sender: Any) {
//        Kinvey.sharedClient.activeUser?.logout()
//        self.performSegue(withIdentifier: "navigateToLoginScreen", sender: sender)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
