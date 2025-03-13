//
//  Dashboard.swift
//  fitness-tracker
//
//  Created by Maria Garic on 2025-02-13.
//

import SwiftUI
import SwiftData
import Charts

struct ChartData: Identifiable {
    let id = UUID()
    let date: Date
    let volume: Int
}

struct Dashboard: View {
    @Query(sort: \WorkoutModel.date, order: .reverse) private var workouts: [WorkoutModel]
    private var chartData: [ChartData] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return workouts.compactMap { workout in
            guard let date = dateFormatter.date(from: workout.date) else {
                return ChartData(date: Date.now, volume: 0)
            }
            
            var volume = 0
            
            for exercise in workout.exercises {
                for set in exercise.sets {
                    volume += set.weight * set.reps
                }
            }
            
            return ChartData(
                date: date,
                volume: volume
            )
        }
        .sorted { $0.date < $1.date }
    }
     
    var body: some View {
        Container {
            Text("Volume progress")
            Chart {
                ForEach(chartData) { item in
                    LineMark(
                        x: .value("Date", item.date, unit: .day),
                        y: .value("Volume", item.volume)
                    )
                    .foregroundStyle(Color.primary70.gradient)
                    .cornerRadius(8)
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisValueLabel(format: .dateTime.day().month())
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel()
                    AxisGridLine()
                }
            }
            .frame(height: 200)
            .padding()
            Spacer()
        }
    }
}


#Preview {
    Dashboard()
}


