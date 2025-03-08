//
//  ProfileViewController.swift
//  MovieApp
//
//  Created by Gama rodriguez quintero on 08/03/25.
//

import UIKit
import SnapKit
import CoreData

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var user: User
    private let tableView = UITableView()
    private var isEditingProfile = false
    private var reviews: [Review] = []
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.boldSystemFont(ofSize: 22)
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = false
        textField.backgroundColor = .clear
        textField.textColor = .black 
        return textField
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Editar", for: .normal)
        button.addTarget(self, action: #selector(toggleEditMode), for: .touchUpInside)
        return button
    }()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUserProfile()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Perfil"
        
        view.addSubview(profileImageView)
        view.addSubview(nameTextField)
        view.addSubview(actionButton)
        view.addSubview(tableView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(actionButton.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ReviewCell.self, forCellReuseIdentifier: "ReviewCell")
        tableView.backgroundColor = .white
        //tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectPhotoSource))
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    private func loadUserProfile() {
        nameTextField.text = user.name
        if let imagePath = user.profilePath, let image = loadImage(from: imagePath) {
            profileImageView.image = image
        } else {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
        }
        
        // Cargar las reseñas desde el mock
        reviews = MockDataLoader.loadMockReviews()
        tableView.reloadData()
    }
    
    @objc private func toggleEditMode() {
        isEditingProfile.toggle()
        nameTextField.isUserInteractionEnabled = isEditingProfile
        actionButton.setTitle(isEditingProfile ? "Guardar" : "Editar", for: .normal)
        
        if !isEditingProfile {
            saveProfile()
            tableView.reloadData() 
        }
    }
    
    private func saveProfile() {
        user.name = nameTextField.text ?? "Usuario"
        user.profilePath = saveImage(profileImageView.image)
        
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", user.id)
        
        do {
            let results = try context.fetch(request)
            let userEntity = results.first ?? UserEntity(context: context)
            userEntity.id = Int64(user.id)
            userEntity.name = user.name
            userEntity.profilePath = user.profilePath
            try context.save()
            print("✅ Perfil guardado correctamente.")
        } catch {
            print("❌ Error al guardar perfil en Core Data: \(error)")
        }
    }
    
    @objc private func selectPhotoSource() {
        let actionSheet = UIAlertController(title: "¿Desde dónde quieres actualizar tu foto de perfil?", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cámara", style: .default, handler: { _ in self.openCamera() }))
        actionSheet.addAction(UIAlertAction(title: "Galería", style: .default, handler: { _ in self.openGallery() }))
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        present(actionSheet, animated: true)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            present(picker, animated: true)
        } else {
            print("❌ Cámara no disponible.")
        }
    }
    
    private func openGallery() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
            actionButton.setTitle("Guardar", for: .normal)
        }
        picker.dismiss(animated: true)
    }
    
    // MARK: - UITableViewDataSource y UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        let review = reviews[indexPath.row]
        cell.configure(with: review)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    // MARK: - Guardar/Cargar Imagen
    private func saveImage(_ image: UIImage?) -> String? {
        guard let image = image, let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let filename = UUID().uuidString + ".jpg"
        let path = getDocumentsDirectory().appendingPathComponent(filename)
        
        do {
            try data.write(to: path)
            return filename
        } catch {
            print("❌ Error al guardar imagen: \(error)")
            return nil
        }
    }
    
    private func loadImage(from filename: String) -> UIImage? {
        let path = getDocumentsDirectory().appendingPathComponent(filename)
        return UIImage(contentsOfFile: path.path)
    }
    
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
