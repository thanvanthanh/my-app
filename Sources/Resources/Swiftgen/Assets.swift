// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum AssetsIOS {
    internal static let appIcon = ImageAsset(name: "AppIcon")
  }
  internal enum ColorsIOS {
    internal static let authAccent = ColorAsset(name: "authAccent")
    internal static let authAccentEnd = ColorAsset(name: "authAccentEnd")
    internal static let authAppleBackground = ColorAsset(name: "authAppleBackground")
    internal static let authAppleText = ColorAsset(name: "authAppleText")
    internal static let authBackground = ColorAsset(name: "authBackground")
    internal static let authBorderBottom = ColorAsset(name: "authBorderBottom")
    internal static let authBorderMiddle = ColorAsset(name: "authBorderMiddle")
    internal static let authBorderTop = ColorAsset(name: "authBorderTop")
    internal static let authBottomGlow = ColorAsset(name: "authBottomGlow")
    internal static let authDisabledButtonBackground = ColorAsset(name: "authDisabledButtonBackground")
    internal static let authDisabledButtonBorder = ColorAsset(name: "authDisabledButtonBorder")
    internal static let authDisabledButtonText = ColorAsset(name: "authDisabledButtonText")
    internal static let authFieldBorderBottom = ColorAsset(name: "authFieldBorderBottom")
    internal static let authFieldBorderTop = ColorAsset(name: "authFieldBorderTop")
    internal static let authFieldBottom = ColorAsset(name: "authFieldBottom")
    internal static let authFieldIcon = ColorAsset(name: "authFieldIcon")
    internal static let authFieldTop = ColorAsset(name: "authFieldTop")
    internal static let authPrimaryText = ColorAsset(name: "authPrimaryText")
    internal static let authSecondaryText = ColorAsset(name: "authSecondaryText")
    internal static let authSurfaceBottom = ColorAsset(name: "authSurfaceBottom")
    internal static let authSurfaceTop = ColorAsset(name: "authSurfaceTop")
    internal static let authTopGlow = ColorAsset(name: "authTopGlow")
    internal static let color = ColorAsset(name: "Color")
    internal static let launchBackground = ColorAsset(name: "launchBackground")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset: @unchecked Sendable {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type

