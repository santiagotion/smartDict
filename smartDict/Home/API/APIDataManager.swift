//
//  APIDataManager.swift
//  smartDict
//
//  Created by Nathan Tuala on 6/29/20.
//  Copyright © 2020 Nathan Tuala. All rights reserved.
//

import Foundation

struct Meaning {
    let definition: String
    let example:String
    let synonyms:[String]
    
    init(json:[String:Any])
    {
        if let definition = json["definition"] as? String
        {
            self.definition = definition
        }else
        {
            self.definition = "Missing Definition"
        }
        if let example = json["example"] as? String
        {
            self.example = example
        }else {
            self.example = "Missing Example"
        }
        if let synonyms = json["synonyms"] as? [String]
        {
            self.synonyms = synonyms
        }else{
            self.synonyms = ["Empty"]
        }
        
    }
}

struct Meanings{
    let partOfSpeech:String
    let audio:String
    let meanings:[Meaning]
    //let word:String
    
    init(json:[String:Any], audio:String)
    {
        self.audio = audio
        if let partOfSpeech = json["partOfSpeech"] as? String{
            self.partOfSpeech = partOfSpeech
        }else {self.partOfSpeech = "Missing part of speech"}
        if let definitions = json["definitions"] as? [Any]
        {
            var meanings:[Meaning] = []
            for definition in definitions
            {
                if let def = definition as? [String:Any]
                {
                    let meaning = Meaning(json:def)
                    meanings.append(meaning)
                }
            }
            self.meanings = meanings
        }else
        {
            self.meanings = []
        }
    }
}
struct MyDict{
    let word:String
    let audio:String
    init(word:String, audio:String)
    {
        self.audio = audio
        self.word = word
    }
}


