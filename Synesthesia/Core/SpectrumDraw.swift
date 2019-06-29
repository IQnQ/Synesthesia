//
//  SpectrumDraw.swift
//  Synesthesia
//
//  Created by Zsombor Rajki on 2019. 04. 20..
//  Copyright © 2019. Razeware. All rights reserved.
//

import Foundation
import UIKit
import Accelerate
import AVFoundation

class SpectrumView: UIView {
    
    var spectrumArray = [Float](repeating: 0.0, count: 65)
    var slowSpectrumArray = [Float](repeating: 0.0, count: 65)
    var reducedArray = [Float](repeating: 0.0, count: 65)
    
    var minx : Float =  1.0e12
    var maxx : Float = -1.0e12
    let minDb: Float = -80.0
    
    override func draw(_ rect: CGRect) {
        let context : CGContext! = UIGraphicsGetCurrentContext()
        let r0 : CGRect!            = self.bounds
        if true {                                    // ** Rect **
            context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        }
        self.backgroundColor = .clear
        let n = 32
        let array = spectrumArray
        //print(spectrumArray.count)
        let r : Float = 0.25
        for i in 0 ..< n {
            slowSpectrumArray[i] = r * array[i] + (1.0 - r) * slowSpectrumArray[i]
        }
        context.setFillColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 0.3);
        let h0 = CGFloat(r0.size.height)
        let dx = (r0.size.width) / CGFloat(n)
        if array.count >= n {
            for i in 0 ..< n  {
                let y = h0 * CGFloat(1.0 - slowSpectrumArray[i])
                let x = r0.origin.x + CGFloat(i) * dx
                let h = h0 - y
                let w = dx
                let r1  = CGRect(x: x , y: y, width: w, height: h)
                context.stroke(r1)
                context.setStrokeColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1);
                context.fill(r1)
            }
        }
    }
    
    func transform(buffer: AVAudioPCMBuffer) -> [Float] {
        let frameCount = buffer.frameLength
        let log2n = UInt(round(log2(Double(frameCount))))
        let bufferSizePOT = Int(1 << log2n)
        let inputCount = bufferSizePOT / 2
        let fftSetup = vDSP_create_fftsetup(log2n, Int32(kFFTRadix2))
        
        var realp = [Float](repeating: 0, count: inputCount)
        var imagp = [Float](repeating: 0, count: inputCount)
        var output = DSPSplitComplex(realp: &realp, imagp: &imagp)
        
        let windowSize = bufferSizePOT
        var transferBuffer = [Float](repeating: 0, count: windowSize)
        var window = [Float](repeating: 0, count: windowSize)
        
        vDSP_hann_window(&window, vDSP_Length(windowSize), Int32(vDSP_HANN_NORM))
        vDSP_vmul((buffer.floatChannelData?.pointee)!, 1, window,
                  1, &transferBuffer, 1, vDSP_Length(windowSize))
        
        let temp = UnsafePointer<Float>(transferBuffer)
        
        temp.withMemoryRebound(to: DSPComplex.self, capacity: transferBuffer.count) { (typeConvertedTransferBuffer) -> Void in
            vDSP_ctoz(typeConvertedTransferBuffer, 2, &output, 1, vDSP_Length(inputCount))
        }
        
        vDSP_fft_zrip(fftSetup!, &output, 1, log2n, FFTDirection(FFT_FORWARD))
        
        var magnitudes = [Float](repeating: 0.0, count: inputCount)
        vDSP_zvmags(&output, 1, &magnitudes, 1, vDSP_Length(inputCount))
        
        var normalizedMagnitudes = [Float](repeating: 0.0, count: inputCount)
        vDSP_vsmul(sqrtq(magnitudes), 1, [2.0 / Float(inputCount)],
                   &normalizedMagnitudes, 1, vDSP_Length(inputCount))
        let buffer =  normalizedMagnitudes
        
        vDSP_destroy_fftsetup(fftSetup)
        return buffer
        
    }

    
    func makeSpectrumFromAudio(buffer: AVAudioPCMBuffer) {
        let array = transform(buffer: buffer)
        var i = 0
        var count = 0
        
        while ( i < 2048) {
            if i < array.count {
                var total: Float?
                for j in 0..<64{
                    reducedArray[j] = array[i]
                    i += 1
                    if j == 63{
                        total = self.redu(array: reducedArray)
                        break
                    }
                    else { continue }
                
                }
                var x = total! * Float(i)

                if x > maxx { maxx = x }
                if x < minx { minx = x }
                var y : Float = 0.0
                if (x > minx) {
                    if (x < 1.0) { x = 1.0 }
                    let r = (logf(maxx - minx) - logf(1.0)) * 1.0
                    let u = (logf(x    - minx) - logf(1.0))
                    y = u / r
                }
                
                count += 1
                spectrumArray[count] = y
            }
            
        }
    }
    
    func sqrtq(_ x: [Float]) -> [Float] {
        var results = [Float](repeating: 0.0, count: x.count)
        vvsqrtf(&results, x, [Int32(x.count)])
        
        return results
    }
    
    func redu (array: [Float]) -> Float{
        let float = array.reduce(0, +)
        return float
    }
    
    func rmsFromBuffer(data: UnsafeMutablePointer<Float> , buffer: AVAudioPCMBuffer) -> Float {
        let channelDataValueArray = stride(from: 0,
                                           to: Int(buffer.frameLength),
                                           by: buffer.stride).map{ data[$0] }
        let rms = channelDataValueArray.map{ $0 * $0 }.reduce(0, +) / Float(buffer.frameLength)
        let didsqrtrms =  sqrt(rms)
        let avgPower = 20 * log10(didsqrtrms)
        return self.scaledPower(power: avgPower)
        
    }
    
    func scaledPower(power: Float) -> Float {
        guard power.isFinite else { return 0.0 }
        
        if power < minDb {
            return 0.0
        } else if power >= 1.0 {
            return 1.0
        } else {
            return (abs(minDb) - abs(power)) / abs(minDb)
        }
    }
}

