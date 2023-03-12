//
//  ContentView.swift
//  2.Guess the Flag
//
//  Created by Григорий Ковалев on 16.01.2023.
//

import SwiftUI

struct flagImage: View {
    let number: Int
    
    let countries: [String]
    
    var body: some View {
        Image(countries[number])
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 20)
    }
}

struct CustomMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.teal)
            .padding()
    }
}

extension View {
    func titleCM() -> some View {
        modifier(CustomMod())
    }
}

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US", "Monaco"].shuffled()
    @State private var correctAnswer = Int.random(in: 0..<3)
    @State private var result = 0
    
    @State private var degrees = 0.0
    @State private var selection: Int? = nil
    
    @State private var animOP = 1.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack (spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .font(.subheadline.weight(.heavy))
                    Text(countries[correctAnswer])
                        .font(.largeTitle.weight(.semibold))
                        .titleCM()
                }
                .foregroundColor(.white)
                
                ForEach(0..<3) { number in
                    Button {
                        selection = number
                        flagTapped(number)
                    } label: {
                        flagImage(number: number, countries: countries)
                    }
                    .rotation3DEffect(.degrees(selection == number ? degrees : 0), axis: (x: 0, y: 1, z: 0))
                    .opacity(selection != number ? 0.25 : 0.25)
                    .animation(.easeIn(duration: 3), value: animOP)
                }
            }
        }.alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(result)")
        }
    }
    
    func flagTapped(_ number: Int) {
        
        withAnimation(.easeIn(duration: 3)) {
            degrees += 360
        }
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            result += 1
            if result > 7 {
                scoreTitle = "The end! Your score is 8 of 8"
            }
        }  else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            result -= 1
            if result < 0 {
                result = 0
            }
        }
        selection = nil
         showingScore = true
        
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0..<3)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
