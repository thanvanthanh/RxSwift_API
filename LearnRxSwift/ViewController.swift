//
//  ViewController.swift
//  LearnRxSwift
//
//  Created by Thân Văn Thanh on 30/06/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import SafariServices


public enum RequestType: String {
    case GET, POST, PUT,DELETE
}
class GithubRequest: APIRequest {
    
    var parameterss = [String: String]()
    
    init(name: String) {
        parameterss["id"] = name
    }
}


class ViewController: UIViewController {
    private let apiCalling = APICalling()
    private let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var showData = PublishSubject<[Items]>()
    var allData = PublishSubject<[Items]>()
    var data = [Items](){
        didSet{
            tableView.reloadData()
        }
    }
    
    private let searchController : UISearchController={
        let searchcontroller = UISearchController(searchResultsController: nil)
        searchcontroller.searchBar.placeholder = "User GitHub"
        searchcontroller.obscuresBackgroundDuringPresentation = false
        return searchcontroller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        let request = APIRequest()
        let result : Observable<[Items]> = self.apiCalling.send(apiRequest: request)
        _ = result.bind(to: tableView.rx.items(cellIdentifier: "ABCTableViewCell" , cellType: ABCTableViewCell.self)){ (row, model , cell) in
            let remoteImageURL = URL(string: model.avatar_url)
            cell.infoImageView.sd_setImage(with: remoteImageURL) { downloadeImage, downloadException, SDImageCache, downloadURL in
                if let downloadException = downloadException{
                    print("Erro downloading the image \(downloadException.localizedDescription)")
                }else{
                    print("successfully downloaded Image : \(String(describing: downloadURL?.absoluteString))")
                    
                }
            }
            cell.infoLBL.text = model.login
            cell.idLBL.text = "ID : \(model.id)"
            
        }.disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(Items.self)
            .subscribe(onNext: { model in
                
                let vc = SFSafariViewController(url: URL(string: model.html_url!)!)
                vc.modalPresentationStyle = .automatic
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    @objc func refesh(){
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    func setupView(){
        title = "Search for Github"
        //        tableView.tableHeaderView = searchController.searchBar
        //        navigationItem.searchController = searchController
        tableView.delegate = self
        tableView.register(UINib(nibName: "ABCTableViewCell", bundle: nil), forCellReuseIdentifier: "ABCTableViewCell")
        self.refreshControl.tintColor = UIColor.red
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Data", attributes: attributes)
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = refreshControl
        } else {
            self.tableView.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(refesh), for: .valueChanged)
    }
    
}
extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
