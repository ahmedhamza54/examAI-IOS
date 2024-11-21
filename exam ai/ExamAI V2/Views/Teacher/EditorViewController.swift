import SwiftUI

struct EditorViewController: View {
    @State private var editors: [String] = [""] // Array to hold the text for each editor

    var body: some View {
        VStack {
            HStack {
                Text("Exam editor")
                    .font(.title)
                    .padding(.leading)
                Spacer()
                Button(action: {
                    // Implement save action here
                    saveAction()
                }) {
                    Text("Save")
                        .fontWeight(.bold)
                        .padding(.trailing)
                }
            }
            .padding(.top)

            // Display the text editors
            VStack {
                ForEach(editors.indices, id: \.self) { index in
                    VStack {
                        ZStack(alignment: .topLeading) {
                            if editors[index].isEmpty {
                                Text("e.g EX\(index + 1): ")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 12)
                                    .padding(.top, 8)
                                    .transition(.opacity)
                            }
                            TextEditor(text: $editors[index])
                                .frame(height: 100)
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
            }

            // Plus button to add a new editor
            Button(action: {
                editors.append("") // Add a new editor
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding(.top)
            }
            .padding(.top)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .navigationTitle("Editor")
    }
    
    // Save button action
    private func saveAction() {
        // Here you would implement the save logic, like saving to a database or an API
        print("Saving editors: \(editors)")
    }
}

struct EditorViewController_Previews: PreviewProvider {
    static var previews: some View {
        EditorViewController()
    }
}
