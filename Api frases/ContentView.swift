//
//  ContentView.swift
//  Api frases
//
//  Created by Mac on 3/5/24.
//



//import SwiftUI
//
//struct ContentView: View {
//    
//    //Variable de estado que recoge los datos de la API
//    @State private var datos : Datos?
//    
//    var body: some View {
//        VStack{
//            Spacer()
//            
//            VStack(alignment: .trailing){
//                Spacer()
//                
//                Text(datos?.content ?? "")
//                    .font(.title2)
//                    .padding(20)
//                    .background(Rectangle().opacity(0.3))
//                    .cornerRadius(12)
////                    .overlay(Rectangle().opacity(0.4))
//                
//                Text("- \(datos?.author ?? "")")
//                    .font(.title2)
//                    .padding(20)
//                    .background(Rectangle().opacity(0.3))
//                    .cornerRadius(12)
//
//                
//                Spacer()
//            }
//            .padding(20)
//            VStack(alignment: .trailing){
//                Spacer()
//                
//                Text(datos?.content ?? "")
//                    .font(.title2)
//                    .padding(20)
//                    .background(Rectangle().opacity(0.3))
//                    .cornerRadius(12)
////                    .overlay(Rectangle().opacity(0.4))
//                
//                Text("- \(datos?.author ?? "")")
//                    .font(.title2)
//                    .padding(20)
//                    .background(Rectangle().opacity(0.3))
//                    .cornerRadius(12)
//
//                
//                Spacer()
//            }
//            .padding(20)
//            
//
//            VStack{
//                
//                Button(action: llamaUrl){
//                    Image(systemName: "arrow.clockwise")
//                }
//                .font(.title)
//                .padding(.top)
//            }
//        }
//        .multilineTextAlignment(.trailing)
//        .padding()
//        .onAppear(perform: llamaUrl)
//        .background(Image("fondo1") .resizable() .scaledToFill() .opacity(0.6))
//        
//    }
//    
//    //Función para llamar a la Web que proporciona la API
//    private func llamaUrl() {
//        guard let url = URL(string: "https://api.quotable.io/random") else{return}
//        
//        //Creamos sesión de URL para pedir datos a la URL
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else {return}
//            //Si hemos obtenido JSON, tenemos que usar un decodificador para almacenarlo en nuestra variable datos, de tipo Datos.
//            if let datosDecodificados = try? 
//                JSONDecoder().decode(Datos.self,from:data){
//                //El Decoder va a almacenar cada etiqueta de JSON en nuestro struct
//                //Asignamos la info decodificada a nuestra variable de estado
//                //Lo hacemos desde el hilo principal, con DispatchQueue
//                DispatchQueue.main.async {
//                    self.datos = datosDecodificados
//                }
//            }
//            
//        }.resume()
//    }
//    
//}
//
////La estructura ha de conformar el protocolo Decodable, para que sepa que ha de interpretar un JSON
//struct Datos: Decodable {
//    //Identificador para la frase
////    var _id : String
//    //Identificador para el idioma, que siempre va a ser Inglés
//    var content : String
////    var phrase : String
//    var author : String
//    //Identificador para la frase, que también lo devuelve el JSON
////    var id : String
//}
//
//
//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}











import SwiftUI
import AVFoundation

struct ContentView: View {
    
    // Variable de estado que recoge los datos de la API
    @State private var datos : Datos?
    
    // Sintetizador de voz para convertir texto en voz
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var body: some View {
        VStack{
            Spacer()
            
            VStack(alignment: .trailing){
                Spacer()
                
                Text(datos?.content ?? "")
                    .font(.title2)
                    .padding(20)
                    .background(Rectangle().opacity(0.3))
                    .cornerRadius(12)
                
                Text("- \(datos?.author ?? "")")
                    .font(.title2)
                    .padding(20)
                    .background(Rectangle().opacity(0.3))
                    .cornerRadius(12)
                
                Spacer()
            }
            .padding(20)
            
            VStack{
                Button(action: llamaUrl){
                    Image(systemName: "arrow.clockwise")
                }
                .font(.title)
                .padding(.top)
                
                Button(action: {
                    // Leer el texto en voz
                    if let text = datos?.content {
                        speak(text)
                    }
                }) {
                    Image(systemName: "speaker.3.fill")
                }
                .font(.title)
                .padding(.top)
            }
        }
        .multilineTextAlignment(.trailing)
        .padding()
        .onAppear(perform: llamaUrl)
        .background(Image("fondo1").resizable().scaledToFill().opacity(0.6))
    }
    
    // Función para llamar a la Web que proporciona la API
    private func llamaUrl() {
        guard let url = URL(string: "https://api.quotable.io/random") else { return }
        
        // Creamos sesión de URL para pedir datos a la URL
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            // Si hemos obtenido JSON, tenemos que usar un decodificador para almacenarlo en nuestra variable datos, de tipo Datos.
            if let datosDecodificados = try? JSONDecoder().decode(Datos.self,from:data){
                // El Decoder va a almacenar cada etiqueta de JSON en nuestro struct
                // Asignamos la info decodificada a nuestra variable de estado
                // Lo hacemos desde el hilo principal, con DispatchQueue
                DispatchQueue.main.async {
                    self.datos = datosDecodificados
                }
            }
        }.resume()
    }
    
    // Función para convertir texto en voz
    private func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        // Lista de voces disponibles
        let voices = AVSpeechSynthesisVoice.speechVoices()
        
        // Buscar una voz masculina en inglés estadounidense
        if let voice = voices.first(where: { $0.language == "en-US" && $0.name.contains("Male") }) {
            utterance.voice = voice
        } else {
            // Si no se encuentra una voz masculina, se utiliza la voz predeterminada
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }
        
        speechSynthesizer.speak(utterance)
    }
}

// La estructura ha de conformar el protocolo Decodable, para que sepa que ha de interpretar un JSON
struct Datos: Decodable {
    var content: String
    var author: String
}

// Preview
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
