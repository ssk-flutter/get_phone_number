import Flutter
import UIKit

public class SwiftGetPhoneNumberPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "ssk.d/get_phone_number", binaryMessenger: registrar.messenger())
    let instance = SwiftGetPhoneNumberPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result(FlutterError(code: "UNAVAILABLE",
                             message: "iOS does not support get phone number.",
                             details: nil))
  }
}
