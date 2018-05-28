//
//  HomeViewController.swift
//  PrivusCall
//
//  Created by Sachin on 19/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import UIKit
import Contacts

final class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var historyTab: UITabBarItem!
    @IBOutlet weak var contactsTab: UITabBarItem!
    var contactGroupswitch: UISegmentedControl!
    var addNewContact: UIBarButtonItem!
    var flowCoordinator: HomeFlowCoordinator!
    var homeDataSource = HomeDataSource()
    var historyDataSource = HistoryDataSource()
    var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfig()
    }

    func initialConfig() {
        dataSource = homeDataSource
        dataSource.requestAccesIfNeeded?()
        addObserverToDataSource()
        configureNavigationItems()
        configureTabBar()
        flowCoordinator = HomeFlowCoordinator(parent: self)
    }
    
    func configureTabBar() {
        tabBar.selectedItem = contactsTab
        setSelectedViewOption(viewOption: .contacts)
    }
    
    func configureNavigationBarFor(viewOption: HomeViewOption) {
        switch viewOption {
        case .contacts:
            contactGroupswitch.selectedSegmentIndex = ContactGroups.all.index
            navigationItem.titleView = contactGroupswitch
            navigationItem.rightBarButtonItem = addNewContact
            self.title = HomeViewOption.contacts.title
            break
        case .history:
            self.navigationItem.titleView = nil
            navigationItem.rightBarButtonItem = nil
            self.title = HomeViewOption.history.title
            break
        }
    }
    
    func configureNavigationItems() {
        contactGroupswitch = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: 150, height: 28))
        contactGroupswitch.insertSegment(withTitle: ContactGroups.all.title , at: ContactGroups.all.index, animated: false)
        contactGroupswitch.insertSegment(withTitle: ContactGroups.privusOnly.title , at: ContactGroups.privusOnly.index, animated: false)
        contactGroupswitch.addTarget(self, action: #selector(contactGroupChanged), for: .valueChanged)
        addNewContact = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewContactAction))
    }
    
    func addObserverToDataSource() {
        dataSource.dataCompletion = { [weak self](needsReload) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.tableView.reloadData()
            }
        }
    }
    
    @objc func contactGroupChanged() {
        if let theDataSource = dataSource as? HomeDataSource {
            theDataSource.setSelectedContactGroup(group:
                ContactGroups.groupFromIndex(index: contactGroupswitch.selectedSegmentIndex))
        }
    }
    
    @objc func addNewContactAction() {
        flowCoordinator.addContactViewController()
    }
    
}


extension HomeViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item {
        case historyTab:
            setSelectedViewOption(viewOption: .history)
        case contactsTab:
            setSelectedViewOption(viewOption: .contacts)
        default: break
        }
    }
    
    func setSelectedViewOption(viewOption: HomeViewOption) {
        configureNavigationBarFor(viewOption: viewOption)
        switch viewOption {
        case .contacts:
            dataSource = homeDataSource
        break
        case .history:
            dataSource = historyDataSource
        break
        }
        addObserverToDataSource()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//Table view data source
extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource.titleForHeaderInSection(section: section)
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return dataSource.sectionIndexTitles()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
        let contactViewModel = dataSource.viewModelForRowAt(indexPath: indexPath)
        cell.populateViewWithViewModel(viewModel: contactViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let _ = dataSource as? HomeDataSource {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if let homeDataSource = dataSource as? HomeDataSource {
                homeDataSource.deleteContactAtIndexPath(indexPath: indexPath)
            }
        }
    }

}

extension HomeViewController: UITableViewDelegate  {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let contactViewModel = dataSource.viewModelForRowAt(indexPath: indexPath) as? ContactViewModel {
            flowCoordinator.didSelectContactWithViewModel(viewModel: contactViewModel)
        }
    }

}

