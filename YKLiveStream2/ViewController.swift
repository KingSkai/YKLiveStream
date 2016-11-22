//
//  ViewController.swift
//  YKLiveStream2
//
//  Created by 王凯 on 2016/11/16.
//  Copyright © 2016年 王凯. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var live : YKCell!
    
    var  playerView : UIView!
    // 视频播放库的类
    var  ijkPlayer : IJKMediaPlayback!
    
    
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func tapBack(_ sender: Any) {
        ijkPlayer.shutdown()
        navigationController?.popViewController(animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    
    @IBOutlet weak var btnGift: UIButton!
    // 礼物特效
    @IBAction func tapGift(_ sender: Any) {
        
        let duration = 3.0
        let car = UIImageView(image: #imageLiteral(resourceName: "porsche"))
        car.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        view.addSubview(car)
        
        let widthCar : CGFloat = 250.0
        let heightCar : CGFloat  = 125.0
        
        // 车子出来
        UIView.animate(withDuration: duration, animations: {
            car.frame = CGRect(x: self.view.center.x - widthCar / 2, y: self.view.center.y - heightCar / 2, width: widthCar, height: heightCar)
        })
        
        // 主线程中的延迟函数: .now() + duration  --- 现在的时间 + 3秒
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: {
            UIView.animate(withDuration: duration, animations: {

                car.center = CGPoint(x: self.view.frame.size.width, y: self.view.frame.size.height)
                car.alpha = 0
                
            }, completion: { (completed) in
                
                car.removeFromSuperview()
                
            })
        })
        
        
    }
    
    
    @IBOutlet weak var btnLike: UIButton!
    @IBAction func tapLike(_ sender: Any) {
        
        // 爱心动画
        let heart = HeartFlyView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        heart.center = CGPoint(x: btnLike.frame.origin.x, y: btnLike.frame.origin.y)
        view.addSubview(heart)
        heart.animate(in: view)
        
        // 爱心按钮大小的关键帧动画
        // 大小比例变化 transform.scale
        let btnAnime = CAKeyframeAnimation(keyPath: "transform.scale")
        btnAnime.values =   [1.0, 0.7, 0.5, 0.3, 0.5, 0.7, 1.0, 1.2, 1.4, 1.2, 1.0]
        btnAnime.keyTimes = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
        btnAnime.duration = 0.2
        // 图层加上关键帧动画
        btnLike.layer.add(btnAnime, forKey: "SHOW")
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBg()
        
        setPlayerView()
        
        bringBtnToFont()

    }
    // 模糊背景方法
    func setBg() {
        let imgUrl = URL(string: "http://img.meelive.cn/" + live.portrait)
        imgBack.kf.setImage(with: imgUrl)
        
        // 图像虚化类
        let  bluerEffect = UIBlurEffect(style: .light)
        // 创建容器
        let effectView = UIVisualEffectView(effect: bluerEffect)
        // 容器框架大小
        effectView.frame = view.bounds
        // 加载到视图中
        imgBack.addSubview(effectView)
        
    }
    
    // 播放视频方法
    func setPlayerView() {
        // 设置大小
        self.playerView = UIView(frame: view.bounds)
        
        view.addSubview(self.playerView)
        // 初始化ijkplayer "http://pull99.a8.com/live/1479453527987553.flv?ikHost=ws&ikOp=1&CodecInfo=8192"
        ijkPlayer = IJKFFMoviePlayerController(contentURLString: live.url, with: nil)
        // 播放器的view
        let pv = ijkPlayer.view!
        // 播放器的尺寸和playerView相同
        pv.frame = playerView.bounds
        pv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playerView.insertSubview(pv, at: 1)
        // 视频填充模式
        ijkPlayer.scalingMode = .aspectFill
        
    }
    
    // 将按钮置顶
    func bringBtnToFont() {
        view.bringSubview(toFront: btnBack)
        view.bringSubview(toFront: btnLike)
        view.bringSubview(toFront: btnGift)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 如果不在播放则进行播放
        if !self.ijkPlayer.isPlaying(){
            // 准备播放
            ijkPlayer.prepareToPlay()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

