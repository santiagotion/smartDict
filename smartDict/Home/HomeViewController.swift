//
//  HomeViewController.swift
//  smartDict
//
//  Created by Nathan Tuala on 6/29/20.
//  Copyright © 2020 Nathan Tuala. All rights reserved.
//

import UIKit
import FirebaseDatabase

import AVFoundation
import AVKit

class HomeViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var audioPlayer:AVAudioPlayer!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    var filteredData: [String]!
    
    //var audioPlayer:AVAudioPlayer?
    var data = [String]()
    var dict_data = [MyDict]()
    var meaningData = [Meanings]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dict_data.count
        //return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as UITableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableViewCell
        
        //cell.myLabel.text = dict_data[indexPath.row].word
        //cell.textLabel?.text = filteredData[indexPath.row]
        cell.setMeaning(dictionary: dict_data[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
        
        // Set the firebase reference
        ref = Database.database().reference()
        tableView.dataSource = self
        searchBar.delegate = self
        
        // Retrieve the post and listen for changes
        filteredData = data
        databaseHandle = ref?.observe(.childAdded, with: { (snapshot) in
            // Code to execute when a new word is added
            let w_snapshot = snapshot.childSnapshot(forPath: "Word")
            let a_snapshot = snapshot.childSnapshot(forPath: "Audio")
            var t_audio = ""
            var t_word = ""
            let audio = a_snapshot.value as? String
            let word = w_snapshot.value as? String
            if let actualWord = word{
                //self.data.append(actualWord)
                //self.filteredData = self.data
                //self.tableView.reloadData()
                t_word = actualWord
            }
            if let actualAudio = audio
            {
                t_audio = actualAudio
            }
            let dict = MyDict(word: t_word, audio: t_audio)
            self.dict_data.append(dict)
            self.tableView.reloadData()
        })
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })

        tableView.reloadData()
    }

}

extension HomeViewController: TableViewDelegate{
    func playSound(url: String) {
        //print(url)
        guard let c_url = URL(string: url) else { return}
        downloadFileFromURL(url: c_url)
    }
    
    func downloadFileFromURL(url: URL){
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url) { (url, response, error) in
            self.play(url: url!)
        }
        downloadTask.resume()
    }
    func play(url:URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url as URL)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 2.0
            audioPlayer.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
}
