//
//  ExpenseListTableViewController.swift
//  Moneytor
//
//  Created by Lee McCormick on 2/22/21.
//

import UIKit

class ExpenseListTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var expenseSearchBar: MoneytorSearchBar!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    let daily = ExpenseCategoryController.shared.daily
    let weekly = ExpenseCategoryController.shared.weekly
    let monthly = ExpenseCategoryController.shared.monthly
    var isSearching: Bool = false
    var resultsExpenseFromSearching: [SearchableRecordDelegate] = []
    var sectionsExpenseDict = [Dictionary<String, Double>.Element]()
    var categoriesSections: [[Expense]] =  ExpenseCategoryController.shared.generateSectionsCategoiesByTimePeriod(ExpenseCategoryController.shared.weekly)
    var totalExpenseSearching: Double = 0.0 {
        didSet{
            updateFooter(total: totalExpenseSearching)
        }
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseSearchBar.delegate = self
//fetchExpensesBySpecificTime(time: weekly)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        expenseSearchBar.selectedScopeButtonIndex = 1
        fetchExpensesBySpecificTime(time: weekly)
    }
    
    
    // MARK: - Actions
    @IBAction func calendarButtonTapped(_ sender: Any) {
//        print("================calendarButtonTapped========================")
//        print("==================\nExpenseCategoryController.shared.expenseCategorie :: \(ExpenseCategoryController.shared.expenseCategories.count)\n=======================")
//        //        TotalController.shared.calculateTotalExpenseFromEachCatagory()
//        ExpenseCategoryController.shared.generateSectionsAndSumEachExpenseCategory()
//        ExpenseCategoryController.shared.fetchAllExpenseCategories()
    }
    
    // MARK: - Helper Fuctions
    func fetchAllExpenses(){
        ExpenseController.shared.fetchAllExpenses()
        resultsExpenseFromSearching = ExpenseController.shared.expenses
        //setupSearchBar(expenseCount: resultsExpenseFromSearching.count)
       // ExpenseCategoryController.shared.generateSectionsAndSumEachExpenseCategory()
//        categoriesSections = ExpenseCategoryController.shared.generateSectionsCategoiesByTimePeriod(weekly)
//        TotalController.shared.calculateTotalExpensesBySpecificTime(weekly)
        updateFooter(total: TotalController.shared.totalExpenseSearchResults)
        tableView.reloadData()
    }
    
    func fetchExpensesBySpecificTime(time: Date) {
       // let expenses = ExpenseController.shared.fetchExpensesFromTimePeriod(time)
       // setupSearchBar(expenseCount: expenses.count)
       // ExpenseCategoryController.shared.generateSectionsAndSumEachExpenseCategory()
        categoriesSections = ExpenseCategoryController.shared.generateSectionsCategoiesByTimePeriod(time)
        TotalController.shared.calculateTotalExpensesBySpecificTime(time)
        updateFooter(total: TotalController.shared.totalExpenseBySpecificTime)
        sectionsExpenseDict = ExpenseCategoryController.shared.generateCategoryDictionaryByExpensesAndReturnDict(sections: categoriesSections)
        tableView.reloadData()
    }

    
    func updateFooter(total: Double) {
        let footer = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        footer.backgroundColor = .mtLightYellow
        let lable = UILabel(frame:footer.bounds)
        let totalString = AmountFormatter.currencyInString(num: total)
        lable.text = "TOTAL EXPENSES : \(totalString)  "
        lable.textAlignment = .center
        lable.textColor = .mtTextDarkBrown
        lable.font = UIFont(name: FontNames.textMoneytorGoodLetter, size: 25)
        footer.addSubview(lable)
        tableView.tableFooterView = footer
    }
    
//    func setupSearchBar(expenseCount: Int){
//    if expenseCount == 0 {
//    expenseSearchBar.isUserInteractionEnabled = false
//        expenseSearchBar.placeholder = "Add New Expense..."
//} else {
//    expenseSearchBar.isUserInteractionEnabled = true
//    expenseSearchBar.placeholder = "Search by name or category..."
//}
//}
    
    // MARK: - Table view data source and Table view delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return 1
        } else {
            return categoriesSections.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return resultsExpenseFromSearching.count
        } else {
            return categoriesSections[section].count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath)
        
        if isSearching {
            guard let expense = resultsExpenseFromSearching[indexPath.row] as? Expense else {return UITableViewCell()}
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "\(expense.expenseCategory?.emoji ?? "💵") \(expense.expenseNameString.capitalized) \n\(expense.expenseDateText)"
            cell.detailTextLabel?.text = expense.expenseAmountString
        } else {
            
            if !categoriesSections[indexPath.section].isEmpty {
                let expense = categoriesSections[indexPath.section][indexPath.row]
                cell.textLabel?.numberOfLines = 0
                
                cell.textLabel?.text = "\(expense.expenseCategory?.emoji ?? "💵") \(expense.expenseNameString.capitalized) \n\(expense.expenseDateText)"
                cell.detailTextLabel?.text = expense.expenseAmountString
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let expense = categoriesSections[indexPath.section][indexPath.row]
            let alertController = UIAlertController(title: "Are you sure to delete this Expense?", message: "Name : \(expense.expenseNameString) \nAmount : \(expense.expenseAmountString) \nCategory : \(expense.expenseCategory!.nameString.capitalized) \nDate : \(expense.expenseDateText)", preferredStyle: .actionSheet)
            let dismissAction = UIAlertAction(title: "Cancel", style: .cancel)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            
            
            
                if self.isSearching {
                    guard let expense = self.resultsExpenseFromSearching[indexPath.row] as? Expense else {return}
                ExpenseController.shared.deleteExpense(expense)
                    self.fetchAllExpenses()
            } else {
                let expense = self.categoriesSections[indexPath.section][indexPath.row]
                ExpenseController.shared.deleteExpense(expense)
                
                if self.expenseSearchBar.selectedScopeButtonIndex == 0 {
                    self.fetchExpensesBySpecificTime(time: self.daily)
                } else if self.expenseSearchBar.selectedScopeButtonIndex == 2 {
                    self.fetchExpensesBySpecificTime(time: self.monthly)
                } else {
                    self.fetchExpensesBySpecificTime(time: self.weekly)
                }
                
            }
                tableView.reloadData()
        }
            alertController.addAction(dismissAction)
            alertController.addAction(deleteAction)
            present(alertController, animated: true)
            
            }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if categoriesSections[section].count <= 0 {
            return CGFloat(0.01)
        } else {
            return CGFloat(30.0)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if isSearching {
            
            tableView.reloadData()
            return "🔍 SEARCHING EXPENSES \t\t\t" + AmountFormatter.currencyInString(num: totalExpenseSearching)
        } else {
            if tableView.numberOfRows(inSection: section) == 0 {
                return nil
            }
            
            var total = 0.0
            var name = ""
            var totalExpenseInEachSections: [Double] = []
            var sectionNames: [String] = []
            for section in categoriesSections {
                total = 0.0
                for expense in section {
                    total += expense.amount as! Double
                    name = expense.expenseCategory?.nameString ?? ""
                }
                
                totalExpenseInEachSections.append(total)
                sectionNames.append(name)
            }
            
            let categoryName = sectionNames[section]
            let categoryTotal = totalExpenseInEachSections[section]
            let categoryTotalString = AmountFormatter.currencyInString(num: categoryTotal)
            
            return "\(categoryName.uppercased()) \(categoryTotalString)"
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.mtDarkYellow
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.mtTextLightBrown
        header.textLabel?.font = UIFont(name: FontNames.textMoneytorGoodLetter, size: 20)
        header.textLabel?.textAlignment = .center
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "toExpenseDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? ExpenseDetailTableViewController else {return}
            if isSearching {
                guard let expense = resultsExpenseFromSearching[indexPath.row] as? Expense else {return}
                destinationVC.expense = expense
            } else {
                let expense = categoriesSections[indexPath.section][indexPath.row]
                destinationVC.expense = expense
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension ExpenseListTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        if !searchText.isEmpty {
            fetchAllExpenses()
            resultsExpenseFromSearching = ExpenseController.shared.expenses.filter{$0.matches(searchTerm: searchText, name: $0.expenseNameString, category: $0.expenseCategory?.name ?? "", date: $0.expenseDateText)}
            
            guard let results = resultsExpenseFromSearching as? [Expense] else {return}
            if !results.isEmpty {
            TotalController.shared.calculateTotalExpenseFrom(searchArrayResults: results)
            totalExpenseSearching = TotalController.shared.totalExpenseSearchResults
                self.tableView.reloadData()
            } else {
                totalExpenseSearching = 0.0
                self.tableView.reloadData()
            }
            self.tableView.reloadData()
        } else if searchText == "" {
            resultsExpenseFromSearching = []
            totalExpenseSearching = 0.0
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print(selectedScope)
        print("-------------------- selectedScope: \(selectedScope) in \(#function) : ----------------------------\n)")
        
        if selectedScope == 0 {
            categoriesSections = ExpenseCategoryController.shared.generateSectionsCategoiesByTimePeriod(daily)
            fetchExpensesBySpecificTime(time: daily)
            tableView.reloadData()
            print("--------------------  selectedScope == 0 : \(categoriesSections.count) in \(#function) : ----------------------------\n)")
        } else if selectedScope == 2 {
            categoriesSections = ExpenseCategoryController.shared.generateSectionsCategoiesByTimePeriod(monthly)
            fetchExpensesBySpecificTime(time: monthly)
            print("--------------------  selectedScope == 2 : \(categoriesSections.count) in \(#function) : ----------------------------\n)")
            print("----------------- :: \(categoriesSections)-----------------")
            tableView.reloadData()

        } else {
            categoriesSections =  ExpenseCategoryController.shared.generateSectionsCategoiesByTimePeriod(weekly)
            fetchExpensesBySpecificTime(time: weekly)
            print("--------------------  selectedScope == 1 : \(categoriesSections.count) in \(#function) : ----------------------------\n)")
            tableView.reloadData()

        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = false
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        isSearching = false
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearching = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearching = false
    }
}

