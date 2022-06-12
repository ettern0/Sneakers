//
//  ViewHosting.swift
//  Sneakers
//
//  Created by Alexey Salangin on 12.06.2022.
//

import SwiftUI
import DesignSystem

struct ViewHosting: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var router: Router

    private let view: AnyView

    init(view: AnyView) {
        self.view = view
    }

    var body: some View {
        view
            .if(router.needsShowBackButton, transform: { view in
                view
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image("NavBar/back")
                            }.buttonStyle(NavigationButtonStyle())
                        }
                    }
            })
    }
}
