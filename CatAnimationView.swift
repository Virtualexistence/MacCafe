//
//  CatAnimationView.swift
//  MacCafe
//
//  Created on November 8, 2025
//

import SwiftUI

struct CatAnimationView: View {
    let isActive: Bool
    @State private var animationPhase: Double = 0
    @State private var tailWag: Double = 0
    @State private var eyeBlink: Bool = false
    @State private var sipAnimation: Double = 0
    @State private var steamAnimation: Double = 0
    @State private var catPosition: CGFloat = 0
    @State private var isJumping: Bool = false
    @State private var pawAnimation: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.98, green: 0.95, blue: 0.92),
                                   Color(red: 0.95, green: 0.9, blue: 0.85)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                // Table/Surface
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(red: 0.6, green: 0.4, blue: 0.2))
                    .frame(width: geometry.size.width, height: 30)
                    .position(x: geometry.size.width / 2, y: geometry.size.height - 15)
                
                // Coffee Mug
                CoffeeMugView(isActive: isActive, steamAnimation: steamAnimation)
                    .frame(width: 60, height: 80)
                    .position(x: geometry.size.width * 0.75, y: geometry.size.height - 60)
                
                // Cat
                if isActive {
                    // Active state - cat sipping coffee
                    ActiveCatView(
                        sipAnimation: sipAnimation,
                        tailWag: tailWag,
                        eyeBlink: eyeBlink,
                        pawAnimation: pawAnimation
                    )
                    .frame(width: 100, height: 100)
                    .position(x: geometry.size.width * 0.75 - 50, y: geometry.size.height - 80)
                } else {
                    // Idle state - cat playing around
                    IdleCatView(
                        animationPhase: animationPhase,
                        tailWag: tailWag,
                        eyeBlink: eyeBlink,
                        catPosition: catPosition,
                        isJumping: isJumping
                    )
                    .frame(width: 80, height: 80)
                    .position(
                        x: geometry.size.width * 0.3 + catPosition,
                        y: geometry.size.height - 70 - (isJumping ? 30 : 0)
                    )
                }
            }
        }
        .onAppear {
            startAnimations()
        }
        .onChange(of: isActive) { _ in
            resetAnimations()
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Tail wagging
        withAnimation(
            Animation.easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
        ) {
            tailWag = 30
        }
        
        // Eye blinking
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.2)) {
                eyeBlink = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    eyeBlink = false
                }
            }
        }
        
        if isActive {
            // Sipping animation
            withAnimation(
                Animation.easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
            ) {
                sipAnimation = 1
            }
            
            // Steam animation
            withAnimation(
                Animation.linear(duration: 3.0)
                    .repeatForever(autoreverses: false)
            ) {
                steamAnimation = 1
            }
            
            // Paw animation
            withAnimation(
                Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            ) {
                pawAnimation = 1
            }
        } else {
            // Cat movement for idle state
            withAnimation(
                Animation.easeInOut(duration: 4.0)
                    .repeatForever(autoreverses: true)
            ) {
                catPosition = 100
            }
            
            // Jumping animation
            Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
                withAnimation(.easeOut(duration: 0.3)) {
                    isJumping = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeIn(duration: 0.3)) {
                        isJumping = false
                    }
                }
            }
            
            // General animation phase
            withAnimation(
                Animation.linear(duration: 2.0)
                    .repeatForever(autoreverses: false)
            ) {
                animationPhase = 1
            }
        }
    }
    
    private func resetAnimations() {
        animationPhase = 0
        tailWag = 0
        eyeBlink = false
        sipAnimation = 0
        steamAnimation = 0
        catPosition = 0
        isJumping = false
        pawAnimation = 0
    }
}

struct ActiveCatView: View {
    let sipAnimation: Double
    let tailWag: Double
    let eyeBlink: Bool
    let pawAnimation: Double
    
    var body: some View {
        ZStack {
            catBody
            catHead
            catEars
            catEyes
            catNose
            catPaws
            catTail
            catWhiskers
        }
    }
    
    private var catBody: some View {
        Ellipse()
            .fill(Color(red: 0.3, green: 0.3, blue: 0.3))
            .frame(width: 60, height: 45)
            .rotationEffect(.degrees(-10 + sipAnimation * 5))
    }
    
    private var catHead: some View {
        Circle()
            .fill(Color(red: 0.3, green: 0.3, blue: 0.3))
            .frame(width: 35, height: 35)
            .offset(x: 20, y: -15 - sipAnimation * 3)
    }
    
    private var catEars: some View {
        ForEach([0, 1], id: \.self) { i in
            Triangle()
                .fill(Color(red: 0.3, green: 0.3, blue: 0.3))
                .frame(width: 12, height: 15)
                .rotationEffect(.degrees(i == 0 ? -30 : 30))
                .offset(
                    x: 20 + (i == 0 ? -10 : 10),
                    y: -30 - sipAnimation * 3
                )
        }
    }
    
    private var catEyes: some View {
        ForEach([0, 1], id: \.self) { i in
            Circle()
                .fill(eyeBlink ? Color(red: 0.3, green: 0.3, blue: 0.3) : Color.yellow)
                .frame(width: eyeBlink ? 6 : 8, height: eyeBlink ? 2 : 8)
                .offset(
                    x: 20 + (i == 0 ? -7 : 7),
                    y: -15 - sipAnimation * 3
                )
        }
    }
    
    private var catNose: some View {
        Circle()
            .fill(Color.pink)
            .frame(width: 4, height: 4)
            .offset(x: 20, y: -10 - sipAnimation * 3)
    }
    
    private var catPaws: some View {
        Group {
            Ellipse()
                .fill(Color(red: 0.3, green: 0.3, blue: 0.3))
                .frame(width: 15, height: 25)
                .rotationEffect(.degrees(45 + pawAnimation * 10))
                .offset(x: 35, y: 5)
            
            Ellipse()
                .fill(Color(red: 0.3, green: 0.3, blue: 0.3))
                .frame(width: 15, height: 25)
                .rotationEffect(.degrees(-45 - pawAnimation * 10))
                .offset(x: 45, y: 5)
        }
    }
    
    private var catTail: some View {
        Path { path in
            path.move(to: CGPoint(x: -20, y: 0))
            path.addQuadCurve(
                to: CGPoint(x: -40, y: -20),
                control: CGPoint(x: -30 - tailWag / 3, y: -10 + tailWag / 2)
            )
        }
        .stroke(Color(red: 0.3, green: 0.3, blue: 0.3), lineWidth: 8)
    }
    
    private var catWhiskers: some View {
        Group {
            // Left whiskers
            Path { path in
                let xOffset: CGFloat = 20 - 15
                let yOffset: CGFloat = -10 - sipAnimation * 3
                path.move(to: CGPoint(x: xOffset, y: yOffset))
                path.addLine(to: CGPoint(x: xOffset - 15, y: yOffset))
            }
            .stroke(Color.gray, lineWidth: 1)
            
            Path { path in
                let xOffset: CGFloat = 20 - 15
                let yOffset: CGFloat = -10 - sipAnimation * 3 + 3
                path.move(to: CGPoint(x: xOffset, y: yOffset))
                path.addLine(to: CGPoint(x: xOffset - 15, y: yOffset))
            }
            .stroke(Color.gray, lineWidth: 1)
            
            // Right whiskers
            Path { path in
                let xOffset: CGFloat = 20 + 15
                let yOffset: CGFloat = -10 - sipAnimation * 3
                path.move(to: CGPoint(x: xOffset, y: yOffset))
                path.addLine(to: CGPoint(x: xOffset + 15, y: yOffset))
            }
            .stroke(Color.gray, lineWidth: 1)
            
            Path { path in
                let xOffset: CGFloat = 20 + 15
                let yOffset: CGFloat = -10 - sipAnimation * 3 + 3
                path.move(to: CGPoint(x: xOffset, y: yOffset))
                path.addLine(to: CGPoint(x: xOffset + 15, y: yOffset))
            }
            .stroke(Color.gray, lineWidth: 1)
        }
    }
}

struct IdleCatView: View {
    let animationPhase: Double
    let tailWag: Double
    let eyeBlink: Bool
    let catPosition: CGFloat
    let isJumping: Bool
    
    var body: some View {
        ZStack {
            catBody
            catHead
            catEars
            catEyes
            catNose
            catFrontPaws
            catBackPaws
            catTail
            catWhiskers
        }
    }
    
    private var catBody: some View {
        Ellipse()
            .fill(Color(red: 0.3, green: 0.3, blue: 0.3))
            .frame(width: 50, height: 40)
            .rotationEffect(.degrees(isJumping ? -15 : 0))
    }
    
    private var catHead: some View {
        Circle()
            .fill(Color(red: 0.3, green: 0.3, blue: 0.3))
            .frame(width: 30, height: 30)
            .offset(x: 15, y: -12)
    }
    
    private var catEars: some View {
        ForEach([0, 1], id: \.self) { i in
            Triangle()
                .fill(Color(red: 0.3, green: 0.3, blue: 0.3))
                .frame(width: 10, height: 12)
                .rotationEffect(.degrees(i == 0 ? -30 : 30))
                .offset(
                    x: 15 + (i == 0 ? -8 : 8),
                    y: -25
                )
        }
    }
    
    private var catEyes: some View {
        ForEach([0, 1], id: \.self) { i in
            Circle()
                .fill(eyeBlink ? Color(red: 0.3, green: 0.3, blue: 0.3) : Color.green)
                .frame(width: eyeBlink ? 5 : 6, height: eyeBlink ? 2 : 6)
                .offset(
                    x: 15 + (i == 0 ? -5 : 5),
                    y: -12
                )
        }
    }
    
    private var catNose: some View {
        Circle()
            .fill(Color.pink)
            .frame(width: 3, height: 3)
            .offset(x: 15, y: -8)
    }
    
    private var catFrontPaws: some View {
        Group {
            Ellipse()
                .fill(Color(red: 0.3, green: 0.3, blue: 0.3))
                .frame(width: 12, height: 20)
                .rotationEffect(.degrees(isJumping ? -20 : sin(animationPhase * .pi * 2) * 20))
                .offset(x: 5, y: 10)
            
            Ellipse()
                .fill(Color(red: 0.3, green: 0.3, blue: 0.3))
                .frame(width: 12, height: 20)
                .rotationEffect(.degrees(isJumping ? 20 : -sin(animationPhase * .pi * 2) * 20))
                .offset(x: 25, y: 10)
        }
    }
    
    private var catBackPaws: some View {
        Group {
            Ellipse()
                .fill(Color(red: 0.3, green: 0.3, blue: 0.3))
                .frame(width: 12, height: 18)
                .offset(x: -10, y: 10)
            
            Ellipse()
                .fill(Color(red: 0.3, green: 0.3, blue: 0.3))
                .frame(width: 12, height: 18)
                .offset(x: 10, y: 10)
        }
    }
    
    private var catTail: some View {
        Path { path in
            path.move(to: CGPoint(x: -15, y: 0))
            path.addQuadCurve(
                to: CGPoint(x: -35, y: -25),
                control: CGPoint(x: -25 - tailWag / 3, y: -10 + tailWag / 2)
            )
        }
        .stroke(Color(red: 0.3, green: 0.3, blue: 0.3), lineWidth: 7)
    }
    
    private var catWhiskers: some View {
        Group {
            // Left whiskers
            Path { path in
                let xOffset: CGFloat = 15 - 12
                let yOffset: CGFloat = -8
                path.move(to: CGPoint(x: xOffset, y: yOffset))
                path.addLine(to: CGPoint(x: xOffset - 12, y: yOffset))
            }
            .stroke(Color.gray, lineWidth: 0.8)
            
            Path { path in
                let xOffset: CGFloat = 15 - 12
                let yOffset: CGFloat = -8 + 3
                path.move(to: CGPoint(x: xOffset, y: yOffset))
                path.addLine(to: CGPoint(x: xOffset - 12, y: yOffset))
            }
            .stroke(Color.gray, lineWidth: 0.8)
            
            // Right whiskers
            Path { path in
                let xOffset: CGFloat = 15 + 12
                let yOffset: CGFloat = -8
                path.move(to: CGPoint(x: xOffset, y: yOffset))
                path.addLine(to: CGPoint(x: xOffset + 12, y: yOffset))
            }
            .stroke(Color.gray, lineWidth: 0.8)
            
            Path { path in
                let xOffset: CGFloat = 15 + 12
                let yOffset: CGFloat = -8 + 3
                path.move(to: CGPoint(x: xOffset, y: yOffset))
                path.addLine(to: CGPoint(x: xOffset + 12, y: yOffset))
            }
            .stroke(Color.gray, lineWidth: 0.8)
        }
    }
}

struct CoffeeMugView: View {
    let isActive: Bool
    let steamAnimation: Double
    
    var body: some View {
        ZStack {
            // Mug body
            RoundedRectangle(cornerRadius: 5)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.8, green: 0.7, blue: 0.6),
                               Color(red: 0.7, green: 0.6, blue: 0.5)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 40, height: 50)
            
            // Mug rim
            Ellipse()
                .fill(Color(red: 0.75, green: 0.65, blue: 0.55))
                .frame(width: 42, height: 8)
                .offset(y: -25)
            
            // Coffee inside
            Ellipse()
                .fill(Color(red: 0.2, green: 0.1, blue: 0.05))
                .frame(width: 36, height: 6)
                .offset(y: -23)
            
            // Handle
            Path { path in
                path.move(to: CGPoint(x: 20, y: -10))
                path.addCurve(
                    to: CGPoint(x: 20, y: 10),
                    control1: CGPoint(x: 35, y: -10),
                    control2: CGPoint(x: 35, y: 10)
                )
            }
            .stroke(Color(red: 0.75, green: 0.65, blue: 0.55), lineWidth: 4)
            
            // Coffee shop logo (simple heart)
            Image(systemName: "heart.fill")
                .font(.system(size: 12))
                .foregroundColor(Color(red: 0.9, green: 0.8, blue: 0.7))
            
            // Steam (when active)
            if isActive {
                ForEach(0..<3) { i in
                    Path { path in
                        let xOffset = -5 + Double(i * 10)
                        path.move(to: CGPoint(x: xOffset, y: -30))
                        path.addCurve(
                            to: CGPoint(x: xOffset + 5, y: -50),
                            control1: CGPoint(x: xOffset - 3, y: -35),
                            control2: CGPoint(x: xOffset + 3, y: -45)
                        )
                    }
                    .stroke(
                        Color.white.opacity(0.6 - steamAnimation * 0.4),
                        lineWidth: 2
                    )
                    .offset(y: -steamAnimation * 20)
                }
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}

#Preview {
    CatAnimationView(isActive: true)
        .frame(width: 400, height: 200)
}
