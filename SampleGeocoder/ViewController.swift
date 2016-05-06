//
//  ViewController.swift
//  SampleGeocoder
//
//  Created by cat-08 on 2016/05/07.
//  Copyright © 2016年 cat-08. All rights reserved.
//

import UIKit
import MapKit


// [概要][iOS8以降用]
// ・Mapkit.framework 追加
// ・import MapKit 追加
//
// Info.plist に以下の何れかの Key を追加、Value には表示するときの文言を記述（空でもよい）
// このキーは [設定] - [プライバシー] - [位置情報サービス] - [アプリ] に表示される
// ・使用中のみ許可   NSLocationWhenInUseUsageDescription
// ・常に許可        NSLocationAlwaysUsageDescription
//
// 以下のメソッドをコール
// ・CLLocationManager#requestAlwaysAuthorization -> 位置情報の使用を常に許可してもらう要求を表示する
// ・CLLocationManager#requestWhenInUseAuthorization -> 位置情報の使用をアプリ起動時のみ許可してもらう要求を表示する


// 位置情報ステータス文言
private enum LocationAuthStatusString {
    case NotDetermined
    case Restricted
    case Denied
    case AuthorizedAlways
    case AuthorizedWhenInUse
    
    var toString : String {
        switch self {
        case .NotDetermined:
            return "まだ使用可否を決定していない"
        case .Restricted:
            return "制限されている"
        case .Denied:
            // [設定] - [プライバシー] - [位置情報サービス] - [アプリ] から変更しないといけない
            return "許可しない"
        case .AuthorizedAlways:
            return "常に許可"
        case .AuthorizedWhenInUse:
            return "アプリ使用中のみ"
        }
    }
    
}


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var statusLabel: UILabel!
    
    // strong で保持しないといけない（CLLocationManager ドキュメント参照）
    var manager: CLLocationManager? = nil
    
    
    // MARK: - ライフサイクルイベント
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.manager = CLLocationManager()
        self.manager?.delegate = self
        self.manager?.desiredAccuracy = kCLLocationAccuracyBest
        self.manager?.distanceFilter = 100.0
        
        
        // 現在位置の使用状態を表示
        self.showLocationStatusLabel()
        
        // まだ現在位置の使用可否を指定していない場合
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            // 現在位置を使用するかどうかの応答を行う
            self.manager?.requestWhenInUseAuthorization()
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - CLLocationManager.delegate
    
    // 現在位置サービスのステータス変更時
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        // 現在位置の使用状態を表示
        self.showLocationStatusLabel()
        
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            // マップの中心に現在位置を表示
            self.showLocationForMap()
        }
        
    }
    
    //
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        
    }
    
    
    // MARK: - ボタンイベント
    
    // 現在位置ボタンタップ時
    @IBAction func locationButtonAction(sender: UIButton) {
        print("locationButtonAction")
        
        // マップの中心に現在位置を表示
        self.showLocationForMap()
    }
    
    
    // MARK: - private method
    
    // マップの中心に現在位置を表示
    func showLocationForMap() {
        
        self.mapView.showsUserLocation = true
        self.mapView.setUserTrackingMode(.Follow, animated: true)
    }
    
    // 現在位置の使用状態を表示
    func showLocationStatusLabel() {
        
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            self.statusLabel.text = LocationAuthStatusString.NotDetermined.toString
        case .Restricted:
            self.statusLabel.text = LocationAuthStatusString.Restricted.toString
        case .Denied:
            self.statusLabel.text = LocationAuthStatusString.Denied.toString
        case .AuthorizedAlways:
            self.statusLabel.text = LocationAuthStatusString.AuthorizedAlways.toString
        case .AuthorizedWhenInUse:
            self.statusLabel.text = LocationAuthStatusString.AuthorizedWhenInUse.toString
        }
        
    }
    
}

