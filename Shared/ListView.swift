import SwiftUI

struct AppList: View {
  @Binding var apps: [RunningApplication]
  
  var body: some View {
    List(apps.indices) { idx in
      ContentView(app: apps[idx])
    }
  }
}
