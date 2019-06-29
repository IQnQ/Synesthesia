//
//  PlayerViewController.swift
//  Synesthesia
//
//  Created by Zsombor Rajki on 2019. 04. 30..
//  Copyright © 2019. Zsombor Rajki. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var mediaArtworkImage: UIImageView!
    @IBOutlet weak var timeSpentLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var parentVolumeView: UIView!
    
    
    
    private let myMusicPlayer = (UIApplication.shared.delegate as! AppDelegate).mySystemPlayer.systemPlayer
    private let myMusicFunctions = (UIApplication.shared.delegate as! AppDelegate).mySystemPlayer
     var timer: Timer?
    
    var engine = AVAudioEngine()
    var player = AVAudioPlayerNode()
    var updater: CADisplayLink?
    var mySpectrumView: SpectrumView?
    
    
    lazy var playPauseBarButtonItem: UIBarButtonItem = {
        let button = PlayerActionButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.addTarget(self, action: #selector(playPauseButtonClicked(_:)), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "small-play"), for: .normal)
        let buttonItem = UIBarButtonItem(customView: button)
        
        return buttonItem
    }()
    lazy var PauseBarButtonItem: UIBarButtonItem = {
        let button = PlayerActionButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.addTarget(self, action: #selector(playPauseButtonClicked(_:)), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "small-pause"), for: .normal)
        let buttonItem = UIBarButtonItem(customView: button)
        
        return buttonItem
    }()
    
    lazy var forwardBarButtonItem: UIBarButtonItem = {
        let button = PlayerActionButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.addTarget(self, action: #selector(nextButtonTap(_:)), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "fast-forward"), for: .normal)
        let buttonItem = UIBarButtonItem(customView: button)
        return buttonItem
    }()
    
    lazy var volumeSliderView: MPVolumeView = {
        let view = MPVolumeView(frame: self.parentVolumeView.bounds)
        view.showsRouteButton = true
        view.showsVolumeSlider = true
        view.tintColor = #colorLiteral(red: 1, green: 0.4274770617, blue: 0.9901534915, alpha: 1)

        return view
    }()
    
    var mediaItems: [MPMediaItem]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressSlider.tintColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        self.popupItem.leftBarButtonItems = [playPauseBarButtonItem]
        self.popupItem.rightBarButtonItems = [forwardBarButtonItem]
        parentVolumeView.addSubview(volumeSliderView)
        updateStuff()
        setupNotifications()
        //myMusicPlayer.setQueue(with: MPMediaQuery.songs())
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //do {try changeAudioPlayer()}catch {print("sdf")}
        
        super.viewWillAppear(true)
        updateStuff()

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func updateStuff(){
        updateSlider()
        updateLabels()
        updatePlayPauseButton()
        updateNowPlayingItem() 
        updatePopupBarData(with: myMusicPlayer.nowPlayingItem)
        updateShuffleMode()
        updateReapeatMode()
        
    }
    
    
    
     func updatePopupBarData(with item: MPMediaItem?) {
        guard let item = item else {
            popupItem.setDefaults()
            return
        }
        if let artwork = item.artwork?.image(at: self.popupBar.imageView.frame.size) {
            self.popupItem.image = artwork
        }
        
        self.popupItem.subtitle = item.artist
        self.popupItem.title = item.title ?? ""
    }
    


    @IBAction func playPauseButtonClicked(_ sender: PlayerActionButton) {
        sender.onClickAnimation()
         myMusicFunctions.playOrPause()

    }
    @IBAction func playButtonTap(_ sender: Any) {
        myMusicFunctions.playOrPause()
        //engine.attach()
    }
    @IBAction func nextButtonTap(_ sender: PlayerActionButton) {
        myMusicFunctions.forward()
        self.updateNowPlayingItem()
    }
    @IBAction func prevButtonTap(_ sender: PlayerActionButton) {
        myMusicFunctions.backward()
        self.updateNowPlayingItem()
    }
    @IBAction func shuffleButtonTap(_ sender: Any) {
       updateShuffleMode()
    }
    @IBAction func repeatButtonTap(_ sender: Any) {
        updateReapeatMode()
    }
    
    
}
extension PlayerViewController {
    
        @objc func nowPlayingChanged(notification: NSNotification) {
            updateNowPlayingItem()
            updatePopupBarData(with: myMusicPlayer.nowPlayingItem)
        }
        
        @objc func playbackStateChanged(notification: NSNotification) {
            updatePlayPauseButton()
        }
        
        func setupNotifications() {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.nowPlayingChanged(notification:)),
                name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.playbackStateChanged(notification:)),
                name: .MPMusicPlayerControllerPlaybackStateDidChange,
                object: nil)
        }
        
    func updateSlider() {
            if let duration = myMusicPlayer.nowPlayingItem?.playbackDuration {
                progressSlider.value = Float(myMusicPlayer.currentPlaybackTime / duration)
                self.popupItem.progress = progressSlider.value
                
            }
        }
    func updateLabels(){
        let conv = Time()
        if let duration = myMusicPlayer.nowPlayingItem?.playbackDuration{
        timeSpentLabel.text = conv.convertToString(time: Float(myMusicPlayer.currentPlaybackTime))
            timeLeftLabel.text = "-\(conv.convertToString(time: Float(duration) - Float(myMusicPlayer.currentPlaybackTime)))"
        }
    }
    func updateSliderTimer() {
            if let t = timer {
                t.invalidate()
            }
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] _ in self?.updateSlider() }
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in self?.updateLabels() }
        }
    
    func stopTimer(){
        if let t = timer {
            t.invalidate()
        }
    }
    func updateNowPlayingItem(){
        songLabel.text = myMusicPlayer.nowPlayingItem?.title
        artistLabel.text = myMusicPlayer.nowPlayingItem?.artist
        mediaArtworkImage.image = myMusicPlayer.nowPlayingItem?.artwork?.image(at: mediaArtworkImage.frame.size)
        
    }
    func updatePlayPauseButton(){
        switch myMusicPlayer.playbackState {
        case .playing:
            updateSliderTimer()
             self.popupItem.leftBarButtonItems = [PauseBarButtonItem]
            playButton.setImage(#imageLiteral(resourceName: "18444656"), for: .normal)
        case .stopped , .paused, .interrupted, .seekingForward, .seekingBackward:
            stopTimer()
             self.popupItem.leftBarButtonItems = [playPauseBarButtonItem]
            playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        default:
            print("Could not read playbackState")
        }
    }
    func updateShuffleMode() {
        if (myMusicPlayer.shuffleMode == .off){
            shuffleButton.setTitle("Shuffle\nON", for: .normal)
            myMusicPlayer.shuffleMode = .songs
            
        }else {
            myMusicPlayer.shuffleMode = .off
            shuffleButton.setTitle("Shuffle\nOFF", for: .normal)
        }
    }
    func updateReapeatMode(){
        switch myMusicPlayer.repeatMode {
        case .none:
            repeatButton.setTitle("Repeat\none", for: .normal)
            myMusicPlayer.repeatMode = .one
        case .one:
            repeatButton.setTitle("Repeat\nall", for: .normal)
            myMusicPlayer.repeatMode = .all
        case .all , .default :
            repeatButton.setTitle("Repeat\nnone", for: .normal)
            myMusicPlayer.repeatMode = .none

        @unknown default: break
            
        }
    }
    
    /*func changeAudioPlayer() throws {
        
        let file =  myMusicPlayer.nowPlayingItem?.value(forProperty: MPMediaItemPropertyAssetURL) as? URL
        let audioFile = try AVAudioFile(forReading: file!)
        
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: nil)
        //let format = engine.mainMixerNode.outputFormat(forBus: 0)
            
                player.scheduleFile(audioFile, at:nil)
        engine.prepare()
        try engine.start()
        engine.mainMixerNode.installTap(onBus: 0, bufferSize: 1024, format: nil) { buffer, when in
            let channelData = buffer.floatChannelData
            let asd = self.mySpectrumView?.rmsFromBuffer(data: channelData!.pointee, buffer: buffer)
            print(asd)
        }
    }*/
    func audioSettingMethod(){
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        }
        catch let error
        {
            print("Error:\(error)")
        }
        do
        {
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error
        {
            print("Error:\(error)")
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    
}


