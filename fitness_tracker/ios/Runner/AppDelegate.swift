import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyBQ624kYiPHsJ3s2hZqvRLPbu2Eoidaza8")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
