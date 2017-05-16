//
//  NodeManagerViewController.m
//  VPNManager-master
//
//  Created by jhtzh on 2017/5/3.
//  Copyright © 2017年 jhtzh. All rights reserved.
//

#import "NodeManagerViewController.h"
#import "MyTableViewCell.h"
#import "GiFHUD.h"

static NSString *myTableViewCell = @"MyTableViewCell";

@interface NodeManagerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *mainTbView;

@end

@implementation NodeManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backView.image = [UIImage imageNamed:@"backImage"];
    [self.view addSubview:backView];
    
    [self createMainView];
    
    if (self.jsonArray == nil || self.jsonArray.count == 0) {
       [self loadNode];
    }
    
    [self setNavigationbar];
}

-(void)createMainView {
    self.mainTbView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusHeight, SWidth, SHeight) style:UITableViewStylePlain];
    self.mainTbView.delegate = self;
    self.mainTbView.dataSource  = self;
    self.mainTbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.mainTbView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.mainTbView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.mainTbView];
    
}

- (void)setNavigationbar {
    //自定义背景
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
    titleLabel.textColor = [UIColor whiteColor];  //设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"线路选择";  //设置标题
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

//获取节点信息
- (void) loadNode {
    //https://v6.zhaoerdan.com/api/clients/locales?
    NSString *urlString = @"https://api.zhaoerdan.com/api/clients/locales?";
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *country = [locale localeIdentifier];
    if ([country isEqual:@"zh_CN"]) {
        urlString = @"https://api.zhaoerdan.com/api/clients/locales?";
    } else {
        urlString = @"https://v6.zhaoerdan.com/api/clients/locales?";
    }

    
    [GiFHUD setGifWithImageName:@"pika.gif"];
    [GiFHUD show];
    
    [[NetworkSingleton sharedManager] GET:urlString parameters:nil success:^(id responseObject) {
        
        self.jsonArray = responseObject;
        NSLog(@"%@", self.jsonArray);
        [self.mainTbView reloadData];
        
        [GiFHUD dismiss];
    } failure:^(NSError *error) {
        NSLog(@"");
        [GiFHUD dismiss];
    }];
}

#pragma mark - 协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.jsonArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableViewCell];
    
    if (!cell) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableViewCell];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //加载
    cell.txtLabel.text = self.jsonArray[indexPath.row][@"name"];
    cell.imgView.image = [UIImage imageNamed:self.jsonArray[indexPath.row][@"code"]];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *localeStr = self.jsonArray[indexPath.row][@"code"];
    NSString *nameStr = self.jsonArray[indexPath.row][@"name"];
    
    [self dismissViewControllerAnimated:YES completion:^ {
        [self.delegae setLocale:localeStr withName:nameStr];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
