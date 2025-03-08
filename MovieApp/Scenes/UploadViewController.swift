//
//  UploadViewController.swift
//  MovieApp
//
//  Created by Gama rodriguez quintero on 08/03/25.
//

import UIKit
import FirebaseStorage
import PhotosUI

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    private var selectedImage: UIImage? {
        didSet {
            imageView.image = selectedImage
            imageView.isHidden = (selectedImage == nil)
            removeButton.isHidden = (selectedImage == nil)
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.isHidden = true
        return imageView
    }()
    
    private let selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Seleccionar Imagen", for: .normal)
        button.addTarget(self, action: #selector(selectImageSource), for: .touchUpInside)
        return button
    }()
    
    private let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Subir Imagen", for: .normal)
        button.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        return button
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Eliminar Imagen", for: .normal)
        button.addTarget(self, action: #selector(removeImage), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(selectButton)
        view.addSubview(uploadButton)
        view.addSubview(removeButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            
            removeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            removeButton.topAnchor.constraint(equalTo: selectButton.bottomAnchor, constant: 10),
            
            uploadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadButton.topAnchor.constraint(equalTo: removeButton.bottomAnchor, constant: 20)
        ])
    }
    
    @objc private func selectImageSource() {
        let alert = UIAlertController(title: "Seleccionar imagen", message: "Elige una opción", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { _ in self.openCamera() }))
        alert.addAction(UIAlertAction(title: "Galería", style: .default, handler: { _ in self.openGallery() }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("❌ Cámara no disponible")
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func openGallery() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1 // Limitamos para solo subir una imagen
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.selectedImage = image
            }
        } else {
            print("❌ No se pudo obtener la imagen")
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        removeImage()
        picker.dismiss(animated: true)
    }
    
    @objc func removeImage() {
        selectedImage = nil
    }
    
    // MARK: - PHPickerViewControllerDelegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let result = results.first {
            result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    if let selectedImage = image as? UIImage {
                        self.selectedImage = selectedImage
                    }
                }
            }
        }
    }
    
    @objc private func uploadImage() {
        guard let image = selectedImage, let imageData = image.jpegData(compressionQuality: 0.8) else {
            showAlert(title: "⚠️ Error", message: "Debes seleccionar una imagen antes de subirla.")
            return
        }
        
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        
        let uploadTask = storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                self.showAlert(title: "❌ Error", message: "Hubo un problema al subir la imagen: \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    self.showAlert(title: "⚠️ Error", message: "No se pudo obtener la URL de la imagen subida.")
                    return
                }
                self.showAlert(title: "✅ Éxito", message: "Imagen subida correctamente: \(downloadURL.absoluteString)")
            }
        }
        
        // Mostrar progreso de subida
        uploadTask.observe(.progress) { snapshot in
            if let progress = snapshot.progress {
                let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                print("📤 Subiendo imagen... \(percentComplete)% completado")
            }
        }
    }
    
    // MARK: - Mostrar alerta
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
