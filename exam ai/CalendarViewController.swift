import SwiftUI

struct MyCalendarViewController: View {
    @State private var selectedDate = Date() // Holds the date selected by the user
    @State private var reminderMessage = "No reminder set" // Holds the reminder message
    @State private var reminderSet = false // Boolean to track if a reminder is set
    
    var body: some View {
        NavigationView {
            VStack {
                // Header Section (no back button, only header title)
                Text("My Calendar")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 20)

                // Calendar Section
                VStack {
                    Text("Select a date to set your exam reminder:")
                        .padding(.top, 30)

                    // DatePicker to choose the date
                    DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle()) // Uses a graphical style for the calendar
                        .frame(height: 400)
                        .padding()

                    // Button to set reminder
                    Button(action: {
                        setReminder(for: selectedDate)
                    }) {
                        Text("Set Reminder")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.headline)
                    }
                    .padding(.top, 20)

                    // Display reminder status
                    Text(reminderMessage)
                        .padding(.top, 20)
                        .foregroundColor(reminderSet ? .green : .gray)
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true) // Hide the default back button
            .navigationBarHidden(false) // This ensures the back button appears when navigating from HomePageStudent
        }
        .navigationBarBackButtonHidden(true) // Hide the back button when navigating to My Calendar
    }

    // Function to set the reminder based on the selected date
    func setReminder(for date: Date) {
        // Here you would set the reminder logic, for simplicity we're just showing a message
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        reminderMessage = "Reminder set for: \(formatter.string(from: date))"
        reminderSet = true
    }
}

struct MyCalendarViewController_Previews: PreviewProvider {
    static var previews: some View {
        MyCalendarViewController()
    }
}
