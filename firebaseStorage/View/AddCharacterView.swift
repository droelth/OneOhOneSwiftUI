import SwiftUI
import Firebase



struct AddCharacterView: View {
    @State private var characterName = ""
    @State private var characterDescription = ""
    @State private var characterImage: UIImage?
    @State private var isShowingImagePicker = false
    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject private var characterViewModel = CharacterViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                
                Button {
                    isShowingImagePicker.toggle()
                } label: {
                    Image(systemName: "person.fill").resizable().foregroundColor(.gray).scaledToFit().frame(width: 100,height: 100)
                }.padding()
                .sheet(isPresented: $isShowingImagePicker) {
                        ImagePicker(selectedImage: $characterImage)
                    }
                
                TextField("Character Name", text: $characterName).autocorrectionDisabled()
                    .padding()
                TextField("Character Description", text: $characterDescription).autocorrectionDisabled()
                    .padding()
                
                
                
                
                
                Button(action: {
                    
                        if let image = characterImage {
                            characterViewModel.uploadImage(image) { result in
                                switch result {
                                case .success(let imageURL):
                                    characterViewModel.saveCharacterToFirestore(name: characterName, description: characterDescription, imageURL: imageURL, winCount: 0, loseCount: 0) { error in
                                        if let error = error {
                                            print("Error adding character: \(error.localizedDescription)")
                                        } else {
                                            // Reset form fields and navigate back
                                            characterName = ""
                                            characterDescription = ""
                                            characterImage = nil
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                case .failure(let error):
                                    print("Error uploading image: \(error.localizedDescription)")
                                }
                            }
                        }
                    
                }, label: {
                    Text("Add Character").font(.title3).foregroundColor(.white).padding(10).fontWeight(.medium).background(.blue).cornerRadius(50)
                })
                .padding()
            }
            .navigationTitle("Add Character")
            .padding()
        }
    }
}


struct AddCharacterView_Previews: PreviewProvider {
    static var previews: some View {
        AddCharacterView()
    }
}


