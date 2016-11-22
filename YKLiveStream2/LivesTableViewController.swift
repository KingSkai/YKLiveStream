//
//  LivesTableViewController.swift
//  YKLiveStream2
//
//  Created by 王凯 on 2016/11/16.
//  Copyright © 2016年 王凯. All rights reserved.
//

import UIKit
import Just
import Kingfisher

class LivesTableViewController: UITableViewController {
    // 数据地址 - 常量(定量)
    let liveListUrl = "http://service.ingkee.com/api/live/gettop?imsi=&uid=17800399&proto=5&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_9.300000&count=5&multiaddr=1"
    // 数据数组 - 变量
    var list : [YKCell] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        loadList()
        
        // 下拉刷新功能
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadList), for: .valueChanged)
        
        
    }
    
    // 网络请求方法
    func loadList()  {
        
        Just.post(liveListUrl, asyncCompletionHandler: { (r) in
            // 判断数据类型
            guard let json = r.json as? NSDictionary else {
                return
            }
            
            // 获取用户信息字典(NSDictionary)
            let lives = YKRootClass(fromDictionary: json).lives!
            
            // map方法 -- 数组转换成另外一个数组
            self.list = lives.map({ (live) -> YKCell in
                return YKCell(portrait: live.creator.portrait, nick: live.creator.nick, location: live.city, viewers: live.onlineUsers, url: live.streamAddr)
            })
            
            // 更新主线程中的数据
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                // 停止下拉刷新动画
                self.refreshControl?.endRefreshing()
            }
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 强制转换
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LiveTableViewCell

        let live = list[indexPath.row]
        
        cell.labAddr.text = live.location
        cell.labNick.text = live.nick
        // int 转 string
        cell.labViewers.text = "\(live.viewers)"
        
        // 图片地址
        let imgUrl = URL(string: "http://img.meelive.cn/" + live.portrait)
        // 小头像
        cell.imgPor.kf.setImage(with: imgUrl)
        cell.imgPor.layer.cornerRadius = 30;
        cell.imgPor.layer.masksToBounds = true;
        
        // 大幅主播封面
        cell.imgBigPor.kf.setImage(with: imgUrl)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // 传递参数到下一个页面 -- 此方法用于storyboard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        // segue 即为下一个视图控制区 
        let dest = segue.destination as! ViewController
        
        dest.live = list[(tableView.indexPathForSelectedRow?.row)!]
    }

}
