import SwiftUI

struct RunningApplication {
  let appName: String
  let architecture: String
  let appImage: NSImage
  let processorIcon: NSImage
}

class ViewModel: ObservableObject {
  @Published var runningAppInfo: [RunningApplication] = []
}

@main
struct SiliconInfoApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  @ObservedObject var viewModel = ViewModel()
  
  var body: some Scene {
    WindowGroup {
      AppList(apps: $viewModel.runningAppInfo)
    }.commands {
      CommandGroup(replacing: .newItem, addition: { })
    }
    // prevents opening multiple windows.
    // https://stackoverflow.com/questions/66647052/why-does-url-scheme-onopenurl-in-swiftui-always-open-a-new-window
  }
  
  func refreshRunningApps() {
    let apps = NSWorkspace.shared.runningApplications
    var runningAppInfo: [RunningApplication] = []
    for currentApp in apps {
      let info = getApplicationInfo(application: currentApp)
      runningAppInfo.append(info)
    }
    viewModel.runningAppInfo = runningAppInfo
  }
  
  init () {
    refreshRunningApps()
  }
  
  func getApplicationInfo(application: NSRunningApplication?) ->RunningApplication{
    // Check if application is nil, passed in item is not guaranteed to be an object
    guard let runningApp = application else {
      return RunningApplication(appName: "Unknown", architecture: "Cannot identify frontmost app", appImage: NSImage(named: "processor-icon-empty") ?? NSImage(), processorIcon: NSImage(named: "processor-icon-empty") ?? NSImage())
    }
    // After checking for nil, we can refer to runningApp, guarenteed to be NSRunningApplication
    let frontAppName = runningApp.localizedName ?? String()
    let frontAppImage = runningApp.icon ?? NSImage()
    let architectureInt = runningApp.executableArchitecture
    
    
    var architecture = ""
    var processorIcon = NSImage()
    switch architectureInt {
    case NSBundleExecutableArchitectureARM64:
      architecture = "arm64 • Apple Silicon"
      processorIcon = NSImage(named: "processor-icon") ?? NSImage()
    case NSBundleExecutableArchitectureI386:
      architecture = "x86 • Intel 32-bit"
      processorIcon = NSImage(named: "processor-icon-empty") ?? NSImage()
    case NSBundleExecutableArchitectureX86_64:
      architecture = "x86-64 • Intel 64-bit"
      processorIcon = NSImage(named: "processor-icon-empty") ?? NSImage()
    case NSBundleExecutableArchitecturePPC:
      architecture = "ppc32 • PowerPC 32-bit"
      processorIcon = NSImage(named: "processor-icon-empty") ?? NSImage()
    case NSBundleExecutableArchitecturePPC64:
      architecture = "ppc64 • PowerPC 64-bit"
      processorIcon = NSImage(named: "processor-icon-empty") ?? NSImage()
    default:
      architecture = "Unknown • Unknown"
      processorIcon = NSImage(named: "processor-icon-empty") ?? NSImage()
    }
    return RunningApplication(appName: frontAppName, architecture: architecture, appImage: frontAppImage, processorIcon: processorIcon)
  }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
  override init(){
    super.init()
  }
}
