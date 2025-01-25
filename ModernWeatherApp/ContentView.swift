//
//  ContentView.swift
//  ModernWeatherApp
//
//  Created by Trevor Bedson on 1/24/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @StateObject var weather = WeatherModel.shared
    @ObservedObject var locationsHandler = LocationsHandler.shared
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                TemperatureSlider(weatherData: weather.data)
                
                Text("Weather - \(locationsHandler.city)")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: getScreenBounds().height * 0.6, alignment: .top)
            .foregroundStyle(.white)
            .background(
                Color(#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1))
            )
            .mask(
                Path { path in
                    let width = getScreenBounds().width
                    let height = getScreenBounds().height
                    path.move(to: CGPoint(x: 0, y: height))
                    path.addLine(to: CGPoint(x: 0, y: 20))
                    path.addQuadCurve(
                        to: CGPoint(x: width, y: 20),
                        control: CGPoint(x: width / 2, y: -5)
                    )
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.closeSubpath()
                }
            )
            
        }
    
    }
    
}


#Preview {
    ContentView()
}

struct TemperatureSlider: View {
    private var cards: [HourWeatherCard] = []
    
    init(weatherData: WeatherData) {
        weatherData.hourly.forEach { data in
            var type: WeatherType = .sunny
            if data.cloudCoverage > 0.5 {
                type = .cloudy
            }
            cards.append(
                HourWeatherCard(type: type,
                                temp: data.temperature2m,
                                time: Double(data.time))
            )
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                Spacer()
                ForEach(cards, id: \.self) { card in
                    card
                }
                Spacer()
            }
            .frame(alignment: .leading)
        }
        .frame(width: .infinity)
        .padding(EdgeInsets(top: 40, leading: 0, bottom: 4, trailing: 0))
        .overlay {
            GeometryReader { gp in
                Rectangle()
                    .fill(
                        LinearGradient(gradient: Gradient(stops: [
                            .init(color: Color(UIColor.systemBackground).opacity(0.01), location: 0),
                            .init(color:
                                    Color(#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)), location: 1)
                        ]), startPoint: .leading, endPoint: .trailing)
                    )
                    .frame(width: 0.1 * gp.size.width)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Rectangle()
                    .fill(
                        LinearGradient(gradient: Gradient(stops: [
                            .init(color: Color(UIColor.systemBackground).opacity(0.01), location: 0),
                            .init(color:
                                    Color(#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)), location: 1)
                        ]), startPoint: .trailing, endPoint: .leading)
                    )
                    .frame(width: 0.1 * gp.size.width)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
}

enum WeatherType {
    case sunny
    case windy
    case snowing
    case rainy
    case thundering
    case cloudy
}

struct HourWeatherCard: View, Hashable {
    
    private var temperature: Float
    private var weatherIcon: String
    private var time: Date // Relative to now [-5, 24]
    private var now: Bool
    private var formatter: DateFormatter
    
    // time is [0, 24] relative to NOW
    init(type: WeatherType, temp: Float, time: Double) {
        switch(type) {
        case .windy:
            weatherIcon = "wind"
        case .snowing:
            weatherIcon = "cloud.snow.fill"
        case .rainy:
            weatherIcon = "cloud.rain.fill"
        case .thundering:
            weatherIcon = "cloud.bolt.fill"
        case .sunny:
            weatherIcon = "sun.max.fill"
        case .cloudy:
            weatherIcon = "cloud.fill"
        }
        
        self.temperature = temp
        self.now = time == 0
        self.time = Date().advanced(by: time*3600)
        
        self.formatter = DateFormatter()
        self.formatter.dateFormat = "h a"
    }
    
    func getFahrenheit(_ celsius: Float) -> Float {
        return ((celsius * 9) / 5) + 32
    }
    
    var body: some View {
        VStack {
            now ?
            Text("Now")
                .fontWeight(.heavy)
            :
            Text("\(self.formatter.string(from: time))")
                .fontWeight(.semibold)
            
            Image(systemName: weatherIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)

            Text("\(String(format: "%.1f", getFahrenheit(temperature)))°")
                .font(.title3)
        }
        .frame(width: 50)
    }
}

extension View{
   func getScreenBounds() -> CGRect{
       return UIScreen.main.bounds
   }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
