//
//  DetailViewController.swift
//  Characters
//
//  Created by Sujananth Visvaratnam on 26/10/19.
//  Copyright © 2019 Sujananth. All rights reserved.
//

import UIKit
import Nuke

protocol DetailViewTapProtocol: class {
    func dismissKeyboardOnTap()
}

protocol DetailViewProtocol: UIViewController {
    var character: Character? { get set }
    var detailViewTapDelegate: DetailViewTapProtocol? { get set }
}

class DetailViewController: UIViewController, DetailViewProtocol {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    weak var detailViewTapDelegate: DetailViewTapProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTappedOnScreen))
        view.addGestureRecognizer(tap)
    }
    
    var character: Character? {
        didSet {
            configureView()
        }
    }
    
    private func configureView() {
        if let detailLabel = detailDescriptionLabel, let nameLabel = titleLabel {
            detailLabel.text = character?.getCharacterDetail()
            nameLabel.text = character?.getCharacterName()
            let options = ImageLoadingOptions(
                placeholder: #imageLiteral(resourceName: "Placeholder"),
                transition: .fadeIn(duration: 0.33)
            )
            if let imageURL = URL(string: character?.icon.imageURL ?? "") {
                Nuke.loadImage(with: imageURL, options: options, into: characterImageView)
            }
        }
    }
    
    @objc func didTappedOnScreen() {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            detailViewTapDelegate?.dismissKeyboardOnTap()
        }
    }
}

