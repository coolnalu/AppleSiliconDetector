import SwiftUI

struct ContentView: View {
  var app: RunningApplication
  func download() {
    
  }
  
  var body: some View {
    HStack(spacing: 8) {
      Image(nsImage: app.appImage)
      Text(app.appName).frame(alignment: .leading)
      Spacer()
      Text(app.architecture)
      if (app.architecture != "arm64 • Apple Silicon") {
        Button("Download", action: download)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
