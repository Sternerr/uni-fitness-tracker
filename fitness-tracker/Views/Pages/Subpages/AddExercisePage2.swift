//
//  AddExercisePage.swift
//  fitness-tracker
//
//  Created by Noah Sterner on 2025-03-02.
//

import SwiftUI
import SwiftData

struct AddExercisePage2: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var exercise: String
    
    @State var exer: Suggestions = Suggestions(suggestions: [])
    
    @State private var text: String = ""
    
    var body: some View {
        Container {
            Block {
                TopBar(text: "") {
                    Image(systemName: "arrow.backward.square.fill")
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                        .foregroundStyle(.secondarySurfaceContainer)
                        .onTapGesture { self.dismiss() }
                    
                    
                    TextField("Enter Exercise", text: $text) {}
                        .padding(8)
                        .font(.body)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.secondarySurfaceContainer, lineWidth: 2)
                        )
                        .onChange(of: text, initial: false) {
                            Task {
                                self.exer = await APIService.shared.fetchExercises(withFilter: text)
                            }
                        }
                }
                
                if(self.exer.suggestions.count <= 0  && !text.isEmpty) {
                    Button {
                        self.exercise = text
                        self.dismiss()
                    } label: {
                        CustomButton(title: "Create Exercise")
                    }
                } else {
                    List {
                        ForEach(APIService.shared.filter(suggestions: self.exer.suggestions, filter: text), id: \.self) { e in
                            Text(e.value)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .onTapGesture {
                                    self.exercise = e.value
                                    self.dismiss()
                                }
                        }
                    }
                    .padding(-16)
                    .scrollContentBackground(.hidden)
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            Task {
                self.exer = await APIService.shared.fetchExercises(withFilter: " ")
            }
        }
    }
}
