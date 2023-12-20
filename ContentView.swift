import SwiftUI

enum SwipeDirection{
    case left, right
}

struct ContentView: View {
    
    @State private var score: Int = 0;
    @State private var combo: Int = 0;
    @State private var remainingTime: Int = 10
    @State private var isCountingDown: Bool = false
    @State private var isGameOver: Bool = false
    
    @State private var currentImage: String = "greenUp"
    
    var body: some View {
                
        ZStack{
            Rectangle()
                .foregroundColor(Color.blue.opacity(0.5))
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Score: \(score)").font(.system(size: 24, weight: .bold))
                Text("Combo: \(combo)").font(.system(size: 24, weight: .bold))
                Text("Time: \(remainingTime)").font(.system(size: 24, weight: .bold))
                Text("                           ")
                    
            }
            .tag("GameInfoStack")
            .padding()
            .position(CGPoint(x: 80.0, y: 70.0))
            
            ZStack{
                
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.0))
                    .frame(width: 250, height: 250)
                
                Image(currentImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .gesture(DragGesture()
                        .onEnded{
                            value in handleSwipe(value)
                            startCountdown()
                        }
                    )
            }
            
            if isGameOver {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.5))
                    .ignoresSafeArea()

                VStack {
                Text("Game Over")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    func startCountdown() {
        if !isCountingDown {
            isCountingDown = true
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    timer.invalidate()
                    isCountingDown = false
                    setTime()
                    resetScore()
                    resetCombo()
                    displayGameover()
                }
            }
        }
    }
    
    private func handleSwipe(_ drag: DragGesture.Value) {

        if drag.startLocation.x < drag.location.x {
            // Swiped right
            if currentImage == "redDown" || currentImage == "greenDown"{
                print("Correct!")
                score += 1
                combo += 1
            } else {
                print("Incorrect!")
                score -= 1
                combo = 0
            }

        } else if drag.startLocation.x > drag.location.x{
            // Swiped left
            if currentImage == "greenUp" || currentImage == "redUp" {
                print("Correct!")
                score += 1
                combo += 1
            } else {
                print("Incorrect!")
                score -= 1
                combo = 0
            }
        }

        // Next image
        currentImage = ["greenUp", "greenDown", "redUp", "redDown"].randomElement()!
    }
    
    private func resetScore(){
        score = 0
    }
    
    private func resetCombo(){
        combo = 0
    }
    
    private func setTime(){
        remainingTime = 10
    }
    
    private func displayGameover(){
        isGameOver = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isGameOver = false
        }
    }
}


#Preview {
    ContentView()
}
