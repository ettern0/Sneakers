//
//  PaletteControl.swift
//  Sneakers
//
//  Created by Alexey Salangin on 05.06.2022.
//

import SwiftUI

struct PaletteControl: View {
    typealias Colors = [UInt32]
    @State var colors: Colors = []
    @Binding var selectedIndices: [Colors.Index]

    init(colors: Colors, selectedIndices: Binding<[Colors.Index]>) {
        self.colors = colors
        self._selectedIndices = selectedIndices
    }

    var selectionBinding: (Colors.Index) -> Binding<Bool> {
        { index in
            Binding<Bool> {
                selectedIndices.contains(index)
            } set: { isSelected, _ in
                if isSelected {
                    selectedIndices.append(index)
                    selectedIndices = Array(selectedIndices.suffix(2))
                } else {
                    if let firstIndex = selectedIndices.firstIndex(of: index) {
                        selectedIndices.remove(at: firstIndex)
                    }
                }
            }
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            ForEach(Array(zip(colors.indices, colors)), id: \.0) { (index: Colors.Index, color: Colors.Element) in
                Toggle(isOn: selectionBinding(index)) {
                    Color(rgb: color)
                }.toggleStyle(PaletteToggleStyle())
            }
        }
    }
}

private struct PaletteButtonStyle: ButtonStyle {
    var isSelected = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: 43, maxHeight: 43)
            .aspectRatio(1, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .stroke(isSelected ? .white : .clear, lineWidth: 2)
            )
            .padding(2)
            .overlay(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .stroke(isSelected ? .black : .clear, lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.7 : 1)
            .animation(.none, value: configuration.isPressed)
    }
}

private struct PaletteToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            configuration.label
        }.buttonStyle(PaletteButtonStyle(isSelected: configuration.isOn))
    }
}
