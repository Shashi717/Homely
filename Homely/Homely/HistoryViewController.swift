//
//  HistoryViewController.swift
//  Homely
//
//  Created by Jermaine Kelly on 1/12/17.
//  Copyright © 2017 Homely.Inc. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let historyTableView: UITableView = UITableView()
    let backGroundView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "HomelyBack"))
    var historyArray: [(title:String,date:Date)] = []
    let historyTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "History"
        label.font = UIFont.systemFont(ofSize: 30, weight: 5)
        return label
    }()
    let backButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.shadowRadius = 10.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 10)
        button.layer.shadowOpacity = 0.5
        button.setTitle("  Back  ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        if let historyDict = UserDefaults.standard.object(forKey: "History") as? [String:Date] {
            
            historyArray = Array(historyDict) as! [(title: String, date: Date)]
            
            DispatchQueue.main.async {
                self.historyTableView.reloadData()
            }
        }
        
        setUpViews()
    }
    
    //MARK:- TableView delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as! HistoryTableViewCell
        
        let history = historyArray[indexPath.row]
        cell.historyTitleLabel.text = history.title + "\n\(makeRelativeDate(from: history.date))"
        
        return cell
    }
    
    //MARK:- Utilities
    func setUpViews(){
        
        self.view.addSubview(backGroundView)
        self.view.addSubview(historyTableView)
        self.view.addSubview(historyTitleLabel)
        self.view.addSubview(backButton)
        
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        historyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        backGroundView.translatesAutoresizingMaskIntoConstraints = false
        
        backGroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backGroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backGroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backGroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        historyTitleLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        historyTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        historyTableView.topAnchor.constraint(equalTo: historyTitleLabel.bottomAnchor, constant: 20).isActive = true
        historyTableView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        historyTableView.backgroundColor = .clear
        
        backButton.topAnchor.constraint(equalTo: historyTableView.bottomAnchor, constant: 20).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backButton.addTarget(self, action: #selector(goback), for: .touchUpInside)
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.estimatedRowHeight = 85.0
        historyTableView.rowHeight = UITableViewAutomaticDimension
        historyTableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
    }
    
    func makeRelativeDate(from date:Date)->String{
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        return dateFormatter.string(from: date)
    }
    
    func goback(){
        dismiss(animated: true, completion: nil)
    }
}
