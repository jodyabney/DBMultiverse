//
//  PreviewModifiersViewModifier.swift
//  DBMultiverse
//
//  Created by Nikolai Nobadi on 12/11/24.
//

import SwiftUI
import SwiftData
import NnSwiftUIKit

struct PreviewModifiersViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        MainActor.assumeIsolated {
            content
                .environment(\.isPreview, true)
                .modelContainer(PreviewSampleData.container)
        }
    }
}

extension View {
    func withPreviewModifiers() -> some View {
        modifier(PreviewModifiersViewModifier())
    }
}

actor PreviewSampleData {
    @MainActor
    static var container: ModelContainer = {
        let container = try! ModelContainer(for: SwiftDataChapter.self, configurations: .init(isStoredInMemoryOnly: true))
        
        SwiftDataChapter.sampleList.forEach({ container.mainContext.insert($0) })
        
        return container
    }()
    
    @MainActor
    static var sampleChapter: SwiftDataChapter {
        let _ = PreviewSampleData.container
        
        return SwiftDataChapter.sampleList[0]
    }
}

extension SwiftDataChapter {
    static var sampleList: [SwiftDataChapter] {
        return [
            .init(name: "A really strange tournament!", number: 1, startPage: 0, endPage: 23, universe: nil, lastReadPage: 17),
            .init(name: "Lots of old foes here!", number: 2, startPage: 24, endPage: 47, universe: nil, lastReadPage: nil),
            .init(name: "Universe 3: visions of the future", number: 20, startPage: 425, endPage: 449, universe: "Special Universe 3", lastReadPage: nil),
            .init(name: "Deus Ex Machina", number: 25, startPage: 547, endPage: 555, universe: "Special Universe 1", lastReadPage: 549)
        ]
    }
}
