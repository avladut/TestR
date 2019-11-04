//
//  CurrencyConversionViewController.swift
//  TestRevolut
//
//  Created by Alex on 19/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

class CurrencyConversionViewController: UIViewController {

    //MARK: static methods
    private static let storyboardID = "CurrencyConversionViewControllerStoryboardID"
    
    //MARK: static methods
    public static func instantiateFromStoryboard() -> CurrencyConversionViewController {
        
        let currencyConversionViewController = UIStoryboard(name: StoryboardUtils.mainStoryboardName, bundle: nil).instantiateViewController(withIdentifier: CurrencyConversionViewController.storyboardID) as! CurrencyConversionViewController
        
        return currencyConversionViewController
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var viEmptyScreen: UIView!
    @IBOutlet weak var tblCurrencyPairs: UITableView!
    
    //MARK: Private
    public var currencyPairListViewModel = CurrencyPairListViewModelImpl.getInstance(dataContext: CoreDataUtils.mainContext, baseURL: HTTPRequestUtils.baseURL)
    private var timer: Timer?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblCurrencyPairs.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadCurrencyPairs()
        self.startExchangeRateTimer()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopExchangeRateTimer()
        super.viewWillDisappear(animated)
    }
    
    //MARK: Utility methods
    func reloadCurrencyPairs () {
        do {
            //reload data once
            try currencyPairListViewModel.refreshDataSource(completion: {[weak self] in
                DispatchQueue.main.async {
                    self?.tblCurrencyPairs.reloadData()
                }
            })
            
        } catch let error {
            ErrorHandler.showSimpleErrorAlertOnController(self, error: error)
        }
    }
    
    func startExchangeRateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCurrencyPairs), userInfo: nil, repeats: true)
    }
    
    func stopExchangeRateTimer() {
        timer?.invalidate()
    }
    
    //MARK: Actions
    @IBAction func btnAddCurrencyPairTouched(_ sender: Any) {
        let pickCurrencyVC = PickCurrencyViewController.instantiateFromStoryboard(screenType: .sourceCurrency)
        self.navigationController?.pushViewController(pickCurrencyVC, animated: true)
    }
    
    @objc private func updateCurrencyPairs () {
        print("timer ticks")
        do{
            try currencyPairListViewModel.startCurrencyRateUpdates (completion: {[weak self] in
                
                guard let selfUnwr = self else {
                    return
                }
                //update table if editing is not on
                DispatchQueue.main.async {
                    if !(selfUnwr.tblCurrencyPairs.isEditing) {
                        selfUnwr.tblCurrencyPairs.reloadData()
                    }
                }
            })
        } catch let error {
           ErrorHandler.showSimpleErrorAlertOnController(self, error: error)
        }
    }
}

extension CurrencyConversionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyPairListViewModel.getNumberOfCurrencyPairs()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyConversionCell.reuseIdentifier, for: indexPath) as? CurrencyConversionCell else {
            return UITableViewCell()
        }
        cell.clear()
        cell.config(currencyPairListViewModel.getCurrencyPairForCellAtIndex(indexPath.row))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            do {
                try self.currencyPairListViewModel.deleteCurrencyPairAtIndex(indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            } catch let error {
                ErrorHandler.showSimpleErrorAlertOnController(self, error: error)
            }
        }
    }
}

