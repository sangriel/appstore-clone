//
//  TabViewController.swift
//  KakoBank_HW
//
//  Created by sangmin han on 2023/03/19.
//

import Foundation
import UIKit


class TabBarViewController : UITabBarController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let todayViewController = TodayViewController()
        let todayTabItem = UITabBarItem(title: "투데이", image: UIImage(systemName: "doc.text.image"), tag: 0)
        todayViewController.tabBarItem = todayTabItem
    
        
        let gameViewController = GameViewController()
        let gameTabItem = UITabBarItem(title: "게임", image: UIImage(named: "tabbar_game"), tag: 1)
        gameViewController.tabBarItem = gameTabItem
        
        let appViewController = AppViewController()
        let appTabItem = UITabBarItem(title: "앱", image: UIImage(systemName: "square.stack.3d.up.fill"), tag: 2)
        appViewController.tabBarItem = appTabItem
        
        let arcadeViewController = ArcadeViewController()
        let arcadeTabItem = UITabBarItem(title: "Arcade", image: UIImage(named: "tabbar_arcade"), tag: 3)
        arcadeViewController.tabBarItem = arcadeTabItem
        
        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        let searchTabItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 4)
        searchViewController.tabBarItem = searchTabItem
        
        
        
        
        let controllers = [todayViewController,gameViewController,appViewController,arcadeViewController,searchViewController]
        self.viewControllers = controllers
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
        
        self.selectedIndex = 4
        
        
    }
    
    
    
    
    
    
    
}
