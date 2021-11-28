//
//  ContentView.swift
//  BetterRest
//
//  Created by Omar Bakry on 28/11/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp : Date = Date.now
    @State private var sleepAmount : Double = 8.0
    @State private var coffeeAmount : Int = 1
    
    var body: some View {
        NavigationView{
            VStack{
                Text("When do you wanna wake up").font(.headline)
                DatePicker("Please enter a time", selection: $wakeUp,displayedComponents: .hourAndMinute
                ).labelsHidden() // hidden the "Please enter a time" sentence
                
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount,in: 4...12, step: 0.25).padding(.horizontal,24)
                // .formatted to remove extra zeros
                Text("Daily coffee intake")
                    .font(.headline)

                Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
            }.navigationTitle("Better Rest").toolbar(content: {
                Button("Calculate",action: calculateBedtime)
            })
        }
    }
    func calculateBedtime() {
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
