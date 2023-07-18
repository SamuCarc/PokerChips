//
//  SliderRaise.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 9/5/23.
//

import SwiftUI
import AnimatedNumber

struct CustomShape: Shape {
    var animatableData: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let startPoint = CGPoint(x: rect.minX, y: rect.midY)
        let topRightPoint = CGPoint(x: rect.maxX, y: rect.midY - animatableData)
        let bottomRightPoint = CGPoint(x: rect.maxX, y: rect.midY + animatableData)
        
        path.move(to: startPoint)
        path.addLine(to: topRightPoint)
        path.addLine(to: bottomRightPoint)
        path.addLine(to: startPoint)
        
        return path
    }
}


struct SliderRaise: View {
    @Binding var raiseValue: Int
    @Binding var minValue: Int
    @Binding var maxValue: Int
    @State private var isPressed = false
    @State private var tempRaiseValue: Int
    @State private var displayedAmount: Double = 0
    @State private var showSlider: Bool = false
    
    @State private var chipAnimation: Bool = false
    @State private var arrowOpacities: [Bool] = Array(repeating: false, count: 4)

    init(raiseValue: Binding<Int>, minValue: Binding<Int>, maxValue: Binding<Int>) {
        self._raiseValue = raiseValue
        self._minValue = minValue
        self._maxValue = maxValue
        self._tempRaiseValue = State(initialValue: raiseValue.wrappedValue)
    }
    
    private var tempRaiseValueDouble: Binding<Double> {
        Binding<Double>(
            get: { Double(self.tempRaiseValue) },
            set: { self.tempRaiseValue = Int($0) }
        )
    }

    private var stepValue: Int {
        return (maxValue - minValue) / 50
    }

    var body: some View {
        HStack (spacing: 25) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .offset(x: -10)
                        .foregroundStyle(.ultraThinMaterial)
                        .frame(width: 150, height: 15)
                        .opacity(showSlider ? 1 : 0)
                    
                    Text(formatCurrency(amount: tempRaiseValue))
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        .offset(x: min(thumbOffset(in: geometry.size) - 50, 50), y: isPressed ? -60 : -20)
                        .scaleEffect(isPressed ? 1 : 0)
                    
                    
                    // Línea izquierda del slider (antes del pomo)
                    CustomShape(animatableData: thumbOffset(in: geometry.size)/10)
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color.accentColor, Color.red]), startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: thumbOffset(in: geometry.size), height: 10)
                        .opacity(showSlider ? 1 : 0)
                    
                    // Línea derecha del slider (después del pomo)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: geometry.size.width - geometry.size.width * CGFloat((Double(tempRaiseValue - minValue)) / Double(maxValue - minValue)), height: 4)
                        .offset(x: geometry.size.width * CGFloat((Double(tempRaiseValue - minValue)) / Double(maxValue - minValue)))
                        .foregroundColor(.black)
                        .opacity(0)
                    
                    HStack (spacing: -10) {
                        ForEach(0..<arrowOpacities.count, id: \.self) { index in
                            Image(systemName: "chevron.right")
                                .font(.system(size: 30, weight: .heavy, design: .rounded))
                                .foregroundColor(.accentColor)
                                .opacity(arrowOpacities[index] ? 0.2 : 1)
                        }
                    }
                    .opacity(showSlider ? 0 : 1)
                    .padding(.leading, 17)
                    
                    SliderChip()
                        .scaleEffect(!showSlider && chipAnimation ? 0.9 : 1 )
                        .scaleEffect(isPressed ? 1.2 : 1)
                        .animation(.easeInOut(duration: 0.1), value: isPressed)
                        .offset(x: thumbOffset(in: geometry.size) - 20)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        self.showSlider = true
                                    }
                                    let sliderWidth = geometry.size.width
                                    let sliderRange = Double(maxValue - minValue)
                                    let newSliderValue = Double(value.location.x / sliderWidth) * sliderRange + Double(minValue)
                                    self.tempRaiseValue = Int(min(max(newSliderValue, Double(minValue)), Double(maxValue)))
                                }
                                .onEnded { _ in
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        self.showSlider = (self.tempRaiseValue > self.minValue || isPressed)
                                    }
                                    self.raiseValue = self.tempRaiseValue
                                }
                        )
                        .onLongPressGesture(minimumDuration: 0.01, pressing: { pressing in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                self.isPressed = pressing
                                self.showSlider = (self.tempRaiseValue > self.minValue || pressing)
                            }
                        }) {
                        }
                }
            }
            .frame(width: 130, height: 45)
            .padding(.horizontal, 50)
            .onAppear {
                startArrowAnimation(duration: 1)
            }
            .onChange(of: showSlider) { newSlider in
                if !newSlider {
                    startArrowAnimation(duration: 1)
                }
            }
        }
        .overlay(
            Button {
                actionButton(isAdd: true)
            } label: {
                if showSlider && tempRaiseValue != maxValue {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundColor(.accentColor)
                }
            },alignment: .trailing
        )
        .overlay(
            Button {
                actionButton(isAdd: false)
            } label: {
                if showSlider && tempRaiseValue != minValue {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundColor(.accentColor)
                }
            }
            ,alignment: .leading
        )
    }
    
    private func startArrowAnimation (duration:Double) {
        chipAnimation = false
        showSlider = false

        withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
            chipAnimation = true
        }

        for index in 0..<arrowOpacities.count {
            withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true).delay(duration * Double(index) * 0.5)) {
                arrowOpacities[index] = true
            }
        }
    }

    private func thumbOffset(in size: CGSize) -> CGFloat {
        let sliderWidth = size.width
        let sliderRange = CGFloat(maxValue - minValue)
        
        // Clamping tempRaiseValue to avoid out-of-range values
        let clampedTempRaiseValue = max(minValue, min(maxValue, tempRaiseValue))
        let sliderValue = CGFloat(clampedTempRaiseValue - minValue)
        
        return (sliderWidth * sliderValue / sliderRange)
    }
    
    private func actionButton(isAdd: Bool) {
        if showSlider {
            if isAdd {
                if tempRaiseValue % stepValue != 0 {
                    tempRaiseValue = ((tempRaiseValue / stepValue) + 1) * stepValue
                } else {
                    tempRaiseValue += stepValue
                }
                tempRaiseValue = min(tempRaiseValue, maxValue)
            } else {
                if tempRaiseValue % stepValue != 0 {
                    tempRaiseValue = (tempRaiseValue / stepValue) * stepValue
                } else {
                    tempRaiseValue -= stepValue
                }
                tempRaiseValue = max(tempRaiseValue, minValue)
            }
            raiseValue = tempRaiseValue

            isPressed = false
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = true
            }
            withAnimation(.easeInOut(duration: 0.2).delay(1)) {
                isPressed = false
            }
            showSlider = (tempRaiseValue > minValue || isPressed)
            
        }
    }
}

struct SliderRaise_Previews: PreviewProvider {
    static var previews: some View {
        VStack (alignment: .center) {
            Spacer()
            SliderRaise(raiseValue: .constant(400), minValue: .constant(400), maxValue: .constant(20000))
            Spacer()
        }
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
