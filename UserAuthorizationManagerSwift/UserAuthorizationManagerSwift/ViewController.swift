//
//  ViewController.swift
//  UserAuthorizationManagerSwift
//
//  Created by mini on 2023/12/12.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        firstButton.setTitle("檢查相機", for: .normal)
        secondButton.setTitle("檢查麥克風", for: .normal)
        thirdButton.setTitle("檢查系統相簿存取權限", for: .normal)
        
//        async '' used in a context that does not support concurrency
        
//        UserAuthorizationManager.getAuthorize()
        
        checkCamera()
        
        switch UserAuthorizationManager.checkAllAuthorize() {
        case .allAuthorized:
            break
        case .hasDetermined:
            UserAuthorizationManager.getAuthorize()
        case .hasDenied(
            _,
            _,
            _
        ):
            break
        case .hasRestricted(
            _,
            _,
            _
        ):
            break
        case .libraryLimited:
            break
        }
        
    }
    

    func checkCamera() {
        Task {
            let requestResult = await UserAuthorizationManager.checkCameraAuthorize()
            await showToast(message: requestResult ? "已開啟" : "未開啟") {
                debugPrint("requestResult :\(requestResult)")
            }
        }
    }
    
    func checkMic() {
        Task {
            let requestResult = UserAuthorizationManager.checkAudioAuthorize()
            var msg = ""
            switch requestResult {
            case .notDetermined:
                msg = "notDetermined"
            case .restricted:
                msg = "restricted"
            case .denied:
                msg = "denied"
            case .authorized:
                msg = "authorized"
            @unknown default:
                fatalError()
            }
            await showToast(message: msg) {
                debugPrint("requestResult :\(requestResult)")
            }
        }
    }
    
    func checkLibrary() {
        Task {
            let requestResult = UserAuthorizationManager.checkLibraryAuthorize()
            var msg = ""
            switch requestResult {
            case .notDetermined:
                msg = "notDetermined"
            case .restricted:
                msg = "restricted"
            case .denied:
                msg = "denied"
            case .authorized:
                msg = "authorized"
            case .limited:
                msg = "limited"
            @unknown default:
                fatalError()
            }
            await showToast(message: msg) {
                debugPrint("requestResult :\(requestResult)")
            }
        }
    }
    
    @MainActor
    func showToast(message: String?, completionHandler: @escaping () -> Void) async {
        Task.detached {
            let alert = await UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
            await UIApplication.shared.nowkeyWindow?.rootViewController?.present(alert, animated: true) {
                sleep(1)
                Task { @MainActor in alert.dismiss(animated: true) {
                    completionHandler()
                } }
            }
        }
    }
    
    @IBAction func firstBtnPressed(_ sender: Any) {
        checkCamera()
    }
    
    @IBAction func secondBtnPressed(_ sender: Any) {
        checkMic()
    }
    
    @IBAction func thirdBtnPressed(_ sender: Any) {
        checkLibrary()
    }
    
}

