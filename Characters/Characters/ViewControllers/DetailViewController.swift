//
//  DetailViewController.swift
//  Characters
//
//  Created by Sujananth Visvaratnam on 26/10/19.
//  Copyright © 2019 Sujananth. All rights reserved.
//

import UIKit
import Nuke

protocol DetailViewProtocol: UIViewController {
    var character: Character? { get set }
    func configureView()
}

class DetailViewController: UIViewController, DetailViewProtocol {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    var character: Character? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
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
}

