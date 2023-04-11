//
//  RPConstants.swift
//  Constants used in Recipesto

import UIKit

enum EndPoint {
    static let baseURL = URL(string: "https://tasty.p.rapidapi.com/")!

    case browse
    case swipe(tags: String)
    case search(tags: String, searchText: String)

    var url: URL {
        switch self {
            case .browse:
            return EndPoint.baseURL.appendingPathComponent(
                "feeds/list?size=5&timezone=%2B0500&vegetarian=false&from=0"
            )
            case .swipe(let tags):
            return EndPoint.baseURL.appendingPathComponent(
                "recipes/list?from=0&size=20&tags=\(tags)"
            )
            case .search(let tags, let searchText):
            return EndPoint.baseURL.appendingPathComponent(
                "recipes/list?from=0&size=20&tags=\(tags)&q=\(searchText)"
            )
        }
    }
}

enum SFSymbols {
    static let heart = UIImage(systemName: "heart")
    static let filledHeart = UIImage(systemName: "heart.fill")
    static let xMark = UIImage(systemName: "x.circle.fill")
}

enum Images {
    static let placeholder = UIImage(systemName: "fork.knife.circle.fill")
}

enum Colors {
    static let RPGreen = UIColor(displayP3Red: 151/255, green: 198/255, blue: 86/255, alpha: 1)
}

enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}

enum DeviceTypes {
    static let idiom = UIDevice.current.userInterfaceIdiom
    static let nativeScale = UIScreen.main.nativeScale
    static let scale = UIScreen.main.scale

    static let isiPhoneSE = idiom == .phone && ScreenSize.maxLength == 667.0
    static let isiPhone8Standard = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard = idiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhone8PlusZoomed = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
    static let isiPhoneX = idiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPhoneXsMaxAndXr = idiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPad = idiom == .pad && ScreenSize.maxLength >= 1024.0

    static func isiPhoneXAspectRatio() -> Bool {
        return isiPhoneX || isiPhoneXsMaxAndXr
    }
}
