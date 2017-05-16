//
//  IntroductionViewController.m
//  VPNManager-master
//
//  Created by jhtzh on 2017/5/4.
//  Copyright © 2017年 jhtzh. All rights reserved.
//

#import "IntroductionViewController.h"
#import "JJLabel.h"

@interface IntroductionViewController ()

@property(nonatomic, strong) UIScrollView *scrollView;
@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0-StatusHeight, SWidth, SHeight+StatusHeight)];
    scrollView.contentSize = CGSizeMake(SWidth,1000);
    scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backView.image = [UIImage imageNamed:@"backImage"];
    [self.scrollView addSubview:backView];
    
    [self setNavigationbar];
    
    [self initView];
}

- (void) initView {
    JJLabel *changeLab = [[JJLabel alloc] init];
    changeLab.text = @"VPN服务器无响应或者速度过慢\n1.如果用电线的ADSL或者光纤，断开连接重新连接，（如果用路由器，重启路由器），如果4G请开启飞行模式，然后关闭（每次重新连接请重启APP）\n2.首先检查自己的网络状态，建议用电线或者联通移动宽带连接VPN，长城、广电、宽带通等三流的运营商用的是共享ip，国外出口较差，需要多次尝试。\n3.建议家里的宽带大于2M以上，否则速度可能不理想。\n4.等当前服务器在线人数过多，请断开VPN，重启自己wifi，然后重新试试连接，如果多次还不能连上，请联系我们。\n需要扣去手机流量吗？\nVPN只是代理，如果3G/4G上VPN，原来怎么扣除就怎么扣除，这是运营商收取，和vpn无关，注意APP说的不限流量指的是VPN流量，不是3G/4G流量！\n为什么提示“加载失败”？\n如果连接不上，并且提示鉴定失败，可能的情况有：\n1.当前手机网络不畅通。\n2.不同网络运营商，对应的线路稳定性和速度有差异，可以断开VPN，尝试重新连接\n3.检测账号的期限\nVPN能突破家里的宽带嘛？\n不能。VPN相当于一个国外代理，速度不可能突破家里宽带速度。";
    changeLab.numberOfLines = 0;
    changeLab.isCopy = NO;
    changeLab.textColor = [UIColor whiteColor];
    changeLab.characterSpace = 3.0f;
    changeLab.lineSpace = 3.0f;
    
    JJLabelItem *item = [JJLabelItem new];
    JJLabelItem *item1 = [JJLabelItem new];
    JJLabelItem *item2 = [JJLabelItem new];
    JJLabelItem *item3 = [JJLabelItem new];
    
    item.itemContent = @"VPN服务器无响应或者速度过慢";
    item.itemColor = [UIColor whiteColor];
    item.itemFont = [UIFont boldSystemFontOfSize:20];
    
    item1.itemContent = @"需要扣去手机流量吗？";
    item1.itemColor = [UIColor whiteColor];
    item1.itemFont = [UIFont boldSystemFontOfSize:20];
    
    item2.itemContent = @"为什么提示“加载失败”？";
    item2.itemColor = [UIColor whiteColor];
    item2.itemFont = [UIFont boldSystemFontOfSize:20];
    
    item3.itemContent = @"VPN能突破家里的宽带嘛？";
    item3.itemColor = [UIColor whiteColor];
    item3.itemFont = [UIFont boldSystemFontOfSize:20];
    
    changeLab.changeArray = @[item,item1,item2,item3];
    
    CGFloat labHeight = [changeLab getLableHeightWithMaxWidth:(SWidth - 30)];
    
    changeLab.frame = CGRectMake(20, 84, (SWidth - 30), labHeight);
    
    [self.scrollView addSubview:changeLab];

}

- (void)setNavigationbar {
    //自定义背景
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor blueColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
    titleLabel.textColor = [UIColor whiteColor];  //设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"解决方法";  //设置标题
    self.navigationItem.titleView = titleLabel;
    
    
    UIBarButtonItem *leftButon = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    fixedButton.width = -10;
    
    self.navigationItem.leftBarButtonItems = @[fixedButton, leftButon];
    //消除阴影
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (void) doBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
