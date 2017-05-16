//
//  VPNManagerViewController.h
//  VPNManager-master
//
//  Created by jhtzh on 2017/4/26.
//  Copyright © 2017年 jhtzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VPNManagerViewControllerDelegate <NSObject>

-(void)setLocale:(NSString *)localeStr withName:(NSString*)name;

@end

@interface VPNManagerViewController : UIViewController

@end
