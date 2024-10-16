import Combine
import Foundation

class RpsDataViewModel: ObservableObject {
    @Published var data: GlobalState

    init() {
        self.data = GlobalState()
    }

    func reloadData() {
        self.data = GlobalState()
    }

    func refreshCombinations() {
        self.data.generateCombinations()
    }
}
