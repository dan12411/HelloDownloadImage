//
//  ViewController.swift
//  HelloDownloadImage
//
//  Created by 洪德晟 on 2016/10/14.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myImageView: UIImageView!
    
    var session: URLSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        downloadImage(webaddress: "http://media.npr.org/programs/day/features/2008/jul/nirvana_200b-8b1c92584c797efd0a3b7e78a64e3bf19b03024b-s300-c85.jpg")
        
        // 第二種方法
        // 1. 生出URLSession
        session = URLSession(configuration: URLSessionConfiguration.default)
        // 2. 用網址產生 URL
        if let url = URL(string: "http://media.npr.org/programs/day/features/2008/jul/nirvana_200b-8b1c92584c797efd0a3b7e78a64e3bf19b03024b-s300-c85.jpg") {
            // 如果真的有url，下面就開始下載
            let downloadImageTask = session?.dataTask(with: url, completionHandler: {
                (data, response, error) in
                // 如果有錯，不要繼續執行
                if error != nil {
                    return
                }
                // 如果有 data，就用 data 來產生圖片
                if let okData = data {
                    let image = UIImage(data: okData)
                    // 用 myImageView 來顯示
                    DispatchQueue.main.async {
                        self.myImageView.image = image
                    }
                }
            })
            // 真的去下載
            downloadImageTask?.resume()
        }
        
        
    }
    
    
    // 第一種方法
    func downloadImage(webaddress: String) {
        // 1. 用網址產生 URL
        if let url = URL(string: webaddress) {
            // 2. 用共時佇列去下載
            DispatchQueue.global().async {
                do {
                    // 用 Data 類別，content of url 下載，下載成為"資料(Data)"
                    let data = try Data(contentsOf: url)
                    // 回到主佇列去更新 imageView
                    DispatchQueue.main.async {
                        // 用資料產生圖片
                        let image = UIImage(data: data)
                        // 設定給myImageView來顯示
                        self.myImageView.image = image
                    }
                } catch {
                    print("Can not download")
                }
            }
            
        }
        
        //        // 下載(錯誤的做法)
        //        // 1. 用網址產生 URL
        //        if let url = URL(string: "http://media.npr.org/programs/day/features/2008/jul/nirvana_200b-8b1c92584c797efd0a3b7e78a64e3bf19b03024b-s300-c85.jpg") {
        //            do {
        //                // 用 Data 類別，content of url 下載，下載成為"資料(Data)"
        //                let data = try Data(contentsOf: url)
        //                // 用資料產生圖片
        //                let image = UIImage(data: data)
        //                // 設定給myImageView來顯示
        //                myImageView.image = image
        //
        //            } catch {
        //                print("Can not download")
        //            }
        //        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

