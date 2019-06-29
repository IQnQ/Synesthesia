//
//  PlaylistDetailTableViewController.swift
//  Synesthesia
//
//  Created by Zsombor Rajki on 2019. 05. 03..
//  Copyright © 2019. Zsombor Rajki. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistDetailTableViewController: PlaylistsTableViewController{
    
    public let myMusicPlayer = (UIApplication.shared.delegate as! AppDelegate).mySystemPlayer
    var playlist: MPMediaItemCollection?
    //var previousSong: MPMediaItem?
    var mediaValues: [MPMediaItem]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaValues = playlist.map{$0.items}
        tableView.rowHeight = 70.0;
        tableView.register(UINib.init(nibName: "SingleCellView", bundle: nil), forCellReuseIdentifier: "SingleCellView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        myMusicPlayer.systemPlayer.setQueue(with: playlist!)
        
        if let title = playlist?.value(forProperty: MPMediaPlaylistPropertyName) {
            self.navigationItem.title = title as? String
        }
    }
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        if mediaValues != nil {
            return 1
        } else {
            return super.numberOfSections(in: tableView)
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let mediaItems = mediaValues {
            return mediaItems.count
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
            
        }
    }
    override func tableView( _ tableView: UITableView, cellForRowAt indexPath:IndexPath ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleCellView", for: indexPath) as! SongTableViewCell
        if let pl = mediaValues?[indexPath.row]{
            cell.musicTitleLabel.text = pl.title
            cell.musicDescLabel.text = pl.artist
            if let image : MPMediaItemArtwork = pl.artwork{
            cell.miniImageView.image = image.image(at: cell.miniImageView.frame.size)
            }
            if let asd: Int = (pl.value(forProperty: MPMediaItemPropertyHasProtectedAsset) as? Int){
                if asd == 1 {
                    cell.amLabel.isHidden = false
                }else {
                    cell.amLabel.isHidden = true
                }
            }
            if let asd: Bool = (pl.value(forProperty: MPMediaItemPropertyIsExplicit) as? Bool){
                if asd == true {
                    cell.explicitLabel.isHidden = false
                }else {
                    cell.explicitLabel.isHidden = true
                }
            }
            
        }
        
        return cell
    }
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedMedia = mediaValues?[indexPath.row]{
            self.myMusicPlayer.systemPlayer.nowPlayingItem = selectedMedia
            self.myMusicPlayer.systemPlayer.prepareToPlay()
            self.myMusicPlayer.play()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

