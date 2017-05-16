//
//  BaseTabBarViewController.m
//  RoadHome
//
//  Copyright (c) 2015年 iFeng. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "BaseNavigationController.h"
#import "AboutViewController.h"
#import "VPNManagerViewController.h"

@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.opaque = YES;
    self.tabBar.tintColor = TabBar_T_Color;
    [self initChildViewControllers];

}

- (void)initChildViewControllers {
    
    NSMutableArray *childArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    VPNManagerViewController *vpnVC = [[VPNManagerViewController alloc] init];
    [vpnVC.tabBarItem setTitle:@"首页"];
    [vpnVC.tabBarItem setImage:[UIImage imageNamed:@"btn_info_normal"]];
    [vpnVC.tabBarItem setSelectedImage:[UIImage imageNamed: @"btn_info_selected"]];
    BaseNavigationController *naviRecommendVC = [[BaseNavigationController alloc] initWithRootViewController:vpnVC];
    [childArray addObject:naviRecommendVC];
    
    
    AboutViewController *mineVC = [[AboutViewController alloc] init];
    [mineVC.tabBarItem setTitle:@"我的"];
    [mineVC.tabBarItem setImage:[UIImage imageNamed:@"btn_set_normal"]];
    [mineVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"btn_set_selected"]];
    
    BaseNavigationController *naviMineVC = [[BaseNavigationController alloc] initWithRootViewController:mineVC];
    [childArray addObject:naviMineVC];
    
    
    [self setViewControllers:childArray];
}

@end
