//
//  ViewHosting.swift
//  Sneakers
//
//  Created by Alexey Salangin on 12.06.2022.
//

import SwiftUI

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
                                Image("back")
                                    .frame(width: 43, height: 43)
                                    .background(content: {
                                        RoundedRectangle(cornerRadius: 4)
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.08), radius: 6)
                                    })
                            }
                        }
                    }
            })
    }
}
