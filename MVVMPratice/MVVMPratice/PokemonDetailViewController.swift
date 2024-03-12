//
//  PokemonDetailViewController.swift
//  MVVMPratice
//
//  Created by BrianYang on 2024/3/12.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView?
    var pokemonDetail: PokemonDic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDetail(url: pokemonDetail?.url ?? "") { detail in
            if let url = detail?.sprites?.front_default {
                self.fetchData(url: url) { data in
                    if let data = data {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.imageView?.image = image
                        }
                    }
                }
            }
        }
    }
    
    func fetchData(url: String, completion: @escaping ((Data?) -> Void)) {
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                completion(data)
            }.resume()
        }
    }
    
    func fetchDetail(url: String, completion: @escaping ((PokemonDetail?) -> Void)) {
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data,
                   let data = try? JSONDecoder().decode(PokemonDetail.self, from: data) {
                    completion(data)
                } else {
                    completion(nil)
                }
            }.resume()
        }
    }
}
