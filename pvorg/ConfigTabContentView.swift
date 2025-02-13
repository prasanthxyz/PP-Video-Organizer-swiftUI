import SwiftUI
import WrappingStack

struct ConfigTabContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Select Galleries")
                        .font(.headline)

                    WrappingHStack(id: \.self, alignment: .leading, horizontalSpacing: 10, verticalSpacing: 5) {
                        let galleries = appState.galleries.map({ $0.name }).unique().sorted()
                        ForEach(galleries, id: \.self) { gallery in
                            TagView(
                                label: gallery,
                                isSelected: appState.selectedGalleries.contains(gallery),
                                onTap: {
                                    if appState.selectedGalleries.contains(gallery) {
                                        appState.selectedGalleries.remove(gallery)
                                    } else {
                                        appState.selectedGalleries.insert(gallery)
                                    }
                                    appState.generateCombinations()
                                },
                                onLongPress: {
                                    if appState.selectedGalleries.contains(gallery) {
                                        for gallery2 in galleries {
                                            if !appState.selectedGalleries.contains(gallery2) {
                                                appState.selectedGalleries.insert(gallery2)
                                            }
                                        }
                                        appState.selectedGalleries.remove(gallery)
                                    } else {
                                        for gallery2 in galleries {
                                            if appState.selectedGalleries.contains(gallery2) {
                                                appState.selectedGalleries.remove(gallery2)
                                            }
                                        }
                                        appState.selectedGalleries.insert(gallery)
                                    }
                                    appState.generateCombinations()
                                }
                            )
                        }
                    }

                    Text("Select Tags")
                        .font(.headline)

                    WrappingHStack(id: \.self, alignment: .leading, horizontalSpacing: 10, verticalSpacing: 5) {
                        let tags = appState.appConfig?.tags.unique().sorted() ?? []
                        ForEach(tags, id: \.self) { tag in
                            TagView(
                                label: tag,
                                isSelected: appState.selectedTags.contains(tag),
                                onTap: {
                                    if appState.selectedTags.contains(tag) {
                                        appState.selectedTags.remove(tag)
                                    } else {
                                        appState.selectedTags.insert(tag)
                                    }
                                    appState.generateCombinations()
                                },
                                onLongPress: {}
                            )
                        }
                    }

                    Text("Select Studios")
                        .font(.headline)

                    WrappingHStack(id: \.self, alignment: .leading, horizontalSpacing: 10, verticalSpacing: 5) {
                        let studios = appState.videos.map({ $0.studio }).unique().sorted()
                        ForEach(studios, id: \.self) { studio in
                            TagView(
                                label: studio,
                                isSelected: appState.selectedStudios.contains(studio),
                                onTap: {
                                    if appState.selectedStudios.contains(studio) {
                                        appState.selectedStudios.remove(studio)
                                    } else {
                                        appState.selectedStudios.insert(studio)
                                    }
                                    appState.generateCombinations()
                                },
                                onLongPress: {}
                            )
                        }
                    }

                    Text("Select Cast")
                        .font(.headline)

                    WrappingHStack(id: \.self, alignment: .leading, horizontalSpacing: 10, verticalSpacing: 5) {
                        let actors = appState.videos.flatMap { $0.actors }.unique().sorted()
                        ForEach(actors, id: \.self) { actor in
                            TagView(
                                label: actor,
                                isSelected: appState.selectedCast.contains(actor),
                                onTap: {
                                    if appState.selectedCast.contains(actor) {
                                        appState.selectedCast.remove(actor)
                                    } else {
                                        appState.selectedCast.insert(actor)
                                    }
                                    appState.generateCombinations()
                                },
                                onLongPress: {}
                            )
                        }
                    }

                    Divider()
                        .padding(.vertical)

                    Spacer()
                }
            }

            VStack {
                Text("Sample Combinations")
                    .font(.headline)
                ScrollView {
                    if appState.combinations.isEmpty {
                        VStack {
                            Text("No combinations")
                            Spacer()
                        }
                    } else {
                        LazyVStack {
                            ForEach(appState.combinations.prefix(10), id: \.self) { combination in
                                HStack {
                                    Text(combination.video.filename)
                                    Spacer()
                                    Text(combination.gallery.name)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        .frame(maxWidth: 300, alignment: .leading)
                    }
                }

                Spacer()
            }
        }
        .padding()
    }
}

struct TagView: View {
    var label: String
    var isSelected: Bool
    var onTap: () -> Void
    var onLongPress: () -> Void

    var body: some View {
        Text(label)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.3))  // Highlight if selected
            .foregroundColor(isSelected ? .white : .black)
            .cornerRadius(20)
            .onTapGesture {
                onTap()
            }
            .onLongPressGesture {
                onLongPress()
            }
    }
}

extension Array where Element: Hashable {
    func unique() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

#Preview {
    ConfigTabContentView()
        .environmentObject(AppState())
        .frame(width: 500, height: 800)
}
