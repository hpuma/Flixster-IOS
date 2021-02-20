//
//  MoviesViewController.swift
//  Flixster
//
//  Created by hpuma on 2/20/21.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView! // Link table view to controller

    var movies = [[String: Any]](); // Create dictionary for movies key:value types
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
        print("Hello_World");
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.movies = dataDictionary["results"] as! [[String: Any]];
            self.tableView.reloadData() // Reloads data in table view after we have movies from API
                print(dataDictionary);
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
    }
    // Table View functionality
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->
    Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell { // Gets called for each cell, grab data and display title
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as!
            MovieCell
        // Queuereusablecell helps with memory management, create a new one if there is no recylced cells
        // Casting it as a movie cell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        
        // This url enforces url text formatting, make sure you have https:// etc ...
        let posterUrl = URL(string: baseUrl + posterPath)
        
        // Using from pod AlamofirImage, this handles downloading the image from the url and then displaying
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        cell.synopsisLabel!.text = synopsis
        cell.titleLabel!.text = title
        return cell
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
