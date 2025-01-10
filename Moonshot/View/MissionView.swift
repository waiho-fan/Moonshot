//
//  MissionView.swift
//  Moonshot
//
//  Created by Gary on 20/12/2024.
//

import SwiftUI

struct CrewMember {
    let role: String
    let astronaut: Astronaut
}

struct MissionView: View {
    let mission: Mission
    let crew: [CrewMember]
    
    @State private var animationAmount = 0.8
    @State private var isAnimating = false

    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .blur(radius: 100)
                        .scaleEffect(isAnimating ? 1.5 : 1.0) // 動態縮放
                        .overlay(
                            Circle()
                                .stroke(.indigo, lineWidth: 2)
                                .scaleEffect(animationAmount)
                                .opacity(1.8 - animationAmount)
                                .animation(
                                    .easeInOut(duration: 1)
                                    .repeatForever(autoreverses: true),
                                    value: animationAmount
                                )
                        )
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                isAnimating.toggle()
                            }
                            animationAmount = 1.8
                        }
                }
                .containerRelativeFrame(.horizontal) { width, axis in
                    width * 0.6
                }
                .padding(.top)
                
                VStack(alignment: .leading) {
                    DividerLine()
                    
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                    
                    Text("Launch Date: \(mission.formattedLaunchDate)")
                        .padding(.bottom, 5)
                    Text(mission.description)
                    
                    DividerLine()
                    
                    Text("Crew")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                }
                .padding(.horizontal)
                
                CrewScrollView(crew: crew)
                
            }
            .padding(.bottom)
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
    
    struct CrewScrollView: View {
        let crew: [CrewMember]
        @State private var scaleAmount = 1.0
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(crew, id: \.role) { crewMember in
                        NavigationLink {
                            AstronautView(astronaut: crewMember.astronaut)
                        } label: {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 104, height: 72)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(.white, lineWidth: 1)
                                    )
                                    .scaleEffect(scaleAmount)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            //
                                        }
                                    }
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .foregroundStyle(.white)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundStyle(.white.opacity(0.5))
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
    
    struct DividerLine: View {
        var body: some View {
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(.lightBackground)
                .padding(.vertical)
        }
    }
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    return MissionView(mission: missions[1], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
