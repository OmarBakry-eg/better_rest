//
//  ContentView.swift
//  BetterRest
//
//  Created by Omar Bakry on 28/11/2021.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var wakeUp : Date = defaultWakeTime // init
    @State private var sleepAmount : Double = 8.0
    @State private var coffeeAmount : Int = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
  static var defaultWakeTime: Date { // static here to be a view type so it can be access in any var init
        var components = DateComponents()
        components.hour = 7 // auto AM if I wanna pm just add 12 to it to become 19
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    var body: some View {
        NavigationView{
            Form{
               
                VStack(alignment:.leading, spacing: 10) {
                    Spacer()
                    Text("When do you wanna wake up").font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUp,displayedComponents: .hourAndMinute
                    ).labelsHidden() // hidden the "Please enter a time" sentence
                    Spacer().frame(height:1)
                }
               
                VStack(alignment:.leading, spacing: 10) {
                    Spacer()
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount,in: 4...12, step: 0.25)
                    // .formatted to remove extra zeros
                    Spacer().frame(height:1)
                }
            
                VStack(alignment:.leading, spacing: 10) {
                    Spacer()
                    Text("Daily coffee intake")
                        .font(.headline)
                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                    Spacer().frame(height:1)
                }

    
            }.navigationTitle("Better Rest").toolbar(content: {
                Button("Calculate",action: calculateBedtime)
            }).alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    func calculateBedtime() {
        do {
            let config : MLModelConfiguration  = MLModelConfiguration()
            
            let model : SleepCalculator = try SleepCalculator(configuration: config)
            
            //-------------------
            
            let components : DateComponents = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
            let hour : Int? = (components.hour ?? 0) * 60 * 60
            let minute : Int? = (components.minute ?? 0) * 60
            
            //-------------------
            
            
            let prediction : SleepCalculatorOutput = try model.prediction(wake: Double(hour! + minute!), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            
            let sleepTime : Date = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is…"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
            //-------------------
            
        } catch{
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
