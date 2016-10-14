//
//  DownloadImageView.swift
//  HelloDownloadImage
//
//  Created by 洪德晟 on 2016/10/14.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import UIKit

class DownloadImageView: UIImageView {
    // 1. 生出URLSession
    lazy var session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
    ///////////////
    /// Loading ///
    ///////////////
    var loading: UIActivityIndicatorView?
    
    // 覆寫 init
    override init(frame: CGRect) {
        // 確定 activity indicator 的位置
        let area = CGRect(x: frame.size.width/2, y: frame.size.height/2, width: 37, height: 37)
        // 用上面的位置，產生 activity indicator
        loading = UIActivityIndicatorView(frame: area)
        // 改藍色
        loading?.color = UIColor.blue
        // Hide when stop
        loading?.hidesWhenStopped = true
        loading?.activityIndicatorViewStyle = .whiteLarge
        loading?.startAnimating()
        
        super.init(frame: frame)
        if loading != nil {
            self.addSubview(loading!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func loadImageWithURL(url: URL) {
        // 2. 把之前的 image 拿掉
        self.image = nil
        
        // 3. 下載
        let downloadImageTask = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                return
            }
            
            if let loadedData = data {
                let loadedImage = UIImage(data: loadedData)
                DispatchQueue.main.async {
                    self.image = loadedImage
                    // for stop loading activity indicator
                    self.loading?.stopAnimating()
                }
            }
        })
        
        // 4. 開始下載
        downloadImageTask.resume()
    }
}
