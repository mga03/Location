import SwiftUI
import MapKit

struct ContentView: View {
    
    // Estado para gestionar la ubicación
    @State private var locationManager = CLLocationManager()
    
    // Estructura interna para la región predeterminada
    private struct DefaultRegion {
        static let latitude = 9.9333
        static let longitude = -84.0833
    }
    
    // Estructura interna para el span (el rango de la región mostrada en el mapa)
    private struct Span {
        static let delta = 0.1
    }
    
    // Estado para la región del mapa
    @State private var coordinateRegion: MKCoordinateRegion = .init(center: CLLocationCoordinate2D(latitude: DefaultRegion.latitude, longitude: DefaultRegion.longitude),
                                                            span: .init(latitudeDelta: Span.delta, longitudeDelta: Span.delta))
    
    var body: some View {
        
        // Vista del mapa
        Map(coordinateRegion: $coordinateRegion, showsUserLocation: true)
            .onAppear {
                // Solicitar autorización de ubicación al usuario
                locationManager.requestWhenInUseAuthorization()
                locationManager.delegate = makeCoordinator()
                
                // Comenzar a actualizar la ubicación
                locationManager.startUpdatingLocation()
            }
            .ignoresSafeArea()
    }
    
    // Función para crear el coordinador
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // Clase para el coordinador que maneja la ubicación
    class Coordinator: NSObject, CLLocationManagerDelegate {
        var parent: ContentView
        
        init(parent: ContentView) {
            self.parent = parent
        }
        
        // Método delegado llamado cuando se actualizan las ubicaciones
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                // Actualizar la región del mapa con la última ubicación obtenida
                parent.coordinateRegion.center = location.coordinate
            }
        }
        
        // Método delegado llamado cuando falla la obtención de ubicación
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error al obtener la ubicación: \(error.localizedDescription)")
        }
    }
}
