//
//  AddExercisePage.swift
//  fitness-tracker
//
//  Created by Noah Sterner on 2025-03-02.
//

import SwiftUI
import SwiftData

struct AddExercisePage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Binding var viewModel: WorkoutViewModel
    
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
                            let exercise = ExerciseModel(name: text)
                        
                            self.viewModel.add(exercise: exercise)
                            self.dismiss()
                    } label: {
                        CustomButton(title: "Create Exercise")
                    }
                } else {
                    List {
                        ForEach(self.filter(suggestions: self.exer.suggestions, filter: text), id: \.self) { e in
                            Text(e.value)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .onTapGesture {
                                    self.viewModel.add(exercise: ExerciseModel(name: e.value))
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
    }
    
    private func filter(suggestions: [Suggestions.Suggestion], filter: String) -> [Suggestions.Suggestion] {
        if(filter.isEmpty) {
            return suggestions
        }
        
        return suggestions.filter {
            $0.value.localizedCaseInsensitiveContains(filter)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: WorkoutModel.self, inMemory: true)
}
