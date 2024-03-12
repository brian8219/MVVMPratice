//
//  ViewController.swift
//  MVVMPratice
//
//  Created by BrianYang on 2024/3/12.
//

import UIKit

class PokemonListViewController: UIViewController {
    
    var pokemonDic : [PokemonDic] = []
    @IBOutlet weak var tableView : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPokemonList { [weak self] dic in
            if let dic = dic {
                self?.pokemonDic = dic
                DispatchQueue.main.async {
                    self?.tableView?.reloadData()
                }
            } else {
                print("error")
            }
        }
    }
    
    func fetchPokemonList(completion: @escaping ([PokemonDic]?) -> Void) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data,
                   let result = try? JSONDecoder().decode(PokemonListResponse.self, from: data) {
                    completion(result.results)
                } else {
                   completion(nil)
                }
            }.resume()
        } else {
            print("Invlid URL")
        }
    }
}

extension PokemonListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        var config = cell.defaultContentConfiguration()
        config.text = String(indexPath.row)
        config.text = pokemonDic[indexPath.row].name
        cell.contentConfiguration = config
        return cell
    }
}

extension PokemonListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = pokemonDic[indexPath.row]
        let storyBoard = UIStoryboard(name: "PokemonDetail", bundle: Bundle.main)
        if let controller = storyBoard.instantiateViewController(withIdentifier: "PokemonDetailViewController") as? PokemonDetailViewController {
            controller.pokemonDetail = data
            self.navigationController?.pushViewController(controller, animated: true)

        }
    }
}
