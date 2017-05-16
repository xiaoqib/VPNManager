//
//  AboutViewController.m
//  WFReader
//
//  Created by jhtzh on 17/2/6.
//  Copyright © 2017年 tigerwf. All rights reserved.
//

#import "AboutViewController.h"
#import <StoreKit/StoreKit.h>
#import "IntroductionViewController.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialCore/UMSocialCore.h>




@interface AboutViewController ()<UITableViewDelegate, UITableViewDataSource, SKStoreProductViewControllerDelegate>
@property (weak, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *titles;
@property (copy, nonatomic) NSArray *images;
@property (strong, nonatomic) NSString *appid;
@end

@implementation AboutViewController

- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@[@"连接不上如何解决",@"赏个好评",@"联系我们",@"分享app"]];
    }
    return _titles;
}

- (NSArray *)images
{
    if (!_images) {
        //_images = @[@[@"mine_dingdan",@"mine_ticket",@"mine_dianziqianbao"]];
        _images = @[@[@"",@"",@"",@""]];
    }
    return _images;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backView.image = [UIImage imageNamed:@"backImage"];
    [self.view addSubview:backView];
    
    [self setup];
    [self setNavigationbar];
}

- (void)setup
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusHeight, SWidth, SHeight - 64) style:UITableViewStyleGrouped];//UITableViewStyleGrouped
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)setNavigationbar {
    //自定义背景
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];  //设置Label背景透明
    titleLabel.font = [UIFont boldSystemFontOfSize:20];  //设置文本字体与大小
    titleLabel.textColor = [UIColor whiteColor];  //设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"用户手册";  //设置标题
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MeViewCellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MeViewCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MeViewCellId];
        cell.accessoryType = UITableViewCellStyleDefault;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.text = self.titles[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    NSString *AppURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", APPID];
    switch (row) {
        case 0:
            [self toView];
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:AppURL]];
            //[self toStore];
            break;
        case 2:
            [self joinQQ];
            break;
        case 3:
            //分享app
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                // 根据获取的platformType确定所选平台进行下一步操作
                
                    //创建分享消息对象
                    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                    
                    //创建网页内容对象
                    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享标题" descr:@"分享内容描述" thumImage:[UIImage imageNamed:@"logoIcon"]];
                    //设置网页地址
                    shareObject.webpageUrl =@"http://mobile.umeng.com/social";
                    
                    //分享消息对象设置分享内容对象
                    messageObject.shareObject = shareObject;
                    
                    //调用分享接口
                    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                        if (error) {
                            NSLog(@"************Share fail with error %@*********",error);
                        }else{
                            NSLog(@"response data is %@",data);
                        }
                    }];
           
            }];
            
            break;
       
    }
}

- (void) toView {
    IntroductionViewController *VC = [[IntroductionViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:VC];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void) joinQQ {
    NSString  *urlText = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=619414561&card_type=group&source=qrcode"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}

- (void) toStore {
    
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc]init];
    storeProductViewContorller.delegate = self;
    
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId
     @{SKStoreProductParameterITunesItemIdentifier : APPID} completionBlock:^(BOOL result, NSError *error) {
         //回调
         if(error){
             NSLog(@"错误%@",error);
         }else{
             //AS应用界面
             [self presentViewController:storeProductViewContorller animated:YES completion:nil];
         }
     }];
}

#pragma mark - 评分取消按钮监听
//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"");
}


//- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
//{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    
//    //创建网页内容对象
//    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
//    //设置网页地址
//    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
//    
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//                
//            }else{
//                UMSocialLogInfo(@"response data is %@",data);
//            }
//        }
//        [self alertWithError:error];
//    }];
//}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"分享标题" descr:@"分享内容描述" thumImage:[UIImage imageNamed:@"icon"]];
    //设置网页地址
    shareObject.webpageUrl =@"http://mobile.umeng.com/social";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
