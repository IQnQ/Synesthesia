//
//  ArtistTableViewController.swift
//  Synesthesia
//
//  Created by Zsombor Rajki on 2019. 04. 27..
//

import UIKit
import MediaPlayer

class ArtistTableViewController: UITableViewController {
    
    
        private let myMusicPlayer = (UIApplication.shared.delegate as! AppDelegate).mySystemPlayer
        var previousSong: MPMediaItem?
        //var found = false
        var mediaDictionary = [String: [MPMediaItem]]()
        let alpha = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"]
    var mediaItems: [MPMediaItem]? {
        didSet{
            //found = false
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let artists = myMusicPlayer.query(.artists){
        self.mediaItems = artists
            mediaDictionary.updateValue([], forKey: "#")
        for i in mediaItems!{
            let  mediaKey = String((i.artist?.prefix(1).uppercased())!)
            if var mediaValue = mediaDictionary[mediaKey]{
                mediaValue.append(i)
                mediaDictionary[mediaKey] = mediaValue
            }
            else if  mediaKey >= "0" && mediaKey <= "9"{
                    mediaDictionary["#"]?.append(contentsOf: [i])
                
            }
            else{
                    mediaDictionary[mediaKey] = [i]
                
                }
            }
        }

        tableView.sectionIndexColor = .white
        tableView.rowHeight = 70.0;
        tableView.register(UINib.init(nibName: "SingleCellView", bundle: nil), forCellReuseIdentifier: "SingleCellView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        myMusicPlayer.systemPlayer.setQueue(with: MPMediaQuery.songs())
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return alpha.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mediaKey = alpha[section]
        if let mediaValues = mediaDictionary[mediaKey]{
            return mediaValues.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleCellView", for: indexPath) as! SongTableViewCell

        let mediaKey = alpha[indexPath.section]
        if let mediaValues = mediaDictionary[mediaKey]{
            cell.musicTitleLabel.text = mediaValues[indexPath.row].title
            cell.musicDescLabel.text = mediaValues[indexPath.row].artist
            if let _ : MPMediaItemArtwork = mediaValues[indexPath.row].artwork{
                cell.miniImageView.image = mediaValues[indexPath.row].artwork?.image(at: cell.miniImageView.frame.size)
            }
            if let asd: Int = (mediaValues[indexPath.row].value(forProperty: MPMediaItemPropertyHasProtectedAsset) as? Int){
                if asd == 1 {
                    cell.amLabel.isHidden = false
                }else {
                    cell.amLabel.isHidden = true
                }
            }
            if let asd: Bool = (mediaValues[indexPath.row].value(forProperty: MPMediaItemPropertyIsExplicit) as? Bool){
                if asd == true {
                    cell.explicitLabel.isHidden = false
                }else {
                    cell.explicitLabel.isHidden = true
                }
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x:0, y:0, width:200, height:30))
        returnedView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let label = UILabel(frame: CGRect(x: 10,y: 0,width: 30,height: 30))
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = self.alpha[section]
        returnedView.addSubview(label)
        
        return returnedView
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return alpha
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mediaKey = alpha[indexPath.section]
        if let mediaValues = mediaDictionary[mediaKey]{
            let selectedMedia = mediaValues[indexPath.row]
            self.myMusicPlayer.systemPlayer.nowPlayingItem = selectedMedia
            self.myMusicPlayer.systemPlayer.prepareToPlay()
            self.myMusicPlayer.play()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
