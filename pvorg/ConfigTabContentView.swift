import SwiftUI

struct ConfigTabContentView: View {
    @EnvironmentObject var rpsData: RpsDataViewModel

    var body: some View {
        GeometryReader { geometry in
            HStack {
                CheckBoxListView(items: $rpsData.data.galleryNames, checkedItems: $rpsData.data.selectedGalleries)
                    .frame(width: geometry.size.width * 0.2)

                Spacer()

                CheckBoxListView(items: $rpsData.data.tagNames, checkedItems: $rpsData.data.selectedTags)
                    .frame(width: geometry.size.width * 0.2)

                Spacer()

                CheckBoxListView(items: $rpsData.data.videoNames, checkedItems: $rpsData.data.selectedVideos)
                    .frame(width: geometry.size.width * 0.54)

                VStack {
                    Button(action: {
                        rpsData.generateCombinations()
                    }) {
                        Text("Save")
                    }
                    Spacer()
                }
                .frame(width: geometry.size.width * 0.05)
            }
        }
    }
}

struct CheckBoxListView: View {
    @Binding var items: [String]
    @Binding var checkedItems: Set<String>

    var body: some View {
        List(items, id: \.self) { item in
            HStack {
                Toggle(isOn: Binding(
                    get: { checkedItems.contains(item) },
                    set: { isChecked in
                        if isChecked {
                            checkedItems.insert(item)
                        } else {
                            checkedItems.remove(item)
                        }
                    }
                )) {
                    Text(item)
                }
            }
        }
    }
}

#Preview {
    ConfigTabContentView()
        .environmentObject(RpsDataViewModel())
        .frame(width: 500, height: 400)
}
