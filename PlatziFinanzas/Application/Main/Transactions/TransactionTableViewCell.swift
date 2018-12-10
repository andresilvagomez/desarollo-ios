//
//  TransactionTableViewCell.swift
//  PlatziFinanzas
//
//  Created by Andres Silva on 12/10/18.
//  Copyright © 2018 Platzi. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var transactionNamaLabel: UILabel!
    @IBOutlet weak var transactionDescriptionLabel: UILabel!
    @IBOutlet weak var transactionValueLabel: UILabel!
    @IBOutlet weak var transactionsDateLabel: UILabel!
    @IBOutlet weak var transactionsTimeLabel: UILabel!
    
    var viewModel: TransactionViewModel! {
        didSet {
            setUpView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUpView() {
        transactionNamaLabel.text = viewModel.name
        transactionsDateLabel.text = viewModel.date
        transactionsTimeLabel.text = viewModel.time
        transactionValueLabel.text = viewModel.value
    }
}
