import SwiftUI

struct ConfigTabContentView: View {
    @EnvironmentObject var rpsData: RpsDataViewModel

    var body: some View {
        VStack {}
        .padding()
    }
}

#Preview {
    ConfigTabContentView()
        .environmentObject(RpsDataViewModel())
        .frame(width: 500, height: 400)
}
