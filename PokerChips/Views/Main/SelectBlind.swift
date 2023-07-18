//
//  SelectBlind.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 21/6/23.
//

import SwiftUI

struct SelectBlind: View {
    @Binding var bigBlind: Int
    @Binding var raiseBlind: Int
    @Binding var initialStack: Int
    @State var selectedLevel: Int = 1
    @State var selectedTimeLevel: Int = 3
    @State var messageTime: String = "*Partida estándar"
    @State var colorTime: Color = .orange
    let timeArray: [Int] = [3, 5, 15, 20, 30, 60]

    var body: some View {
        HStack (spacing: 20)  {
            //MARK: CIEGA
            VStack (spacing: 8) {
                Text("Selecciona la ciega grande inicial")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .frame(width: 240)
                
                HStack (spacing: 30) {
                    Text("\(calculateBlind(level: selectedLevel)) €")
                        .frame(width: 140, height: 50)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .cornerRadius(40)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.accentColor, lineWidth: 6)
                                .opacity(1)
                        )
                }
                .frame(height: 60)
                .padding(.horizontal, 60)
                .overlay(
                    Button {
                        if selectedLevel < 6 {
                            selectedLevel += 1
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 45, weight: .black, design: .rounded))
                            .foregroundColor(.accentColor)
                            .opacity(selectedLevel < 6 ? 1 : 0.2)
                    },alignment: .trailing
                )
                .overlay(
                    Button {
                        if selectedLevel > 1 {
                            selectedLevel -= 1
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 45, weight: .black, design: .rounded))
                            .foregroundColor(.accentColor)
                            .opacity(selectedLevel > 1 ? 1 : 0.2)
                    },alignment: .leading
                )
                
            }
            Divider()
                .frame(width: 2, height: 90)
                .overlay(Color.accentColor.opacity(0.5))
            
            //MARK: TIEMPO
            VStack (spacing: 10) {
                Text("Cada cuanto se subirá la ciega")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .frame(width: 240)

                HStack (spacing: 30) {
                    Text("\(timeArray[selectedTimeLevel - 1]) min")
                        .frame(width: 140, height: 50)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .cornerRadius(40)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.accentColor, lineWidth: 6)
                                .opacity(1)
                        )
                }
                .frame(height: 60)
                .padding(.horizontal, 60)
                .overlay(
                    Button {
                        if selectedTimeLevel < timeArray.count {
                            selectedTimeLevel += 1
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 45, weight: .black, design: .rounded))
                            .foregroundColor(.accentColor)
                            .opacity(selectedTimeLevel < timeArray.count ? 1 : 0.2)
                    },alignment: .trailing
                )
                .overlay(
                    Button {
                        if selectedTimeLevel > 1 {
                            selectedTimeLevel -= 1
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 45, weight: .black, design: .rounded))
                            .foregroundColor(.accentColor)
                            .opacity(selectedTimeLevel > 1 ? 1 : 0.2)
                    },alignment: .leading
                )
                .overlay(
                    Text(messageTime)
                        .foregroundColor(colorTime)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .offset(y: 45)
                )
            }
        }
        .onAppear {
            bigBlind = calculateBlind(level: selectedLevel)
            raiseBlind = timeArray[selectedTimeLevel - 1]
            updateMessageAndColor()
        }
        .onChange(of: initialStack) { newValueInitial in
            selectedLevel = 1
            bigBlind = calculateBlind(level: 1)
        }
        .onChange(of: selectedLevel) { newLevel in
            bigBlind = calculateBlind(level: newLevel)
        }
        .onChange(of: selectedTimeLevel) { newTimeLevel in
            raiseBlind = timeArray[newTimeLevel - 1]
            updateMessageAndColor()
        }
    }
    func calculateBlind (level: Int) -> Int {
        let initialBlind = initialStack/100

        // Las ciegas se duplican en cada nivel
        let blind = initialBlind * Int(pow(2.0, Double(level - 1)))

        return blind
    }
    
    func updateMessageAndColor() {
        switch selectedTimeLevel {
        case 1:
            messageTime = "*Partida ultra rápida (Hyper-Turbo)"
            colorTime = .red
        case 2:
            messageTime = "*Partida rápida (Turbo)"
            colorTime = .orange
        case 3...4:
            messageTime = "*Partida estándar"
            colorTime = .yellow
        case 5...6:
            messageTime = "*Partida larga (Deep Stack)"
            colorTime = .green
        default:
            messageTime = ""
            colorTime = .clear
        }
    }

}

struct SelectBlind_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Image("background")
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            SelectBlind(bigBlind: .constant(200), raiseBlind: .constant(15), initialStack: .constant(20000))
        }
        .padding()
        .frame(maxWidth: 620, maxHeight: 350)
        .overlay(
            Button {
                
            } label: {
                ButtonStartGame()
            }
            , alignment: .bottom
        )
        .previewInterfaceOrientation(.landscapeLeft)

    }
}
