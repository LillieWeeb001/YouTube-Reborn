import Foundation
import Orion
import UIKit
import YouTubeRebornC

// Video Options

// Enable No Ads
struct EnableNoAds: HookGroup {}

class EnableNoAds1: ClassHook<NSObject> { // Check Type
    static let targetName = "YTIPlayerResponse"
    typealias Group = EnableNoAds

    func isMonetized() -> Bool {
        return false
    }
}
class EnableNoAds2: ClassHook<NSObject> { // Check Type
    static let targetName = "YTDataUtils"
    typealias Group = EnableNoAds

    class func spamSignalsDictionary() -> Any? {
        return nil
    }
    class func spamSignalsDictionaryWithoutIDFA() -> Any? {
        return nil
    }
}
class EnableNoAds3: ClassHook<NSObject> { // Check Type
    static let targetName = "YTAdsInnerTubeContextDecorator"
    typealias Group = EnableNoAds

    func decorateContext(_ arg1: Any?) {
    }
}
class EnableNoAds4: ClassHook<NSObject> { // Check Type
    static let targetName = "YTAccountScopedAdsInnerTubeContextDecorator"
    typealias Group = EnableNoAds

    func decorateContext(_ arg1: Any?) {
    }
}

// Enable Background Playback
struct EnableBackgroundPlayback: HookGroup {}

class EnableBackgroundPlayback1: ClassHook<NSObject> { // Check Type
    static let targetName = "YTIPlayerResponse"
    typealias Group = EnableBackgroundPlayback

    func isPlayableInBackground() -> Bool {
        return true
    }
}
class EnableBackgroundPlayback2: ClassHook<NSObject> { // Check Type
    static let targetName = "YTSingleVideo"
    typealias Group = EnableBackgroundPlayback

    func isPlayableInBackground() -> Bool {
        return true
    }
}
class EnableBackgroundPlayback3: ClassHook<NSObject> { // Check Type
    static let targetName = "YTSingleVideoMediaData"
    typealias Group = EnableBackgroundPlayback

    func isPlayableInBackground() -> Bool {
        return true
    }
}
class EnableBackgroundPlayback4: ClassHook<NSObject> { // Check Type
    static let targetName = "YTPlaybackData"
    typealias Group = EnableBackgroundPlayback

    func isPlayableInBackground() -> Bool {
        return true
    }
}
class EnableBackgroundPlayback5: ClassHook<NSObject> { // Check Type
    static let targetName = "YTIPlayabilityStatus"
    typealias Group = EnableBackgroundPlayback

    func isPlayableInBackground() -> Bool {
        return true
    }
}
class EnableBackgroundPlayback6: ClassHook<NSObject> { // Check Type
    static let targetName = "YTPlaybackBackgroundTaskController"
    typealias Group = EnableBackgroundPlayback

    func isContentPlayableInBackground() -> Bool {
        return true
    }
    func setContentPlayableInBackground(_ arg1: Bool) {
        orig.setContentPlayableInBackground(true)
    }
}
class EnableBackgroundPlayback7: ClassHook<NSObject> { // Check Type
    static let targetName = "YTBackgroundabilityPolicy"
    typealias Group = EnableBackgroundPlayback

    func isBackgroundableByUserSettings() -> Bool {
        return true
    }
}

// Allow HD On Cellular Data
struct AllowHDOnCellularData: HookGroup {}

class AllowHDOnCellularData1: ClassHook<NSObject> {
    static let targetName = "YTUserDefaults"
    typealias Group = AllowHDOnCellularData

    func disableHDOnCellular() -> Bool {
        return false
    }
    func setDisableHDOnCellular(_ arg1: Bool) {
        orig.setDisableHDOnCellular(false)
    }
}
class AllowHDOnCellularData2: ClassHook<NSObject> {
    static let targetName = "YTSettings"
    typealias Group = AllowHDOnCellularData

    func disableHDOnCellular() -> Bool {
        return false
    }
    func setDisableHDOnCellular(_ arg1: Bool) {
        orig.setDisableHDOnCellular(false)
    }
}

// Disable Video AutoPlay
struct DisableVideoAutoPlay: HookGroup {}

class DisableVideoAutoPlay1: ClassHook<NSObject> { // Check Type
    static let targetName = "YTPlaybackConfig"
    typealias Group = DisableVideoAutoPlay

    func setStartPlayback(_ arg1: Bool) {
        orig.setStartPlayback(false)
    }
}

// Hide Player Bar Heatwave
struct HidePlayerBarHeatwave: HookGroup {}

class HidePlayerBarHeatwave1: ClassHook<NSObject> { // Check Type
    static let targetName = "YTPlayerBarHeatwaveView"
    typealias Group = HidePlayerBarHeatwave

    func initWithFrame(_ arg1: CGRect, heatmap arg2: Any?) -> Any? {
        return nil
    }
}
class HidePlayerBarHeatwave2: ClassHook<NSObject> { // Check Type
    static let targetName = "YTPlayerBarController"
    typealias Group = HidePlayerBarHeatwave

    func setHeatmap(_ arg1: Any?) {
        orig.setHeatmap(nil)
    }
}

// Disable Double Tap To Skip
struct DisableDoubleTapToSkip: HookGroup {}

class DisableDoubleTapToSkip1: ClassHook<NSObject> {
    static let targetName = "YTDoubleTapToSeekController"
    typealias Group = DisableDoubleTapToSkip

    func enableDoubleTapToSeek(_ arg1: Bool) {
        orig.enableDoubleTapToSeek(false)
    }
    func showDoubleTapToSeekEducationView(_ arg1: Bool) {
        orig.showDoubleTapToSeekEducationView(false)
    }
}
class DisableDoubleTapToSkip2: ClassHook<NSObject> {
    static let targetName = "YTSettings"
    typealias Group = DisableDoubleTapToSkip

    func doubleTapToSeekEnabled() -> Bool {
        return false
    }
}

// Overlay Options

// Hide Dark Background
struct HideDarkBackground: HookGroup {}

class HideDarkBackground1: ClassHook<UIView> {
    static let targetName = "YTMainAppVideoPlayerOverlayView"
    typealias Group = HideDarkBackground
    
    func setBackgroundVisible(_ arg1: Bool, isGradientBackground arg2: Bool) {
        orig.setBackgroundVisible(false, isGradientBackground: arg2)
    }
}

// Colour Options
var rebornColourOptions: UIColor = UIColor.clear
struct ColorOptions: HookGroup {}

class ColorOptionsA1: ClassHook<UIView> {
    static let targetName = "YTAppView"
    typealias Group = ColorOptions

    func setBackgroundColor(_ arg1: UIColor) {
        orig.setBackgroundColor(rebornColourOptions)
    }
}

class ColorOptionsE1: ClassHook<UIView> {
    static let targetName = "YTELMView"
    typealias Group = ColorOptions

    func setBackgroundColor(_ arg1: UIColor) {
        orig.setBackgroundColor(rebornColourOptions)
    }
}

class ColorOptionsN1: ClassHook<UIView> {
    static let targetName = "YTNavigationBar" // Check Type
    typealias Group = ColorOptions

    func setBackgroundColor(_ arg1: UIColor) {
        orig.setBackgroundColor(rebornColourOptions)
    }
    func setBarTintColor(_ arg1: UIColor) {
        orig.setBarTintColor(rebornColourOptions)
    }
}
class ColorOptionsP1: ClassHook<UIView> {
    static let targetName = "YTPageHeaderView" // Check Type
    typealias Group = ColorOptions

    func setBackgroundColor(_ arg1: UIColor) {
        orig.setBackgroundColor(rebornColourOptions)
    }
}
class ColorOptionsP2: ClassHook<UIView> {
    static let targetName = "YTPivotBarView"
    typealias Group = ColorOptions

    func setBackgroundColor(_ arg1: UIColor) {
        orig.setBackgroundColor(rebornColourOptions)
    }
}

// Other Options

// Disable YouTube Kids
struct DisableYouTubeKids: HookGroup {}

class DisableYouTubeKids1: ClassHook<UIView> { // Check Type
    static let targetName = "YTWatchMetadataAppPromoCell"
    typealias Group = DisableYouTubeKids

    func initWithFrame(_ arg1: CGRect) -> Any? {
        return nil
    }
}
class DisableYouTubeKids2: ClassHook<UIView> {
    static let targetName = "YTHUDMessageView"
    typealias Group = DisableYouTubeKids

    func initWithMessage(_ arg1: Any?, dismissHandler arg2: Any?) -> Any? {
        return nil
    }
}
class DisableYouTubeKids4: ClassHook<UIViewController> {
    static let targetName = "YTNGWatchMiniBarViewController"
    typealias Group = DisableYouTubeKids
    
    func miniplayerRenderer() -> Any? {
        return nil
    }
}
class DisableYouTubeKids5: ClassHook<UIViewController> {
    static let targetName = "YTWatchMiniBarViewController"
    typealias Group = DisableYouTubeKids
    
    func miniplayerRenderer() -> Any? {
        return nil
    }
}

// Disable Hints
struct DisableHints: HookGroup {}

class DisableHints1: ClassHook<UIView> {
    static let targetName = "YTSettings"
    typealias Group = DisableHints

    func areHintsDisabled() -> Bool {
        return true
    }
    func setHintsDisabled(_ arg1: Bool) {
        orig.setHintsDisabled(true)
    }
}
class DisableHints2: ClassHook<UIView> {
    static let targetName = "YTUserDefaults"
    typealias Group = DisableHints

    func areHintsDisabled() -> Bool {
        return true
    }
    func setHintsDisabled(_ arg1: Bool) {
        orig.setHintsDisabled(true)
    }
}

// Defaults

class UseAppThemeSetting: ClassHook<NSObject> {
    static let targetName = "YTColdConfig"

    func shouldUseAppThemeSetting() -> Bool {
        return true
    }
}

// Loader

struct YouTubeReborn: Tweak {
    static func handleError(_ error: OrionHookError) {
    }

    init() {
        // Video Options

        // Enable No Ads
        if UserDefaults.standard.bool(forKey: "kEnableNoVideoAds") && !UserDefaults.standard.bool(forKey: "kRebornIHaveYouTubePremium") {
            EnableNoAds().activate()
        }

        // Enable Background Playback
        if UserDefaults.standard.bool(forKey: "kEnableBackgroundPlayback") {
            EnableBackgroundPlayback().activate()
        }

        // Allow HD On Cellular Data
        if UserDefaults.standard.bool(forKey: "kAllowHDOnCellularData") {
            AllowHDOnCellularData().activate()
        }

        // Disable Video AutoPlay
        if UserDefaults.standard.bool(forKey: "kDisableVideoAutoPlay") {
            DisableVideoAutoPlay().activate()
        }

        // Hide Player Bar Heatwave
        if UserDefaults.standard.bool(forKey: "kHidePlayerBarHeatwave") {
            HidePlayerBarHeatwave().activate()
        }

        // Disable Double Tap To Skip        
        if UserDefaults.standard.bool(forKey: "kDisableDoubleTapToSkip") {
            DisableDoubleTapToSkip().activate()
        }

        // Overlay Options

        // Hide Dark Background
        if UserDefaults.standard.bool(forKey: "kHideOverlayDarkBackground") {
            HideDarkBackground().activate()
        }

        // Colour Options

        let colourData = UserDefaults.standard.object(forKey: "kYTRebornColourOptionsVFour") as? Data
        if colourData != nil {
            let unarchiver = try! NSKeyedUnarchiver.init(forReadingFrom: colourData!)
            unarchiver.requiresSecureCoding = false
            let colourString = unarchiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! UIColor
            rebornColourOptions = colourString
            ColorOptions().activate()
        }

        // Other Options

        // Disable YouTube Kids
        if UserDefaults.standard.bool(forKey: "kDisableYouTubeKidsPopup") {
            DisableYouTubeKids().activate()
        }

        // Disable Hints
        if UserDefaults.standard.bool(forKey: "kDisableHints") {
            DisableHints().activate()
        }
    }
}