//
//  MainFeaturesView.swift
//  DBMultiverse
//
//  Created by Nikolai Nobadi on 11/30/24.
//

import SwiftUI
import SwiftData
import DBMultiverseComicKit

struct MainFeaturesView: View {
    @State private var path: NavigationPath = .init()
    @StateObject var viewModel: MainFeaturesViewModel
    @Query(sort: \SwiftDataChapter.number, order: .forward) var chapterList: SwiftDataChapterList
    
    @Binding var language: ComicLanguage
    
    var body: some View {
        MainNavStack(path: $path) {
            ChapterListFeatureView(eventHandler: .customInit(viewModel: viewModel, chapterList: chapterList))
                .navigationDestination(for: ChapterRoute.self) { route in
                    ComicPageFeatureView(
                        viewModel: .customInit(route: route, store: viewModel, chapterList: chapterList, language: language)
                    )
                }
        } settingsContent: {
            SettingsFeatureNavStack(language: $language, viewModel: .init(), canDismiss: isPad)
        }
        .asyncTask {
            try await viewModel.loadData(language: language)
        }
        .syncChaptersWithSwiftData(chapters: viewModel.chapters)
        .withDeepLinkNavigation(path: $path, chapters: chapterList.chapters)
        .onChange(of: viewModel.nextChapterToRead) { _, newValue in
            if let newValue {
                // TODO: - only works for main story chapters for now
                path.append(ChapterRoute(chapter: newValue, comicType: .story))
            }
        }
    }
}


// MARK: - NavStack
fileprivate struct MainNavStack<ComicContent: View, SettingsContent: View>: View {
    @Binding var path: NavigationPath
    @ViewBuilder var comicContent: () -> ComicContent
    @ViewBuilder var settingsContent: () -> SettingsContent
    
    var body: some View {
        iPhoneMainTabView(path: $path, comicContent: comicContent, settingsTab: settingsContent)
            .showingConditionalView(when: isPad) {
                iPadMainNavStack(path: $path, comicContent: comicContent, settingsContent: settingsContent)
            }
    }
}


// MARK: - Preview
#Preview {
    class PreviewLoader: ChapterLoader {
        func loadChapters(url: URL?) async throws -> [Chapter] { [] }
    }
    
    return MainFeaturesView(viewModel: .init(loader: PreviewLoader()), language: .constant(.english))
        .withPreviewModifiers()
}


// MARK: - Extension Dependencies
fileprivate extension SwiftDataChapterListEventHandler {
    static func customInit(viewModel: MainFeaturesViewModel, chapterList: SwiftDataChapterList) -> SwiftDataChapterListEventHandler {
        return .init(
            lastReadSpecialPage: viewModel.lastReadSpecialPage,
            lastReadMainStoryPage: viewModel.lastReadMainStoryPage,
            chapterList: chapterList,
            onStartNextChapter: viewModel.startNextChapter(_:)
        )
    }
}

fileprivate extension ComicPageViewModel {
    static func customInit(route: ChapterRoute, store: MainFeaturesViewModel, chapterList: SwiftDataChapterList, language: ComicLanguage) -> ComicPageViewModel {
        let currentPageNumber = store.getCurrentPageNumber(for: route.comicType)
        let imageCache = ComicImageCacheAdapter(comicType: route.comicType, viewModel: store)
        let networkService = ComicPageNetworkServiceAdapter()
        let manager = ComicPageManager(
            chapter: route.chapter,
            language: language,
            imageCache: imageCache,
            networkService: networkService,
            chapterProgressHandler: chapterList
        )
        
        return .init(chapter: route.chapter, currentPageNumber: currentPageNumber, delegate: manager)
    }
}
