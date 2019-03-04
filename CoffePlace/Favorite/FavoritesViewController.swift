//
//  FavoritesViewController.swift
//  Guarana
//
//  Created by Hermann Dorio on 22/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class FavoritesViewController: UIViewController {

    weak var coordinator: FavoriteCoordinator?
    var viewModel: FavoriteViewModel!
    let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            let nib = UINib(nibName: "FavoritesViewCell", bundle: nil)
            tableView.allowsSelection = false
            tableView.register(nib, forCellReuseIdentifier: "FavoritesViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNaigationBar()
        setupRx()
    }
    
    private func setNaigationBar(){
        navigationItem.title = viewModel.navigationTitle
        navigationController?.navigationBar.titleTextAttributes = viewModel.textAttributes
    }
    
    func setupRx() {
        viewModel.fecthDataFrom()
        .catchError({ (error) -> Observable<Results<CoffeeDataPlace>> in
            return Observable.error(error)
        })
        .bind(to: tableView.rx.items) {tv, index, element in
            guard let cell = tv.dequeueReusableCell(withIdentifier: "FavoritesViewCell") as? FavoritesViewCell else {
                return UITableViewCell()
            }
            cell.setup(item: element)
            return cell
        }
        .disposed(by: disposeBag)
    }

}
