import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    let window = NSApplication.shared.windows.first
    window?.setContentSize(NSSize(width: 800, height: 800)) // Set the window size
    window?.center() // Center the window on the screen
  }
}
