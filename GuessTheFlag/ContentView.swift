//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by KK NGAI on 7/4/2022.
//

import SwiftUI

struct FlagImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.white)
            .padding()
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    static let GAME_OVER_COUNT = 8
    
    @State private var scoreTitle = ""
    
    @State private var showingScore = false
    @State private var isGameOver = false
    
    @State private var currentScore = 0
    @State private var answedCount = 0
    @State private var highestScore: Int?
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    var progressString: String {
        let count = (answedCount + 1) >= ContentView.GAME_OVER_COUNT ? ContentView.GAME_OVER_COUNT : (answedCount + 1)
        
        return "Question: \(count)/\(ContentView.GAME_OVER_COUNT)"
    }
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.4),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.6),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .titleStyle()
                
                VStack(spacing: 15) {
                    VStack() {
                        Text("Tap the flag off")
                            .foregroundStyle(.secondary)
                            .font(.title2.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(imageName: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                
                Text(progressString)
                    .foregroundColor(.white)
                    .font(.title3.bold())
                
                Spacer()
                
                HStack() {
                    if(highestScore != nil) {
                        Text("Higest score: \(highestScore!)")
                            .foregroundColor(.white)
                            .font(.title2.bold())
                    }
                
                    Spacer()
                    
                    Text("Current score: \(currentScore)")
                        .foregroundColor(.white)
                        .font(.title3.bold())
                }
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(currentScore)")
        }
        .alert("Game Over!", isPresented: $isGameOver) {
            Button("Restart", action: reset)
        } message: {
            Text("Your final score is \(currentScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if(number == correctAnswer) {
            scoreTitle = "Correct!"
            currentScore += 1
        } else {
            scoreTitle = "Wrong! \n That's the flag of \(countries[number])"
        }
        
        answedCount += 1
        isGameOver = answedCount >= ContentView.GAME_OVER_COUNT
        showingScore = !isGameOver
    }

    func askQuestion() {
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
        // update higest score
        if(currentScore > highestScore ?? 0) {
            highestScore = currentScore
        }
        
        // reset to initial state
        currentScore = 0
        answedCount = 0
        showingScore = false
        isGameOver = false
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
