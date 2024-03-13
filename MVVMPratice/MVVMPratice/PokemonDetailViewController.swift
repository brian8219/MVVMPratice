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
        Task {
            guard let detail = await fetchPokemonDetail(url: pokemonDetail?.url ?? "") else {
                return
            }
            let image = await fetchPokemonImage(url: detail.sprites?.front_default ?? "")
            await MainActor.run {
                self.imageView?.image = image
            }
        }
    }
    
    func fetchPokemonImage(url: String) async -> UIImage? {
        guard let url = URL(string: url) else {
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let image = UIImage(data: data)
            return image
        } catch {
            return nil
        }
    }
    
    func fetchPokemonDetail(url: String) async -> PokemonDetail? {
        guard let url = URL(string: url) else {
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let detail = try JSONDecoder().decode(PokemonDetail.self, from: data)
            return detail
        } catch {
            return nil
        }
    }
}
