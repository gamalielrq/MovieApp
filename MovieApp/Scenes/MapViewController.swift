//
//  MapViewController.swift
//  MovieApp
//
//  Created by Gama rodriguez quintero on 08/03/25.
//

import UIKit
import MapKit
import FirebaseFirestore
import CoreLocation
import UserNotifications

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private var db = Firestore.firestore()
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocation()
        fetchLocationsFromFirestore()
        requestNotificationPermission()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Mapa"
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Configurar un temporizador para guardar ubicación cada 5 minutos (300 segundos)
        timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(saveCurrentLocation), userInfo: nil, repeats: true)
    }
    
    // Obtener ubicaciones guardadas en Firestore
    private func fetchLocationsFromFirestore() {
        db.collection("locations").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("❌ Error obteniendo ubicaciones: \(error?.localizedDescription ?? "Desconocido")")
                return
            }
            
            for document in documents {
                let data = document.data()
                if let latitude = data["latitude"] as? Double,
                   let longitude = data["longitude"] as? Double,
                   let timestamp = data["timestamp"] as? Timestamp {
                    
                    let date = timestamp.dateValue()
                    self.addLocationToMap(latitude: latitude, longitude: longitude, date: date)
                }
            }
        }
    }
    
    // Guardar ubicación actual en Firestore cada 5 minutos
    @objc private func saveCurrentLocation() {
        guard let location = locationManager.location else { return }
        
        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("locations").addDocument(data: locationData) { error in
            if let error = error {
                print("❌ Error guardando ubicación: \(error.localizedDescription)")
            } else {
                print("✅ Ubicación guardada en Firestore")
                self.sendLocalNotification()
            }
        }
    }
    
    // Agregar un marcador en el mapa con la fecha de almacenamiento
    private func addLocationToMap(latitude: Double, longitude: Double, date: Date) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = "Ubicación Guardada"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        annotation.subtitle = "Fecha: \(formatter.string(from: date))"
        
        mapView.addAnnotation(annotation)
    }
    
    // Solicitar permisos para notificaciones locales
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ Error solicitando permiso de notificación: \(error.localizedDescription)")
            } else if granted {
                print("✅ Permiso de notificaciones concedido")
            } else {
                print("⚠️ Permiso de notificaciones denegado")
            }
        }
    }
    
    // Enviar una notificación cuando se guarde una ubicación
    private func sendLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Ubicación Guardada"
        content.body = "Se ha almacenado una nueva ubicación en Firebase."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error enviando notificación: \(error.localizedDescription)")
            } else {
                print("✅ Notificación enviada")
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
