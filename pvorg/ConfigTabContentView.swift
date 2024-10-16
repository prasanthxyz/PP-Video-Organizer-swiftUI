import SwiftUI

struct ConfigTabContentView: View {
    @EnvironmentObject var rpsData: RpsDataViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack{
                Text("Galleries").font(.title)
                Spacer()
            }
            FlowLayout(items: $rpsData.data.filters.galleries) { item in
                TagView(item: item)
                    .onTapGesture {
                        toggleGallerySelection(for: item)
                    }
            }

            HStack{
                Text("Tags").font(.title)
                Spacer()
            }
            FlowLayout(items: $rpsData.data.filters.tags) { item in
                TagView(item: item)
                    .onTapGesture {
                        toggleTagSelection(for: item)
                    }
            }

            HStack{
                Text("Studio").font(.title)
                Spacer()
            }
            FlowLayout(items: $rpsData.data.filters.studios) { item in
                TagView(item: item)
                    .onTapGesture {
                        toggleStudioSelection(for: item)
                    }
            }

            HStack{
                Text("Cast").font(.title)
                Spacer()
            }
            FlowLayout(items: $rpsData.data.filters.cast) { item in
                TagView(item: item)
                    .onTapGesture {
                        toggleCastSelection(for: item)
                    }
            }

            HStack{
                Text("Sample Combinations").font(.title)
                Spacer()
            }
            let combinations = Array(rpsData.data.combinations.prefix(10))
            if combinations.count > 0 {
                List(combinations, id: \.self) { combination in
                    Text("\(combination.video) - \(combination.gallery)")
                }
            } else {
                HStack {
                    Text("No combinations found").font(.title)
                    Spacer()
                }
            }
        }
        .padding()
    }

    func toggleGallerySelection(for item: SelectableItem) {
        if let index = rpsData.data.filters.galleries.firstIndex(where: { $0.value == item.value }) {
            rpsData.data.filters.galleries[index].isSelected.toggle()
            rpsData.refreshCombinations()
        }
    }

    func toggleTagSelection(for item: SelectableItem) {
        if let index = rpsData.data.filters.tags.firstIndex(where: { $0.value == item.value }) {
            rpsData.data.filters.tags[index].isSelected.toggle()
            rpsData.refreshCombinations()
        }
    }

    func toggleStudioSelection(for item: SelectableItem) {
        if let index = rpsData.data.filters.studios.firstIndex(where: { $0.value == item.value }) {
            rpsData.data.filters.studios[index].isSelected.toggle()
            rpsData.refreshCombinations()
        }
    }

    func toggleCastSelection(for item: SelectableItem) {
        if let index = rpsData.data.filters.cast.firstIndex(where: { $0.value == item.value }) {
            rpsData.data.filters.cast[index].isSelected.toggle()
            rpsData.refreshCombinations()
        }
    }
}

struct TagView: View {
    let item: SelectableItem

    var body: some View {
        Text(item.value)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(item.isSelected ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(20)
    }
}


struct FlowLayout<Content: View>: View {
    @Binding var items: [SelectableItem]
    let content: (SelectableItem) -> Content

    var body: some View {
        GeometryReader { geometry in
            self.createWrappedView(for: geometry.size.width)
        }
    }

    // Create wrapped tags based on available width
    private func createWrappedView(for totalWidth: CGFloat) -> some View {
        var width = CGFloat(0)
        var height = CGFloat(0)

        return ZStack(alignment: .topLeading) {
            ForEach(items, id: \.value) { item in
                content(item)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if (abs(width - dimension.width) > totalWidth) {
                            width = 0
                            height -= dimension.height
                        }
                        let result = width
                        if item.value == self.items.last!.value {
                            width = 0
                        } else {
                            width -= dimension.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in height })
            }
        }
    }
}


#Preview {
    ConfigTabContentView()
        .environmentObject(RpsDataViewModel())
        .frame(width: 500, height: 400)
}
