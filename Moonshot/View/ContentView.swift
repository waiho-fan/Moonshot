//
//  ContentView.swift
//  Moonshot
//
//  Created by iOS Dev Ninja on 20/12/2024.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State private var showingGrid = true
 
    var body: some View {
        NavigationStack {
            ScrollView  {
                Group {
                    if showingGrid {
                        GridLayout(missions: missions, astronauts: astronauts)
                    } else {
                        ListLayout(missions: missions, astronauts: astronauts)
                    }
                }
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showingGrid.toggle()
                    }
                }, label: {
                    Image(systemName: showingGrid ? "square.grid.2x2" : "list.bullet")
                        .tint(.white)
                })
            }
            .toolbarBackground(.darkBackground, for: .navigationBar)
        }
    }
    
    struct GridLayout: View {
        let missions: [Mission]
        let astronauts: [String: Astronaut]
        let columns = [GridItem(.adaptive(minimum: 150))]
        @State private var showingMissions: [Bool]
        
        init(missions: [Mission], astronauts: [String : Astronaut]) {
            self.missions = missions
            self.astronauts = astronauts
            self.showingMissions = Array(repeating: false, count: missions.count)
        }
        
        var body: some View {
            LazyVGrid(columns: columns) {
                ForEach(missions.indices, id: \.self) { index in
                    NavigationLink(value: missions[index]) {
                        MissionImageView(mission: missions[index])
                            .scaleEffect(showingMissions[index] ? 1 : 0.5)
                            .opacity(showingMissions[index] ? 1 : 0)
                            .onAppear {
                                withAnimation(.easeInOut.delay(Double(index) * 0.1)) {
                                    showingMissions[index] = true
                                }
                            }
                    }
                    // Upgrade to .navigationDestination
                    .navigationDestination(for: Mission.self) { selection in
                        MissionView(mission: selection, astronauts: astronauts)
                    }
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
    
    struct ListLayout: View {
        let missions: [Mission]
        let astronauts: [String: Astronaut]
        @State private var showingMission: [Bool]
        
        init(missions: [Mission], astronauts: [String : Astronaut]) {
            self.missions = missions
            self.astronauts = astronauts
            self.showingMission = Array(repeating: false, count: missions.count)
        }
        
        var body: some View {
            LazyVStack(alignment: .leading) {
                ForEach(missions.indices, id: \.self) { index in
                    NavigationLink(value: missions[index]) {
                        MissionRow(mission: missions[index])
                            .opacity(showingMission[index] ? 1 : 0)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.1).delay(Double(index) * 0.05)) {
                                    showingMission[index] = true
                                }
                            }
                    }
                    // Upgrade to .navigationDestination
                    .navigationDestination(for: Mission.self) { selection in
                        MissionView(mission: selection, astronauts: astronauts)
                    }
                }
            }
            .padding()
        }
    }
    
    struct MissionImageView: View {
        let mission: Mission

        var body: some View {
            VStack {
               Image(mission.image)
                   .resizable()
                   .scaledToFit()
                   .frame(width: 100, height: 100)
                   .padding()
               VStack {
                   Text(mission.displayName)
                       .font(.headline)
                       .foregroundStyle(.white)
                   Text(mission.formattedLaunchDate)
                       .font(.caption)
                       .foregroundStyle(.white.opacity(0.5))
               }
               .padding(.vertical)
               .frame(maxWidth: .infinity)
               .background(.lightBackground)
               
           }
           .clipShape(RoundedRectangle(cornerRadius: 10))
           .overlay(
               RoundedRectangle(cornerRadius: 10)
                   .stroke(.lightBackground)
           )
        }
    }
    
    struct MissionRow: View {
        let mission: Mission
        
        var body: some View {
            ZStack {
                Color.white.opacity(0.1)
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                HStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding()
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text(mission.formattedLaunchDate)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.trailing)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

/*
struct ScrollingGrid: View {
    let layout = [
        GridItem(.adaptive(minimum: 80, maximum: 120))
    ]
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: layout) {
                ForEach(0..<100) {
                    Text("Item \($0)")
                }
            }
        }
    }
}

struct CodableView: View {
    var body: some View {
        Button("Decode JSON") {
            let input = """
            {
                "name": "Taylor Swift",
                "address": {
                    "street": "555, Taylor Swift Avenue",
                    "city": "Nashville"
                }
            }
            """

            // more code to come
            let data = Data(input.utf8)
            if let user = try? JSONDecoder().decode(User.self, from: data) {
                print(user)
            }
        }
    }
}

struct NavigationView: View {
    var body: some View {
        NavigationStack {
            List(0..<100) { row in
                NavigationLink("Row \(row)") {
                    Text("Detail \(row)")
                }
            }
            .navigationTitle("SwiftUI")
        }
    }
}

struct CustomText: View {
    let text: String

    var body: some View {
        Text(text)
    }

    init(_ text: String) {
        print("Creating a new CustomText - \(text)")
        self.text = text
    }
}

struct TestView: View {
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 10) {
                ForEach(0..<100) {
                    CustomText("Item \($0)")
                        .font(.title)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct ImageResizeView: View {
    var body: some View {
        Image(.example2)
            .resizable()
            .scaledToFit()
            .containerRelativeFrame(.horizontal) {size, axis in
                size * 0.8
            }
    }
}
*/

#Preview {
//    ImageResizeView()
//    TestView()
//    NavigationView()
//    CodableView()
//    ScrollingGrid()
    ContentView()
}
