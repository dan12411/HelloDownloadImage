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
    
    
    
    func loadImageWithURL(url: NSURL) {
        // 2. 把之前的 image 拿掉
        self.image = nil
        
        // 新增快取判斷是否已下載過圖片 //
        // 存檔檔名
        let hashFileName = "Cache_\(url.hash)"
        // 快取資料夾
        let cachePath = NSHomeDirectory() + "/Library/Caches"
        // 完整檔案名稱
        let fullFilePathName = cachePath + hashFileName
        
        let cacheImage = UIImage(contentsOfFile: fullFilePathName)
        // 如果已下載，就直接拿來用，並return不再下載
        if cacheImage != nil {
            self.image = cacheImage
            print("already download")
            return
        }
        
        // 因為新增快取將url型別改成NSURL，需改回來
        let okURL = url as! URL
        
        // 3. 下載
        let downloadImageTask = session.dataTask(with: okURL, completionHandler: {
            (data, response, error) in
            if error != nil {
                return
            }
            
            if let loadedData = data {
                // 如果真的有 data，產生UIImage
                let loadedImage = UIImage(data: loadedData)
                // 更新畫面，把圖片設為下載的圖片
                DispatchQueue.main.async {
                    self.image = loadedImage
                    // for stop loading activity indicator
                    self.loading?.stopAnimating()
                }
                
                // 存檔(將下載圖片存進快取資料夾內)
                let okURL = URL(fileURLWithPath: fullFilePathName)
                    do {
                        try loadedData.write(to: okURL)
                        print("write to file ok")
                    } catch let error as NSError {
                        print("write to file fail")
                        print(error.localizedDescription)
                    }
            }
        })
        
        // 4. 開始下載
        downloadImageTask.resume()
    }
}
