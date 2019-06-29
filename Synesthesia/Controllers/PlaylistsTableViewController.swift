//
//  PlaylistsTableViewController.swift
//  Synesthesia
//
//  Created by Zsombor Rajki on 2019. 05. 03..
//  Copyright © 2019. Zsombor Rajki. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistsTableViewController : TableViewWithMusicPlayerBarTableViewController {
        private let myMusicPlayer = (UIApplication.shared.delegate as! AppDelegate).mySystemPlayer
    
    var mediaItems: [MPMediaItemCollection]? {
        didSet{
            tableView.reloadData()
        }
    }
    private let listSegue = "List Playlists"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let playlists = myMusicPlayer.queryPlaylist(){
            self.mediaItems = playlists
        }
        tableView.rowHeight = 140.0
        tableView.register(UINib.init(nibName: "PlaylistCellView", bundle: nil), forCellReuseIdentifier: "PlaylistCellView")
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        if mediaItems != nil {
            return 1
        } else {
            return super.numberOfSections(in: tableView)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let mediaItems = mediaItems {
            return mediaItems.count
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
            
        }
    }
    override func tableView( _ tableView: UITableView, cellForRowAt indexPath:IndexPath ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCellView", for: indexPath) as! PlaylistCellView
        let mediaItem = mediaItems?[indexPath.row]
        cell.playlistTitleLabel.text = mediaItem?.value(forProperty: MPMediaPlaylistPropertyName)! as? String
        if let desc = mediaItem?.value(forProperty: MPMediaPlaylistPropertyAuthorDisplayName){
            cell.playlistAuthorLabel.text = desc as? String
        }
        
        if let image : MPMediaItemArtwork = mediaItem?.items.first?.artwork{
            cell.playlistImage.image = image.image(at: cell.playlistImage.frame.size)
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (mediaItems?[indexPath.row]) != nil{
            self.performSegue(withIdentifier: "test", sender: nil)
        }
        DispatchQueue.main.async {
            tableView.deselectRow(at: indexPath, animated: true)

        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let listSongsplaylistTableView = segue.destination as? PlaylistDetailTableViewController else {return}
            let indexPath = tableView.indexPathForSelectedRow
            let item = mediaItems?[(indexPath?.row)!]
            listSongsplaylistTableView.playlist = item
    }
    
}
