//
//  CarauselView.swift
//  Sneakers
//
//  Created by Evgeny Serdyukov on 17.05.2022.
//
import SwiftUI

struct Carousel<Items: View>: View {
    let items: Items
    let numberOfItems: CGFloat
    let spacing: CGFloat
    let widthOfHiddenCards: CGFloat
    let totalSpacing: CGFloat
    let cardWidth: CGFloat
    @GestureState var isDetectingLongPress = false
    @EnvironmentObject var viewModel: SneakersListViewModel

    init(numberOfItems: CGFloat, spacing: CGFloat, widthOfHiddenCards: CGFloat, @ViewBuilder _ items: () -> Items) {
        self.items = items()
        self.numberOfItems = numberOfItems
        self.spacing = spacing
        self.widthOfHiddenCards = widthOfHiddenCards
        self.totalSpacing = (numberOfItems - 1) * spacing
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards * 2) - (spacing * 2)
    }

    var body: some View {
        let totalCanvasWidth: CGFloat = (cardWidth * numberOfItems) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 2
        let leftPadding = widthOfHiddenCards + spacing
        let totalMovement = cardWidth + spacing

        let activeOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(viewModel.active))
        let nextOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(viewModel.active) + 1)

        var calcOffset = Float(activeOffset)

        if calcOffset != Float(nextOffset) {
            calcOffset = Float(activeOffset) + viewModel.drag
        }

        return HStack(alignment: .center, spacing: spacing) {
            items
        }
        .offset(x: CGFloat(calcOffset), y: 0)
        .gesture(DragGesture().updating($isDetectingLongPress) { currentState, _, _ in
            self.viewModel.drag = Float(currentState.translation.width)

        }.onEnded { value in
            self.viewModel.drag = 0
            let activeCard = self.viewModel.active
            if value.translation.width < -50 {
                self.viewModel.active = activeCard + 1
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }

            if value.translation.width > 50 {
                self.viewModel.active = activeCard - 1
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
        })
    }
}

struct Canvas<Content: View>: View {
    let content: Content

    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}
