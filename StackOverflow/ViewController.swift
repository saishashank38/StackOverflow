//
//  ViewController.swift
//  StackOverflow
//
//  Created by sai on 31/01/20.
//  Copyright © 2020 sai. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ViewController: UIViewController, NVActivityIndicatorViewable {
    var questions = [Question]()
    @IBOutlet weak var questionsList: UITableView!
    var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stack Overflow"
        
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchQuestions))
        navigationItem.rightBarButtonItem = refreshBtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballGridPulse, color: UIColor.blue, padding: nil)
        fetchQuestions()
    }
    
    @objc private func fetchQuestions() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        WebServiceManager.manager.fetchQuestions {[unowned self] (items: [Question]?, error: Error?) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
            }
            
            if let receivedItems = items {
                self.questions = receivedItems
                DispatchQueue.main.async {
                    self.questionsList.reloadData()
                }
            } else {
                print(error as Any)
                self.showAlert(message: "Failed to fetch qustions")
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let question = questions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SOQuestion", for: indexPath)
        
        cell.textLabel?.text = question.title
        cell.detailTextLabel?.text = "Answers Count: \(question.answerCount)"
        
        return cell
    }
}
