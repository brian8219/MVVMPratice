//
//  ViewController.swift
//  MVVMPratice
//
//  Created by BrianYang on 2024/3/12.
//

import UIKit

class PokemonListViewController: UIViewController {
    var pokemonDic: [PokemonDic] = []
    @IBOutlet weak var tableView: UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            do {
                let data = try await fetchPokemonList()
                self.pokemonDic = data
                await MainActor.run {
                    self.tableView?.reloadData()
                }
            } catch {
                print("something wrong")
            }
        }
    }

    func fetchPokemonList() async throws -> [PokemonDic] {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"
        guard let url = URL(string: urlString) else {
            throw MyError.invalidURL
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let pokemonDetail = try JSONDecoder().decode(PokemonListResponse.self, from: data)
            return pokemonDetail.results
        } catch DecodingError.dataCorrupted {
            throw MyError.jsonParseError
        } catch {
            throw MyError.other
        }
    }
}

extension PokemonListViewController: UITableViewDataSource {
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

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = pokemonDic[indexPath.row]
        let storyBoard = UIStoryboard(name: "PokemonDetail", bundle: Bundle.main)
        if let controller = storyBoard.instantiateViewController(withIdentifier: "PokemonDetailViewController") as? PokemonDetailViewController {
            controller.pokemonDetail = data
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
