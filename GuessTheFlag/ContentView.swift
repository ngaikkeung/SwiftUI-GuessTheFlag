//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by KK NGAI on 7/4/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var currentScore = 0
    @State private var highestScore: Int?
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
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
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 10)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
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
            Button("Reset", role: .cancel, action: reset)
        } message: {
            Text("Your score is \(currentScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if(number == correctAnswer) {
            scoreTitle = "Correct!"
            currentScore += 1
        } else {
            scoreTitle = "Wrong!"
        }
        
        showingScore = true
    }

    func askQuestion() {
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
        if(currentScore > highestScore ?? 0) {
            highestScore = currentScore
        }
        
        currentScore = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
