//
//  ViewController.swift
//  Api(J)
//
//  Created by undhad kaushik on 06/03/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var apiTabelView: UITableView!
    
    var arr: MainFile!
  //  var newarr: [MainFile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        apiJ()
    }
    
    func nibRegister(){
        let nibFile: UINib = UINib(nibName: "TableViewCell", bundle: nil)
        apiTabelView.register(nibFile, forCellReuseIdentifier: "cell")
    }
    
    private func apiJ(){
        AF.request("https://api.coinpaprika.com/v1/coins/btc-bitcoin",method: .get).responseData{ [self] response in
            debugPrint(response)
            if response.response?.statusCode == 200{
                guard let apiData = response.data else { return }
                do{
                    let result = try JSONDecoder().decode(MainFile.self, from: apiData)
                    arr = result
                    apiTabelView.reloadData()
                } catch{
                    print(error.localizedDescription)
                }
            }else{
                print("wrong")
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr?.whitepaper.link?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.idLabel.text = "\(arr.whitepaper.link)"
        cell.nameLabel.text = "\(arr.id)"
        
        return cell
    }
    
}



struct MainFile: Decodable{
    var id: String
    var name: String
    var symbol: String
    var rank: Int
    var isNew: Bool
    var isActive: Bool
    var type: String
    var logo: String
    var description: String
    var opensource: Bool
    var startedAt: String
    var developmentStatus: String
    var hardwareWallet: Bool
    var proofType: String
    var orgStructure: String
    var hashAlgorithm: String
    var whitepaper: Whitepaper
    var firstDataAt: String
    var lastDataAt: String


    enum CodingKeys: String , CodingKey{
        case id , name , symbol , rank , type , logo , description
        case whitepaper
        case isNew = "is_new"
        case isActive = "is_active"
        case opensource = "open_source"
        case startedAt = "started_at"
        case developmentStatus = "development_status"
        case hardwareWallet = "hardware_wallet"
        case proofType = "proof_type"
        case orgStructure = "org_structure"
        case hashAlgorithm = "hash_algorithm"
        case firstDataAt = "first_data_at"
        case lastDataAt = "last_data_at"
    }
}




struct Subscribers: Decodable{
    var subscribers: Double?
    var contributors: Int?
    var stars: Int?
    var followers: Int?

    enum codingKeys: String, CodingKey{
        case subscribers , contributors , stars , followers

    }
}

struct Whitepaper: Decodable{
    var link: String?
    var thumbnail: String

    enum codingKeys: String, CodingKey{
        case link,thumbnail

    }
}

