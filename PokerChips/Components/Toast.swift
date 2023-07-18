//
//  Toast.swift
//  PokerChips
//
//  Created by Samuel Carcasés on 2/6/23.
//

import SwiftUI

enum FancyToastStyle {
    case error
    case warning
    case success
    case info
    var themeColor: Color {
        switch self {
        case .error: return Color.red
        case .warning: return Color.orange
        case .info: return Color.blue
        case .success: return Color.green
        }
    }
    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        }
    }
    var feedback: UINotificationFeedbackGenerator.FeedbackType {
        switch self {
        case .info: return .warning
        case .warning: return .warning
        case .success: return .success
        case .error: return .error
        }
    }
}


struct Toast: View {
    var type: FancyToastStyle
    var title: String
    var message: String
    @Binding var showToast: Bool
    var duration: TimeInterval? = 3
    @State var animateHeight: Bool = false
    @State var animateWidth: Bool = false

    let toastHeight: CGFloat = 55
    let toastWidth: CGFloat = 250

    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(
                    LinearGradient(gradient: Gradient(colors: [type.themeColor, type.themeColor.opacity(0.5)]), startPoint: .bottomLeading, endPoint: .topTrailing)
                )
                .foregroundStyle(.white)
                .frame(width: animateWidth ? toastWidth : 4, height: animateHeight ? toastHeight : 4)
                .shadow(radius: 4)
            
            Group {
                HStack(alignment: .center, spacing: 15) {
                    Image(systemName: type.iconFileName)
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundColor(.white)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.system(size: 12, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(message)
                            .font(.system(size: 10, weight: .black, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                .frame(width: toastWidth, height: toastHeight)
            }
            .frame(width: animateWidth ? toastWidth : 4, height: animateHeight ? toastHeight : 4)
            .clipped()
        }
        .padding()
        .frame(width: toastWidth, height: toastHeight)
        .opacity(showToast ? 1 : 0)
        .onAppear {
            if showToast {
                showToastAnimation()
            }
        }
        .onChange(of: showToast) { showToastNew in
            if showToastNew {
                showToastAnimation()
            }
        }
    }
    
    func showToastAnimation() {
        Feedback.vibrateType(style: type.feedback)
        showToast = false
        animateHeight = false
        animateWidth = false
        withAnimation(.easeInOut(duration: 0.1)) {
            showToast = true
        }
        withAnimation(.easeInOut(duration: 0.05).delay(0.1)) {
            animateHeight = true
        }
        withAnimation(.easeInOut(duration: 0.1).delay(0.15)) {
            animateWidth = true
        }
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + (duration ?? 2)) {
        withAnimation(.easeInOut(duration: 0.5).delay(duration ?? 2)) {
            showToast = false
        }
    }
}

struct Toast_Previews: PreviewProvider {
    static var previews: some View {
        Toast(type: .error, title: "Error", message: "El Alias debe contener al menos 3 caracteres", showToast: .constant(true))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
