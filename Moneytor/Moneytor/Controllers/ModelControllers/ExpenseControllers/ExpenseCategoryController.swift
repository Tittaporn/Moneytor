//
//  ExpenseCategory.swift
//  Moneytor
//
//  Created by Lee McCormick on 2/24/21.
//

import CoreData

class ExpenseCategoryController {
    static let shared = ExpenseCategoryController()
    //    var expenseCategoriesDefaultForFirstLunch: [ExpenseCategory] = [
    //        ExpenseCategory(name: "other", emoji: "💸", id: "1F1EFA62-7ED2-4325-8A52-210B14384BCB", expenses: nil),
    //                ExpenseCategory(name: "food", emoji: "🍔", id: "598DEBF2-E017-4536-AF32-E9BEDF0A3D81", expenses: nil),
    //                ExpenseCategory(name: "utility", emoji: "📞", id: "EFD4377B-161B-4563-A312-F7013BE7E0F7", expenses: nil),
    //                ExpenseCategory(name: "health", emoji: "💪",  id: "EF566A40-6A34-477F-BCDD-71FB9CBA8CED", expenses: nil),
    //                ExpenseCategory(name: "grocery", emoji: "🛒",  id: "0E435DAB-E1E0-43FF-84B6-5B14BF18C541", expenses: nil),
    //                ExpenseCategory(name: "shopping", emoji: "🛍",  id: "162E5287-35CA-4DDC-BE58-1784534FBA70", expenses: nil),
    //                ExpenseCategory(name: "entertainment", emoji: "🎬",  id: "36FE22EE-A735-4612-BFED-C4587FA8CD62", expenses: nil),
    //                ExpenseCategory(name: "transportation", emoji: "🚘",  id: "D6424512-7973-4F7F-A9E2-01D32271A7C9", expenses: nil)
    //    ]
    
    var expenseCategories: [ExpenseCategory] = []
    var categoriesSections: [[Expense]] = []
    var categoriesSearchingSections: [[Expense]] = []
    var expenseCategoriesTotalDict = [String:Double]()
    
    private lazy var fetchRequest: NSFetchRequest<ExpenseCategory> = {
        let request = NSFetchRequest<ExpenseCategory>(entityName: "ExpenseCategory")
        request.predicate = NSPredicate(value: true)
        return request
    }()
    
    // MARK: - CRUD Methods
    // CREATE
    //    func createExpenseCategories(name: String, emoji: String){
    //        let expenseCategory = ExpenseCategory(name: name, emoji: emoji, expenses: nil)
    //
    //        let newExpenseCategory = insertExpenseCategoryWith(at: expenseCategory.name)
    //        guard let category = newExpenseCategory else {return}
    //        expenseCategories.append(category)
    //
    //               CoreDataStack.shared.saveContext()
    //           }
    
    
    // READ
    func fetchAllExpenseCategory(){
        
        let fetchAllExpenseCatagories = (try? CoreDataStack.shared.context.fetch(fetchRequest)) ?? []
        expenseCategories = fetchAllExpenseCatagories
    }
    
    // READ
    
    func calculateTotalExpenseFromEachCatagory() {
        print("==================\n :: calculateTotalExpenseFromEachCatagory In EXpensesCategoryController\\n=======================")
        categoriesSections = []
        
        var section: [Expense] = []
        var categoryNames: [String] = []
        var totalExpensesEachCategory: [Double] = []
        
        fetchAllExpenseCategory()
        for category in expenseCategories {
            let expenseArray = category.expenses?.allObjects as? [Expense] ?? []
            var sum = 0.0
            for expense in expenseArray {
                sum += expense.amount as! Double
                section.append(expense)
            }
            
            categoriesSections.append(section)
            print("==================\n I calculateTotalExpenseFromEachCatagory() :: \(section.count) After append categoriesSections.append(section)\n=======================")
            print(section.count)
            section = []
            print("==================\n I calculateTotalExpenseFromEachCatagory() :: \(section.count) After Emtry Section categoriesSections.append(section)\n=======================")
            
            print("-------------------\n \(String(describing: category.name)): total ::: \(sum) count :::\(String(describing: category.expenses?.count))")
            categoryNames.append(category.name ?? "")
            totalExpensesEachCategory.append(sum)
            
//            let dict = Dictionary(grouping: category, by: {}
            
            
        }
        // categoriesSections.count
        print("==================\n Before Get Out calculate Funtion categoriesSections.count :: \(categoriesSections.count)\n=======================")
        
    }
    
    func generateSectionsfromResultsOfExpenseArray(searchTerm: String) -> [[Expense]] {
        var newCategoriesSection: [[Expense]] = []
        // categoriesSearchingSections = []
        var section: [Expense] = []
        //var allExpenseCategories = resultArrayExpenseFromSearching
        fetchAllExpenseCategory()
        
        for category in expenseCategories {
            let expenseArray = category.expenses?.allObjects as? [Expense] ?? []
            var sum = 0.0
            let matchedResults = expenseArray.filter {$0.matches(searchTerm: searchTerm, name: $0.expenseNameString, category: $0.expenseCategory?.name ?? "")}
            
            for expense in matchedResults {
                sum += expense.amount as! Double
                section.append(expense)
            }
            newCategoriesSection.append(section)
            
            print("==================\n generateSectionsfromResultsOfExpenseArray :: \(section.count) After append categoriesSearchingSections.append(section)\n=======================")
            print(section.count)
            
            section = []
            print("==================\n generateSectionsfromResultsOfExpenseArray() :: \(section.count) After Empty Section categoriesSearchingSections.append(section)\n=======================")
            print("-------------------\n \(String(describing: category.name)): total ::: \(sum) count :::\(String(describing: category.expenses?.count))")
            
            
        }
        
        
        //  newCategoriesSection = categoriesSearchingSections
        print("==================\n generateSectionsfromResultsOfExpenseArray ::newCategoriesSection.count \(newCategoriesSection.count)\n=======================")
        return newCategoriesSection
        
    }
}


//func insertExpenseCategoryWith(at name: String?) -> ExpenseCategory? {
//      
//        //unwrap managed object context and id
//        let  context = CoreDataStack.shared.context
//
//        //guard let context = context, let id,
//        
//        guard let id = name else { return nil }
//        let categoryName = "ExpenseCategory" //the table name in CoreData
//        let request: NSFetchRequest<ExpenseCategory> = NSFetchRequest(entityName: categoryName)
//        
//        
//        request.predicate = NSPredicate(format: "id == %@", id) //filter only results matching 'id'
//        
//        
//        if let result = try? context.fetch(request), let object = result.first
//        {
//            //return the existing object
//            return object
//        }
//        else if let entity = NSEntityDescription.entity(forEntityName: categoryName, in: context)
//        {
//            //initialize and return a new object
//            return ExpenseCategory.init(entity: entity, insertInto: context)
//                
////                self.init(entity: entity, insertInto: context)
//        }
//        return nil
//    }
