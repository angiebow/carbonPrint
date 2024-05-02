//
//  ContentView.swift
//  carbonPrint
//
//  Created by Pelangi Masita Wati on 29/04/24.
//

import SwiftUI
import SwiftData

struct CalculateView: View {
    @Environment(\.modelContext) private var context
    
    @State private var totalFootprint: Double = 0
    @AppStorage("totalFootprint") var totalStor = 0.0
    
    @State private var gasBill: Double = 0
    @AppStorage("gasBill") var gas = 0.0
    
    @State private var electricBill: Double = 0
    @AppStorage("electricBill") var electric = 0.0
    
    @State private var oilBill: Double = 0
    @AppStorage("oilBill") var oil = 0.0
    
    @State private var flightsLess: Double = 0
    @AppStorage("flightsLess") var less = 0.0
    
    @State private var flightsMore: Double = 0
    @AppStorage("flightsMore") var more = 0.0
    
    @State private var carTravel: Double = 0
    @AppStorage("carTravel") var car = 0.0
    
    @State private var recycleNews: Bool = false
    @AppStorage("recycleNews") var news = 0.0
    
    @State private var recycleTin: Bool = false
    @State private var showUp: Result?
    
    @State private var text = ""
    @AppStorage("NUMBER_KEY") var savedText = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Gas Bill")) {
                    TextField("Enter gas bill", value: $gasBill, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .onChange(of: gasBill) { gasBill in
                            self.gas = gasBill
                        }
                        .onAppear {
                            self.gasBill = gas
                        }
                }
                
                Section(header: Text("Electric Bill")) {
                    TextField("Enter electric bill", value: $electricBill, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .onChange(of: electricBill) { electricBill in
                            self.electric = electricBill
                        }
                        .onAppear {
                            self.electricBill = electric
                        }
                }
                
                Section(header: Text("Oil Bill")) {
                    TextField("Enter oil bill", value: $oilBill, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .onChange(of: oilBill) { oilBill in
                            self.oil = oilBill
                        }
                        .onAppear {
                            self.oilBill = oil
                        }
                }
                
                Section(header: Text("Flights <4 Hours")) {
                    TextField("Enter flights", value: $flightsLess, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .onChange(of: flightsLess) { flightLess in
                            self.less = flightLess
                        }
                        .onAppear {
                            self.flightsLess = less
                        }
                }
                
                Section(header: Text("Flights >4 Hours")) {
                    TextField("Enter flights", value: $flightsMore, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .onChange(of: flightsMore) { flightsMore in
                            self.more = flightsMore
                        }
                        .onAppear {
                            self.flightsMore = more
                        }
                }
                
                Section(header: Text("Car Travel")) {
                    TextField("Enter car travel", value: $carTravel, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .onChange(of: totalFootprint) { totalFootprint in
                            self.totalStor = totalFootprint
                        }
                        .onAppear {
                            self.totalFootprint = totalStor
                        }
                }
                
                Section(header: Text("Recycle")) {
                    Toggle("Newspaper", isOn: $recycleNews)
                }
                
                Section(header: Text("Recycle")) {
                    Toggle("Aluminum & Tin", isOn: $recycleTin)
                }
                
                Section(header: Text("Result")) {
                    Text("Your Carbon Footprint is")
                        .font(.headline)
                        .padding(.bottom, 10)
                    
                    Text("\(String(format: "%.2f", totalFootprint))")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.red)
                        .onChange(of: carTravel) { carTravel in
                            self.car = carTravel
                        }
                        .onAppear {
                            self.carTravel = car
                        }
                }
                
                
                
                Button("Calculate") {
                    calculateFootprint()
                }
                
                Button("Suggestion") {
                    calculateFootprint()
                    showUp = Result(message: Int(totalFootprint))
                }
                .popover(item: $showUp) { detail in
                    ModalView(footprint: Double(detail.message))
                }
                
                Button("Reset") {
                    gasBill = 0
                    electricBill = 0
                    oilBill = 0
                    flightsLess = 0
                    flightsMore = 0
                    carTravel = 0
                    totalFootprint = 0
                    recycleNews = false
                    recycleTin = false
                }
                
            }
            .navigationTitle("Calculate")
        }
    }
    
    private func calculateFootprint() {
        let electricFootprint = electricBill * 105
        let gasFootprint = gasBill * 105
        let oilBillFootprint = oilBill * 113
        let flightFootprintLess = flightsLess * 1100
        let flightFootprintMore = flightsMore * 4400
        let carFootprint = carTravel * 0.79
        let recycleFootprintN = recycleNews ? 0 : 184
        let recycleFootprintT = recycleTin ? 0 : 166
        
        totalFootprint = electricFootprint + gasFootprint + flightFootprintLess + flightFootprintMore + carFootprint + oilBillFootprint + Double(recycleFootprintN) + Double(recycleFootprintT)
    }
}

struct ModalView: View {
    @Environment(\.modelContext) private var context
    @State private var isSaved: Bool = false
    
    let footprint: Double
        
    var body: some View {
        VStack {
            Spacer()
            Section(header: Text("Result")) {
                Text("Your Carbon Footprint is")
                    .font(.headline)
                    .padding(.bottom, 10)
                
                Text("\(String(format: "%.2f", footprint))")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.red)
            }
            
            Button("Save", action: save)
                .buttonStyle(.bordered)
            
            if footprint < 6000 {
                Text("Your carbon footprint is very low! Keep up the good work.")
                    .padding()
            } else if footprint < 16000 {
                Text("Your carbon footprint is low. Consider additional green practices to reduce it further:")
                    .padding()
                
                Text("- Reduce car travel and use public transport, cycling, or walking whenever possible.")
                Text("- Invest in energy-efficient appliances and light bulbs.")
                Text("- Shorten showers and conserve water.")
            } else if footprint < 22000 {
                Text("Your carbon footprint is average. You can reduce it by adopting more sustainable habits:")
                    .padding()
                
                Text("- Reduce meat consumption and eat more plant-based meals.")
                Text("- Fly less often and consider alternative travel options.")
                Text("- Plant trees to offset your carbon emissions.")
            } else {
                Text("Your carbon footprint is high. It's time to seriously consider reducing it with green practices:")
                    .padding()
                
                Text("- Consider switching to renewable energy sources like solar power.")
                Text("- Reduce your overall consumption and buy less stuff.")
                Text("- Support organizations working to combat climate change.")
            }

            Spacer()
        }
    }
    
    private func save() {
        let item = DataItem(name: "\(footprint)")
        context.insert(item)
        try? context.save()
        isSaved = true
    }
}

struct Result: Identifiable {
    var id: Int { message }
    let message: Int
}

struct CalculateView_Previews: PreviewProvider {
    static var previews: some View {
        CalculateView()
    }
}
