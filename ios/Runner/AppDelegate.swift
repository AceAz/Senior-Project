import Flutter
import UIKit
import GoogleMaps

GMSServices.provideAPIKey("AIzaSyD1c-Egb7s2h9wUlOynr6jE6yYZcarIOY4")

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
