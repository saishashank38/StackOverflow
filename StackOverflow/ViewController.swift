//
//  ViewController.swift
//  StackOverflow
//
//  Created by sai on 31/01/20.
//  Copyright © 2020 sai. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

/// View controller that handles the rendering of the View
class ViewController: UIViewController, NVActivityIndicatorViewable {
    var questions = [Question]()
    @IBOutlet weak var questionsList: UITableView!
    var activityIndicator: NVActivityIndicatorView!
    
    /// Callback method that will be called a view is loaded. Initialize the view related functionality here
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stack Overflow"
        
        let refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchQuestions))
        navigationItem.rightBarButtonItem = refreshBtn
    }
    
    /// Call back method that will be called when the view is going to appear
    /// - Parameter animated: Whether its going to animate or not
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballGridPulse, color: UIColor.blue, padding: nil)
        fetchQuestions()
    }
    
    /// Fetch the questions. Show loading indicator, call the webservice, sto the indicator, render the UI
    @objc private func fetchQuestions() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        WebServiceManager.manager.fetchQuestions {[unowned self] (items: [Question]?, error: Error?) in
            /// Need to handle UI in main queue
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
            }
            
            if let receivedItems = items {
                self.questions = receivedItems
                /// Need to handle UI in main queue
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

/// View controller extension that handles the rendering of table view
extension ViewController: UITableViewDataSource {
    
    /// Data source method that returns number of rows to be displayed in the table view
    /// - Parameters:
    ///   - tableView: Tableview object that has to render the data
    ///   - section: Tableview section in which the rows will be displayed
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    
    /// Data source method that renders a particular cell
    /// - Parameters:
    ///   - tableView: Tableview object that has to render the data
    ///   - indexPath: Indexpath of the cell that has to be rendered
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let question = questions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SOQuestion", for: indexPath)
        
        cell.textLabel?.text = question.title
        cell.detailTextLabel?.text = "Answers Count: \(question.answerCount)"
        
        return cell
    }
}
