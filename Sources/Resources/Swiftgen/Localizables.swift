// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Sign in with Apple
  internal static let loginApple = L10n.tr("Localizables", "login_apple")
  /// Back
  internal static let loginBackAccessibility = L10n.tr("Localizables", "login_back_accessibility")
  /// EMAIL
  internal static let loginEmailLabel = L10n.tr("Localizables", "login_email_label")
  /// Email
  internal static let loginEmailPlaceholder = L10n.tr("Localizables", "login_email_placeholder")
  /// Sign in with Face ID
  internal static let loginFaceId = L10n.tr("Localizables", "login_face_id")
  /// Forgot Password?
  internal static let loginForgotPassword = L10n.tr("Localizables", "login_forgot_password")
  /// Hide password
  internal static let loginHidePasswordAccessibility = L10n.tr("Localizables", "login_hide_password_accessibility")
  /// Don’t have an account?
  internal static let loginNoAccount = L10n.tr("Localizables", "login_no_account")
  /// PASSWORD
  internal static let loginPasswordLabel = L10n.tr("Localizables", "login_password_label")
  /// Password
  internal static let loginPasswordPlaceholder = L10n.tr("Localizables", "login_password_placeholder")
  /// Show password
  internal static let loginShowPasswordAccessibility = L10n.tr("Localizables", "login_show_password_accessibility")
  /// Sign In
  internal static let loginSignIn = L10n.tr("Localizables", "login_sign_in")
  /// Sign Up
  internal static let loginSignUp = L10n.tr("Localizables", "login_sign_up")
  /// Access your account securely
  internal static let loginSubtitle = L10n.tr("Localizables", "login_subtitle")
  /// Sign In
  internal static let loginTitle = L10n.tr("Localizables", "login_title")
  /// Aura Flow
  internal static let welcomeAppName = L10n.tr("Localizables", "welcome_app_name")
  /// Create Account
  internal static let welcomeCreateAccountTitle = L10n.tr("Localizables", "welcome_create_account_title")
  /// Apple Human Interface Guidelines Compliant
  internal static let welcomeFooter = L10n.tr("Localizables", "welcome_footer")
  /// Sign In
  internal static let welcomeSignInTitle = L10n.tr("Localizables", "welcome_sign_in_title")
  /// Seamless & Secure Experience
  internal static let welcomeSubtitle = L10n.tr("Localizables", "welcome_subtitle")
  /// Welcome
  internal static let welcomeTitle = L10n.tr("Localizables", "welcome_title")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
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
