//
//  File.swift
//  smart
//
//  Created by mini on 2022/10/21.
//

import Photos
import Foundation

/**
 * UserAuthorizationManager 系統相簿、相機及語音的授權請求
 *
 * 需在lnfo.plist增加各項授權
 *  `相機`
 *  -Privacy - Camera Usage Description - (敘述 ex. 拍攝照片及掃描QRCode時將使用您的相機)
 *  `麥克風
 *  -Privacy - Microphone Usage Description - (敘述 ex. 影片錄製時將使用您的麥克風)
 *  `相簿`
 *  -Privacy - Media Library Usage Description - (敘述 ex. 新增影片時將使用您的相簿)
 *  -Privacy - Photo Library Additions Usage Description - (敘述 ex. 新增照片或更換頭像時將使用您的相簿)
 *  -Privacy - Photo Library Usage Description - (敘述 ex. 新增照片或更換頭像時將使用您的相簿)
 */

struct UserAuthorizationManager {
    
    /**
     * enum State
     * case allAuthorized   相機、語音及相簿都允許
     * hasDetermined        相機、語音及相簿其中有 `未決定授權方式`
     * hasDenied               相機、語音及相簿其中有 `拒絕授權` -
     * hasRestricted          相機、語音及相簿其中有 `主動限制`(如 家長控制)
     * libraryLimited           相機、語音及相簿其中有 `相簿張數限制`
     */
    
    enum State {
        case allAuthorized
        case hasDetermined
        case hasDenied(
            photoAuthorize: PHAuthorizationStatus,
            cameraAuthorize: AVAuthorizationStatus,
            audioAuthorize: AVAuthorizationStatus
        )
        case hasRestricted(
            photoAuthorize: PHAuthorizationStatus,
            cameraAuthorize: AVAuthorizationStatus,
            audioAuthorize: AVAuthorizationStatus
        )
        case libraryLimited
    }
    
    private let cameraAuthorizeHint: String = "您尚未開啟使用相機權限，請前往設定開啟"
    private let libraryAuthorizeHint: String = "您尚未開啟使用系統相簿權限，請前往設定開啟"
    private let audioAuthorizeHint: String = "您尚未開啟使用語音權限，請前往設定開啟"
    
    /**
     * 依序取得相機、錄音、相簿授權
     */
    public static func getAuthorize(){
        AVCaptureDevice.requestAccess(for: .video) { (status) in
            AVCaptureDevice.requestAccess(for: .audio) { (status) in
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in }
            }
        }
    }
    
    /**
     * 取得授權狀態
     */
    public static func checkAllAuthorize() -> State {
        let photoLibraryStatus = PHPhotoLibrary.authorizationStatus()
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let audioStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        
        switch (photoLibraryStatus, cameraStatus, audioStatus) {
        case (.authorized, .authorized, .authorized):
            return .allAuthorized
        case (.notDetermined, _, _):
            return .hasDetermined
        case (_, .notDetermined, _):
            return .hasDetermined
        case (_, _, .notDetermined):
            return .hasDetermined
        case (.denied, _, _):
            return .hasDenied(
                photoAuthorize: photoLibraryStatus,
                cameraAuthorize: cameraStatus,
                audioAuthorize: audioStatus
            )
        case (_, .denied, _):
            return .hasDenied(
                photoAuthorize: photoLibraryStatus,
                cameraAuthorize: cameraStatus,
                audioAuthorize: audioStatus
            )
        case (_, _, .denied):
            return .hasDenied(
                photoAuthorize: photoLibraryStatus,
                cameraAuthorize: cameraStatus,
                audioAuthorize: audioStatus
            )
        case (.restricted, _, _):
            return .hasRestricted(
                photoAuthorize: photoLibraryStatus,
                cameraAuthorize: cameraStatus,
                audioAuthorize: audioStatus
            )
        case (_, .restricted, _):
            return .hasRestricted(
                photoAuthorize: photoLibraryStatus,
                cameraAuthorize: cameraStatus,
                audioAuthorize: audioStatus
            )
        case (_, _, .restricted):
            return .hasRestricted(
                photoAuthorize: photoLibraryStatus,
                cameraAuthorize: cameraStatus,
                audioAuthorize: audioStatus
            )
        case (.limited, _, _):
            return .libraryLimited
        default:
            return .allAuthorized
        }
    }
    
    public static func checkCameraAuthorize() async -> Bool {
        return await AVCaptureDevice.requestAccess(for: .video)
    }
    
    public static func checkAudioAuthorize() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .audio)
    }
    
    public static func checkLibraryAuthorize() -> PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
}
