//
//  ExpenseBarChartViewController.swift
//  Moneytor
//
//  Created by Lee McCormick on 2/23/21.
//

import UIKit
import Charts

class ExpenseBarChartViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var barChartView: BarChartView!
    
    // MARK: - Properties
    var expenseCategoriesSum = [2,3,4,5,6,73,12,5]
    var expenseDictionary: [Dictionary<String, Double>.Element] = ExpenseCategoryController.shared.expenseCategoriesTotalDict {
        didSet {
            
            setupBarChart(expenseDict: expenseDictionary)
            //loadViewIfNeeded()
            
        }
    }
    
    var selectedCatagory: String = ""
    
    var expenseCategoriesEmojis = ExpenseCategoryController.shared.expenseCategoriesEmojis
    
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        barChartView.delegate = self
        setupBarChart(expenseDict: expenseDictionary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ExpenseCategoryController.shared.fetchAllExpenseCategories()
        // Income
        ExpenseCategoryController.shared.generateSectionsAndSumEachExpenseCategory()
        expenseDictionary = ExpenseCategoryController.shared.expenseCategoriesTotalDict
        
        expenseCategoriesEmojis =  ExpenseCategoryController.shared.expenseCategoriesEmojis
        setupBarChart(expenseDict: expenseDictionary)
        
        print("----------------- :: viewWillAppear-----------------")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toTotalExpenseVC" {
            guard let destinationVC = segue.destination as? TotalExpenseViewController else {return}
            let selectedCategory = selectedCatagory
                   destinationVC.selectedCategory = selectedCategory
        }
      
       
    }
    
   
    
}

extension ExpenseBarChartViewController:  ChartViewDelegate {
    
    func setupBarChart(expenseDict: [Dictionary<String, Double>.Element]){
        
        //setup data
        barChartView.noDataText = "No Expense Data available for Chart."
        // var labels: [String] = []
        var dataEntries: [BarChartDataEntry] = []
        //let labels: [String] = []
       
        
      
        var i = 0

        for expenseCategory in expenseDict {
            
            if expenseCategory.value != 0.0 {
                let dataEntry = BarChartDataEntry(x: Double(i), y: Double(expenseCategory.value), data: expenseCategory.key)
                    dataEntries.append(dataEntry)
                let chartDataSet = BarChartDataSet(entries: dataEntries)
                chartDataSet.colors = ChartColorTemplates.pastel()
                        chartDataSet.drawValuesEnabled = false
                let charData = BarChartData(dataSet: chartDataSet)
                        charData.setDrawValues(true)
                        charData.setValueFont(UIFont(name: FontNames.textMoneytorGoodLetter, size: 12) ?? .boldSystemFont(ofSize: 12))
                charData.setValueTextColor(.mtDarkBlue)
                           barChartView.data = charData
                i += 1
            }
            
          
        }
        
      
        
        
        
        
       
        
        
        //setup BarChartView
        let yAxis = barChartView.leftAxis
        yAxis.labelFont = UIFont(name: FontNames.textMoneytorGoodLetter, size: 14) ?? .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: true)
        yAxis.labelTextColor = .mtTextLightBrown
        yAxis.axisLineColor = .mtDarkBlue
        yAxis.labelPosition = .outsideChart
        
        
        barChartView.leftAxis.axisMinimum = 0

//        barChartView.rightAxis.axisMaximum = Double(yValues.max()! + 1)
//        barChartView.leftAxis.axisMaximum = Double(yValues.max()! + 1)
//        barChartView.leftAxis.labelCount = yValues.max() ?? 0
        
        
        
        
        
        barChartView.legend.enabled = false
        barChartView.isUserInteractionEnabled = true
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.dragEnabled = false
        barChartView.dragDecelerationEnabled = false
      
        
        //for emiji
        
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:expenseCategoriesEmojis)
       
        
        
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.granularity = 1.0
        barChartView.leftAxis.forceLabelsEnabled = true
       // barChartView.rightAxis.forceLabelsEnabled = true
        barChartView.xAxis.granularityEnabled = true
        barChartView.animate(xAxisDuration: 3.0, yAxisDuration: 3.0, easingOption: .easeInOutBounce)
        
        
//       barChartView.chartDescription?.text = "Expense Chart"
//        barChartView.chartDescription?.textColor = .mtTextLightBrown
//        barChartView.chartDescription?.font = UIFont(name: FontNames.textTitleBoldMoneytor, size: 14) ?? .boldSystemFont(ofSize: 12)
//
//        barChartView.chartDescription?.textAlign = .left
        
        barChartView.leftAxis.drawGridLinesEnabled = true
        barChartView.rightAxis.drawGridLinesEnabled = true
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.enabled = false
        barChartView.drawGridBackgroundEnabled = true
        barChartView.xAxis.drawLabelsEnabled = true
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
                let data: String  = entry.data! as! String
        
        
        print(data)
        
        selectedCatagory = data
        print("----------------- ::data \(data)-----------------")
        print("----------------- ::selectedCatagory \(selectedCatagory)-----------------")
       
        
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil) // HAVE TO MATCH The NAME of Storyboard, this case Main.storyboard. Mostly! Strict with main.
//        let totalExpenseVC = storyboard.instantiateViewController(identifier: "totalExpenseStoryBoard") //HAVE TO match the Storyboard ID in storyboard
//        // The style of presenting
//        totalExpenseVC.modalPresentationStyle = .pageSheet //You can choose the style of presenting
//        
//        // Now Presenting the next VC
//        self.present(totalExpenseVC, animated: true, completion: nil)
        
        //        switch data {
        //        case "🍔":
        //            lableBackgroundSetUp(lableSelected:  totalFood)
        //        case "🛒":
        //            lableBackgroundSetUp(lableSelected: totalGrocery)
        //        case "🛍":
        //            lableBackgroundSetUp(lableSelected: totalShopping)
        //        case "🎬":
        //            lableBackgroundSetUp(lableSelected: totalEntertainment)
        //        case "🚘":
        //            lableBackgroundSetUp(lableSelected: totalTransportation)
        //        case "📞":
        //            lableBackgroundSetUp(lableSelected: totalUtility)
        //        case "💸":
        //            lableBackgroundSetUp(lableSelected: totalOther)
        //        case "💪":
        //            lableBackgroundSetUp(lableSelected: totalHealth)
        //        default:
        //            lableBackgroundSetUp(lableSelected: nil)
        //            print("Error, Setting background for lables.")
        
        //      }
    }
}


