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
            if !requestResult {
                await showToast(message: "test") {
                    UIApplication.shared.nowkeyWindow?.rootViewController?.dismiss(animated: true)
                }
            } else {
                await showToast(message: "test") {
                    UIApplication.shared.nowkeyWindow?.rootViewController?.dismiss(animated: true)
                }
            }
        }
    }
    
    @MainActor
    func showToast(message: String?, completionHandler: @escaping () -> Void) async {
        await Task.detached {
            let alert = await UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
            await UIApplication.shared.nowkeyWindow?.rootViewController?.present(alert, animated: true) {
                completionHandler()
            }
        }
        
        
    }
    
    @IBAction func firstBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func secondBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func thirdBtnPressed(_ sender: Any) {
        
    }
    
}

