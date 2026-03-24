import SwiftUI

import SwiftUI

struct DynamicPrimaryButtonStyle: ButtonStyle {
    var backgroundColor: Color
    var foregroundColor: Color
    var isFullWidth: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .padding(.horizontal, isFullWidth ? 0 : 16)
            .padding(.vertical, 12)
            .background(backgroundColor)
            .cornerRadius(6)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct PrimaryButton: View {
    let title: String
    var iconName: String? = nil
    var backgroundColor: Color = Color(hex: "#353535")
    var foregroundColor: Color = .white
    
    // Some contexts (like Toolbars) might not want an infinity width
    var isFullWidth: Bool = true
    
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let iconName = iconName {
                    Image(iconName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                }
                Text(title)
                    .font(.custom("Inter", size: 16))
                    .fontWeight(.regular)
            }
            .foregroundColor(foregroundColor)
        }
        .buttonStyle(DynamicPrimaryButtonStyle(backgroundColor: backgroundColor, foregroundColor: foregroundColor, isFullWidth: isFullWidth))
    }
}
