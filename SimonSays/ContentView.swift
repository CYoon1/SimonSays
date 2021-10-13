//
//  ContentView.swift
//  SimonSays
//
//  Created by Christopher Yoon on 10/10/21.
//

import SwiftUI

struct ContentView: View {
    @State var currentColor = ""
    @State var color = Color.black
    @State var colorStringArray: [String] = []
    @State var randomColorArray: [String] = []
    @State var newRandom: String = ""
    @State private var counter = 0
    @State var displayCycle = ""
    
    @State private var numberOfSays = 1
    
    @State var isTimerRunning = false
    @State private var startTime = Date()
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var displayColorArray: [Color] = []
    @State var cycleColor = Color.black
    @State private var showingAlert = false
    @State var alertMessage = ""
    
    @State var pulse = false
    
    @State var highlightYellow = false
    @State var highlightBlue = false
    @State var highlightRed = false
    @State var highlightGreen = false
    
    let maxColors = 6
    
    var body: some View {
        VStack {
            Text(currentColor == "" ? "None" : currentColor)
                .foregroundColor(color)
                .padding()
                .frame(width: 200, height: 40)
                .border(color, width: 5)
            
            Text("\(displayCycle)")
                .foregroundColor(cycleColor)
                .padding()
                .frame(width: 200, height: 40)
                .border(cycleColor, width: 5)
                .onReceive(timer) { _ in
                    if isTimerRunning {
                        if !randomColorArray.isEmpty {
                            if pulse {
                                if self.counter >= randomColorArray.count {
                                    counter = 0
                                    isTimerRunning = false
                                    displayCycle = ""
                                    cycleColor = Color.black
                                } else {
                                    displayCycle = randomColorArray[self.counter]
                                    cycleColor = displayColorArray[self.counter]
                                    print(self.counter)
                                    print("Color is \(randomColorArray[self.counter])")
                                    self.counter += 1
                                }
                                pulse = false
                            } else {
                                cycleColor = Color.black
                                displayCycle = ""
                                pulse = true
                            }
                        } else {
                            counter = 0
                            isTimerRunning = false
                        }
                    }
                }
            HStack {
                Button {
                    isTimerRunning = true
                } label: {
                    HStack {
                        Text("Play Sequence")
                            .padding()
                            .frame(width: 150, height: 40)
                            .border(Color.black, width: 5)
                    }
                }
                Button {
                    generateSequence()
                    isTimerRunning = true
                } label: {
                    Text("New Sequence")
                        .padding()
                        .frame(width: 150, height: 40)
                        .border(Color.black, width: 5)
                }
            }
            
            Picker("How Many Items", selection: $numberOfSays) {
                ForEach((1...maxColors), id: \.self) {
                    Text("\($0)").tag($0)
                }
            }
            .padding()
            .pickerStyle(.segmented)
            
            Group {
                Spacer()
                VStack {
                    HStack {
                        Button {
                            currentColor = "Yellow"
                            color = Color.yellow
                            colorStringArray.append("Yellow")
                            checkWin()
                        } label: {
                            ColorButtonView(title: "Yellow", color: Color.yellow)
                        }
                        Button {
                            currentColor = "Blue"
                            color = Color.blue
                            colorStringArray.append("Blue")
                            checkWin()
                        } label: {
                            ColorButtonView(title: "Blue", color: Color.blue)
                        }
                    }
                    HStack {
                        Button {
                            currentColor = "Red"
                            color = Color.red
                            colorStringArray.append("Red")
                            checkWin()
                        } label: {
                            ColorButtonView(title: "Red", color: Color.red)
                        }
                        Button {
                            currentColor = "Green"
                            color = Color.green
                            colorStringArray.append("Green")
                            checkWin()
                        } label: {
                            ColorButtonView(title: "Green", color: Color.green)
                        }
                    }
                }
                Spacer()
                if #available(iOS 15.0, *) {
                    Button {
                        checkWin()
                    } label: {
                        Text("Check Answer")
                    }
                    .alert(Text(alertMessage), isPresented: $showingAlert) {
                        Text(alertMessage)
                    }
                } else {
                    // Fallback on earlier versions
                    Button {
                        checkWin()
                    } label: {
                        Text("Check Answer")
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Important message"), message: Text(alertMessage), dismissButton: .default(Text("Got it!")))
                    }
                }

                Button {
                    resetDisplay()
                    numberOfSays = 1
                } label: {
                    Text("Reset")
                        .padding()
                        .frame(width: 100, height: 40)
                        .border(Color.black, width: 5)
                }
                
            }
        }
    }
    func generateSequence() {
        resetDisplay()
        for _ in 1...numberOfSays {
            let randNum = Int.random(in: 0..<4)
            if randNum == 0 {
                randomColorArray.append("Yellow")
                displayColorArray.append(Color.yellow)
            } else if randNum == 1 {
                randomColorArray.append("Blue")
                displayColorArray.append(Color.blue)
            } else if randNum == 2 {
                randomColorArray.append("Red")
                displayColorArray.append(Color.red)
            } else if randNum == 3 {
                randomColorArray.append("Green")
                displayColorArray.append(Color.green)
            }
        }
    }
    func checkWin() {
        // check if too many input elements
        userInputOverflow()
        if (!colorStringArray.isEmpty || !randomColorArray.isEmpty) && (colorStringArray.count == randomColorArray.count) {
            if colorStringArray == randomColorArray {
                alertMessage = "You Win!"
                showingAlert = true
                currentColor = ""
                color = Color.black
                if(numberOfSays < maxColors) {
                    numberOfSays += 1
                }
                generateSequence()
            } else {
                alertMessage = "You Lose!"
                showingAlert = true
                currentColor = ""
                colorStringArray = []
                color = Color.black
            }
        }
    }
    func userInputOverflow() {
        if colorStringArray.count > randomColorArray.count {
            // Triggers when user input has more elements than the random color array
            colorStringArray = []
            // clears the array of user inputs.
            currentColor = ""
            color = Color.black
        } else {
            //
            return
        }
    }
    
    func resetDisplay() {
        colorStringArray = []
        randomColorArray = []
        displayColorArray = []
        currentColor = ""
        displayCycle = ""
        color = Color.black
        cycleColor = Color.black
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ColorButtonView: View {
    var title: String
    var color: Color
    
    var body: some View {
        Text(title)
            .foregroundColor(color)
            .fontWeight(.bold)
            .font(.headline)
            .padding()
            .frame(width: 100, height: 100)
            .border(color, width: 5)
    }
}
