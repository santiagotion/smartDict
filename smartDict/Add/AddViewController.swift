//
//  AddViewController.swift
//  smartDict
//
//  Created by Nathan Tuala on 8/15/20.
//  Copyright © 2020 Nathan Tuala. All rights reserved.
//

import UIKit
import FirebaseDatabase
class AddViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var text_field: UITextField!
    let manager:MainDataManager = MainDataManager()
    var ref:DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTextFields()
    }
    
    private func configureTextFields(){
        //word_text.delegate = self
    }
    
    @IBAction func search(_ sender: Any) {
        let word = text_field.text
        ref = Database.database().reference()
        if word?.isEmpty ?? true{
            print("Text field is empty")
        }else
        {
            let urll = "https://api.dictionaryapi.dev/api/v2/entries/en/\(word!)"
            
            var m_count = 1
            manager.getData(from: urll) { (results:[Meanings]) in
                self.ref?.child(word!).child("Word").setValue(word!)
                var audio = ""
                if(results.count > 0)
                {
                    audio = results[0].audio
                }
                self.ref?.child(word!).child("Audio").setValue(audio)
                for meaning in results
                {
                    //self.data.append(meani.partOfSpeech)
                    //self.data.append(meani.meanings[0].synonyms[0])
                    //print(self.data)
                    //print(meaning.partOfSpeech)
                    self.ref?.child(word!).child("Meanings").child("\(m_count)").child("PartOfSpeech").setValue(meaning.partOfSpeech)
                    var d_count = 1
                    for definition in meaning.meanings
                    {
                        self.ref?.child(word!).child("Meanings").child("\(m_count)").child("Definitions").child("\(d_count)").child("definition").setValue(definition.definition)
                        self.ref?.child(word!).child("Meanings").child("\(m_count)").child("Definitions").child("\(d_count)").child("example").setValue(definition.example)
                        var s_count = 1;
                        for synonym in definition.synonyms
                        {
                            self.ref?.child(word!).child("Meanings").child("\(m_count)").child("Synonyms").child("\(s_count)").setValue(synonym)
                            s_count = s_count+1
                        }
                        d_count = d_count+1
                    }
                    m_count = m_count + 1
                }
            }
        }
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
