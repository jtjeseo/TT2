//
//  ViewController.swift
//  TT2
//
//  Created by Jared Jeseo on 1/23/20.
//  Copyright © 2020 Jared Jeseo. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {

    //Data Members
    //Bos
    @IBOutlet weak var BosScientificValue_Label: UILabel!
    @IBOutlet weak var BosLevel_TextField: UITextField!
    var bosLevel = Float()
    //Charged Card
    @IBOutlet weak var ChargedCardScientificValue_Label: UILabel!
    @IBOutlet weak var ChargedCard_TextField: UITextField!
    var chargedCardLevel = Float()
    
    //MAIN
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Keyboard stuff
        BosLevel_TextField.delegate = self
        ChargedCard_TextField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        //Load values
        LoadValues("BookOfShadows",&bosLevel,BosLevel_TextField)
        LoadValues("ChargedCard",&chargedCardLevel,ChargedCard_TextField)
        
        BosLevel_TextField.text = "\(bosLevel)"
        ChargedCard_TextField.text = "\(chargedCardLevel)"
    }
    
    //METHODS AND FUNCTIONS
    
    //Update Funcs
    @IBAction func BosLevelUpdated(_ sender: UITextField!) {
        UpdateLevel("BookOfShadows", sender)
    }
    @IBAction func ChargedCardUpdated(_ sender: UITextField!) {
        UpdateLevel("ChargedCard", sender)
    }
    func UpdateLevel(_ entityName: String, _ sender: UITextField!){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        let level = Float(sender.text!)
        newEntity.setValue(level, forKey: "level")
        do {
            try context.save()
            print("Saved new artifact value")
        } catch {
            print("Failed to save Bos")
        }
    }
    
    //Increment Scientific Value with + and -
    @IBAction func BoS_Stepper(_ sender: UIStepper) {
        BosScientificValue_Label.text = "e" + String(Int(sender.value))
    }
    @IBAction func ChargedCard_Stepper(_ sender: UIStepper) {
        ChargedCardScientificValue_Label.text = "e" + String(Int(sender.value))
    }
    
    func LoadValues(_ entityName: String, _ levelVar: inout Float, _ textField: UITextField!)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject]
            {
                levelVar = data.value(forKey: "level") as? Float ?? 0.0
            }
            textField.text = "\(levelVar)"
            print("Loaded values." + "\(levelVar)")
        }
        catch
        {
            print("Failed to load values.")
        }
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
