//
//  SystemPlayer.swift
//  Synesthesia
//
//  Created by Zsombor Rajki on 2019. 04. 27..
//

import Foundation
import MediaPlayer

class SystemPlayer {
    let systemPlayer = MPMusicPlayerController.systemMusicPlayer
    
    func addSongsToQueue() {
        systemPlayer.setQueue(with: MPMediaQuery.songs())
    }
    
    enum MediaType {
        case artist
        case album
    }
    
    enum Queries {
        case artists
        case songs
        case albums
    }
    
    func query(_ type: Queries) -> [MPMediaItem]? {
        switch type {
        case .songs:
            return MPMediaQuery.songs().items
        case .artists:
            if let collections = MPMediaQuery.artists().collections {
                let items = collections.map({$0.items[0]})
                return items
            } else {
                return []
            }
        case .albums:
            if let collections = MPMediaQuery.albums().collections {
                let items = collections.map({$0.items[0]})
                return items
            } else {
                return []
            }
        }
    }
    func queryPlaylist() -> [MPMediaItemCollection]?{
        return MPMediaQuery.playlists().collections
    }
    
    
    func songsByArtist(_ artist: String) -> [MPMediaItem]? {
        let songsByArtists = MPMediaQuery.artists().collections
        let songsByArtist = songsByArtists?.filter({ $0.items[0].artist == artist })
        return songsByArtist?[0].items
    }
    
    func songsByAlbum(_ album: String) -> [MPMediaItem]? {
        let songsByAlbums = MPMediaQuery.albums().collections
        let songsByAlbum = songsByAlbums?.filter({ $0.items[0].albumTitle == album })
        return songsByAlbum?[0].items
    }
    
    

    func play() {

        systemPlayer.play()
    }
    
    func pause() {
        systemPlayer.pause()
    }
    
    func playOrPause() {
        switch (systemPlayer.playbackState) {
        case .paused:
            print("was paused, now playing")
            play()
        case .playing:
            print("was playing, now pausing")
            pause()
        default: ()
        }
    }
    
    func forward() {
        systemPlayer.skipToNextItem()
    }
    
    func backward() {
        systemPlayer.skipToPreviousItem()
    }
    
    func cycleRepeatMode() {
        systemPlayer.repeatMode = MPMusicRepeatMode(rawValue: systemPlayer.repeatMode.rawValue%4+1)!
        print(systemPlayer.repeatMode)
    }
    
    func cycleShuffleMode() {
        systemPlayer.shuffleMode = MPMusicShuffleMode(rawValue: systemPlayer.shuffleMode.rawValue%4+1)!
        print(systemPlayer.shuffleMode)
    }
    
}

