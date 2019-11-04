//
//  PickCurrencyViewController.swift
//  TestRevolut
//
//  Created by Alex on 11/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

class PickCurrencyViewController: UIViewController {
    
    //MARK: static methods
    private static let storyboardID = "PickCurrencyViewControllerStoryboardID"
    
    //MARK: static methods
    public static func instantiateFromStoryboard(screenType: ScreenType, currencyListViewModel: CurrencyListViewModel? = nil) -> PickCurrencyViewController {
        
        let pickCurrencyController = UIStoryboard(name: StoryboardUtils.mainStoryboardName, bundle: nil).instantiateViewController(withIdentifier: PickCurrencyViewController.storyboardID) as! PickCurrencyViewController
        pickCurrencyController.screenType = screenType
        
        //if a view model was passed as a parameter
        if let currencyListVM = currencyListViewModel {
            //use the VM
            pickCurrencyController.currencyListViewModel = currencyListVM
            
        } else {
            //create a new VM
            pickCurrencyController.currencyListViewModel = CurrencyListViewModelImpl.getInstance(dataContext: CoreDataUtils.mainContext)
        }
        
        return pickCurrencyController
    }
    
    //MARK: types
    enum ScreenType: Int {
        case sourceCurrency
        case destinationCurrency
    }
    
    //MARK: public variables
    public var screenType: ScreenType = .sourceCurrency
    public var currencyListViewModel: CurrencyListViewModel!
    
    //MARK: private variables
    
    //MARK: IBOutlets
    @IBOutlet weak var tblCurrencies: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDataForScreenType(screenType: self.screenType)
    }
    
    
    func loadDataForScreenType(screenType: ScreenType) {
        
        //exclude existing pairs for destination currency
        let excludeExistingPairs = self.screenType == .destinationCurrency
        do {
            try self.currencyListViewModel.getCurrencies(shouldExcludeExistingPairs: excludeExistingPairs, completion: {[weak self] in
                 self?.tblCurrencies.reloadData()
            })
        } catch let error {
            ErrorHandler.showSimpleErrorAlertOnController(self, error: error)
        }
    }
}

extension PickCurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencyListViewModel.getNumberOfCurrencies()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.reuseIdentifier, for: indexPath) as? CurrencyCell else {
            return UITableViewCell()
        }
        cell.clear()
        if let currencyViewModel = currencyListViewModel.getCurrencyForCellAtIndex(indexPath.row){
            cell.config(currency: currencyViewModel)
        }
        
        return cell
    }
}

extension PickCurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch screenType {
        case .sourceCurrency:
            self.currencyListViewModel.saveCurrencyWithPositionForPair(index: indexPath.row, key: .baseCurrency) {[weak self] (success, error) in
                
                guard let selfUnwr = self else {
                    return
                }
                
                if let errorUnwr = error {
                    ErrorHandler.showSimpleErrorAlertOnController(selfUnwr, error: errorUnwr)
                    return
                }
                
                let nextController = PickCurrencyViewController.instantiateFromStoryboard(screenType: .destinationCurrency, currencyListViewModel: selfUnwr.currencyListViewModel)
                selfUnwr.navigationController?.pushViewController(nextController, animated: true)
            }
            
        case .destinationCurrency:
            
            self.currencyListViewModel.saveCurrencyWithPositionForPair(index: indexPath.row, key: .destinationCurrency) {[weak self] (success, error) in
                
                guard let selfUnwr = self else {
                    return
                }
                if let errorUnwr = error {
                    ErrorHandler.showSimpleErrorAlertOnController(selfUnwr, error: errorUnwr)
                    return
                }
                
                selfUnwr.navigationController?.popToRootViewController(animated: true)
            }
            
        }
    }
}
