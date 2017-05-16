//
//  NodeManagerViewController.h
//  VPNManager-master
//
//  Created by jhtzh on 2017/5/3.
//  Copyright © 2017年 jhtzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VPNManagerViewController.h"

@interface NodeManagerViewController : UIViewController

@property(nonatomic, assign) NSObject<VPNManagerViewControllerDelegate> *delegae;

@property(nonatomic, weak) NSArray *jsonArray;

@end
