//
//  ContentView.swift
//  BetterRest
//
//  Created by Дима РМФ on 21.03.2022.
//
import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
  //  @State private var alertTitle = ""
  //  @State private var alertVessage = ""
  //  @State private var showingAlert = false
    
   static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var bedtime: String {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
        } catch {
            return "Sorry, there was a problem calculating your bedtime."
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter your a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                }
                
                Section(header: Text("Desire amount of sleep")) {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section(header: Text("Daily coffee intake")) {
                    
                    Picker("Coffee intake", selection: $coffeeAmount) {
                        ForEach(1...5, id: \.self) { count in
                            Text("\(count)")
                        }
                    }.pickerStyle(.segmented)
                }
                
                Section(header: Text("Bed time")) {
                    Text("\(bedtime)")
                }
                
            }
            .navigationTitle("BetterRest")
            }
        }
    }
    
    //func calculateBedtime() {
        //do {
          //  let config = MLModelConfiguration()
           // let model = try SleepCalculator(configuration: config)

           // let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
           // let hour = (components.hour ?? 0) * 60 * 60
    // let minute = (components.minute ?? 0) * 60
            
    // let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
    // let sleepTime = wakeUp - prediction.actualSleep
    // alertTitle = "Your ideal bedtime is..."
    // alertVessage = sleepTime.formatted(date: .omitted, time: .shortened)

    // } catch {
            // Something went wrong
    // alertTitle = "Error"
    // alertVessage = "Sorry, there was a problem calculating your bedtime."
    // }
    // showingAlert = true
    //}
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
