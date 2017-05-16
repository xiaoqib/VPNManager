//
//  VPNManagerViewController.m
//  VPNManager-master
//
//  Created by jhtzh on 2017/4/26.
//  Copyright © 2017年 jhtzh. All rights reserved.
//

#import "VPNManagerViewController.h"
#import "MyTableViewCell.h"
#import "AboutViewController.h"
#import "NodeManagerViewController.h"
#import "WSShiningLabel.h"
#import "JWT.h"
#import "GiFHUD.h"

#import "OJLAnimationButton.h"
#import "LXAlertView.h"
#import "Reachability.h"
#import "Masonry.h"


@import NetworkExtension;


@interface VPNManagerViewController () <VPNManagerViewControllerDelegate>

@property(nonatomic, strong) NEVPNManager *vpnManager;

@property(nonatomic, strong) NSArray *nodeArray;//节点信息

@property(nonatomic, strong) WSShiningLabel *tipLb;

@property(nonatomic, strong) UILabel *stateLb;

@property(nonatomic, strong) UIView *nodeView;
@property(nonatomic, strong) UIImageView *imgView;
@property(nonatomic, strong) UILabel *nameLb;

@property(nonatomic, strong) NSDictionary *decoded;
@property(nonatomic, strong) NSString *accessId;
@property(nonatomic, strong) NSString *error;

@property(nonatomic, strong) NSString *identifierStr;

@property (nonatomic,strong)  UIImageView *circleImageView ;

@property(nonatomic) BOOL isStartVPN;

@property(nonatomic) BOOL isSuccess;

@property(nonatomic, strong) NSString *localeStr;

@property(nonatomic, strong)UISwitch * kSwitch;
@property(nonatomic, strong)UIButton * startBtn;

@end

@implementation VPNManagerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"欢迎使用";
    
    UIImageView *backView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backView.image = [UIImage imageNamed:@"backImage"];
    [self.view addSubview:backView];
    
    //UUID
    self.identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    self.isStartVPN = YES;
    self.isSuccess = YES;
    
    [self disconnect];
    
    [self initView];
    
    //获取节点
    [self loadNode];
    
}

- (void) initView {
    
    CGFloat multiple = 1;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        multiple = 1.3;
    } else {
        multiple = 1;
    }
    
    //设置按钮setting
    UIImageView *setImgView = [[UIImageView alloc]init];
    //setImgView.frame = CGRectMake(SWidth-35, 25, 25, 25);
    setImgView.image = [UIImage imageNamed:@"setting"];
    setImgView.userInteractionEnabled = YES;
    [self.view addSubview:setImgView];
    [setImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(@(35));
        make.right.equalTo(@(-20));
        make.width.equalTo(@(25));
        make.height.equalTo(@(25));
    }];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicksetAction:)];
    [setImgView addGestureRecognizer:singleTap];
    
    //节点背景
    self.nodeView = [[UIView alloc] init];
    self.nodeView.backgroundColor = [UIColor colorWithRed:0/255.0 green:187/255.0 blue:156/255.0 alpha:0.5];
    self.nodeView.layer.cornerRadius = 8;
    self.nodeView.layer.masksToBounds = YES;
    [self.view addSubview:self.nodeView];
    [self.nodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(@(80));
        make.width.equalTo(@(250));
        make.height.equalTo(@(50));
    }];
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    [self.nodeView addGestureRecognizer:tapGesturRecognizer];
    
    //国旗
    self.imgView = [[UIImageView alloc]init];
    self.imgView.image = [UIImage imageNamed:@"US"];
    [self.view addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nodeView.mas_centerY);
        make.left.equalTo(@((self.view.frame.size.width-250)/2+10));
        make.width.equalTo(@(45));
        make.height.equalTo(@(40));
    }];
    
    //国家名字
    UILabel *tipLb = [[UILabel alloc]init];
    //tipLb.frame = CGRectMake(self.imgView.frame.origin.x + self.imgView.frame.size.width + 5, y, 100, 40);
    tipLb.textColor = [UIColor whiteColor];
    tipLb.text = @"当前线路";
    [self.view addSubview:tipLb];
    [tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nodeView.mas_centerY);
        make.left.equalTo(@((self.view.frame.size.width-250)/2+55));
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
    }];
    
    
    //国家名字
    self.nameLb = [[UILabel alloc]init];
    //self.nameLb.frame = CGRectMake(tipLb.frame.origin.x + tipLb.frame.size.width + 10, y, 100, 40);
    self.nameLb.textColor = [UIColor whiteColor];
    self.nameLb.text = @"美国";
    self.nameLb.textAlignment = NSTextAlignmentRight;
    [self.nodeView addSubview:self.nameLb];
    [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nodeView.mas_centerY);
        make.right.equalTo(@(-40));
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
    }];
    
    //箭头
    UIImageView *arrowImgView = [[UIImageView alloc]init];
    //arrowImgView.frame = CGRectMake(self.nodeView.frame.origin.x + self.nodeView.frame.size.width - 40, y+5, 30, 30);
    arrowImgView.image = [UIImage imageNamed:@"arrow"];
    [self.nodeView addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nodeView.mas_centerY);
        make.right.equalTo(@(-10));
        make.width.equalTo(@(30));
        make.height.equalTo(@(30));
    }];
    
//    UIImageView *logoImageView = [[UIImageView alloc]init];
//    [logoImageView setImage:[UIImage imageNamed:@"logoIcon"]];
//    [self.view addSubview:logoImageView];
//    [logoImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.height.equalTo(@(200*multiple));
//        make.width.equalTo(@(200*multiple));
//        make.top.equalTo(self.nodeView.mas_bottom).offset(80*multiple);
//    }];
    
    self.circleImageView = [[UIImageView alloc]init];
    self.circleImageView.image = [UIImage imageNamed:@"circleImage1"];
    [self.view addSubview:self.circleImageView];
    [self.circleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(logoImageView.mas_centerX);
//        make.centerY.equalTo(logoImageView.mas_centerY);
        make.top.equalTo(self.nodeView.mas_bottom).offset(80*multiple);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(220*multiple));
        make.height.equalTo(@(220*multiple));
    }];
    
    UIImageView *logoImageView = [[UIImageView alloc]init];
    [logoImageView setImage:[UIImage imageNamed:@"logoIcon"]];
    [self.view addSubview:logoImageView];
    [logoImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerX.equalTo(self.view.mas_centerX);
        make.centerX.equalTo(self.circleImageView.mas_centerX);
        make.centerY.equalTo(self.circleImageView.mas_centerY);
        make.height.equalTo(@(200*multiple));
        make.width.equalTo(@(200*multiple));
        //make.top.equalTo(self.nodeView.mas_bottom).offset(80*multiple);
    }];
    
//    //临时调整
//    UIImageView *circleImageView1 = [[UIImageView alloc]init];
//    circleImageView1.image = [UIImage imageNamed:@"circleImage1"];
//    [self.view addSubview:circleImageView1];
//    [circleImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(logoImageView.mas_centerX);
//        make.centerY.equalTo(logoImageView.mas_centerY);
//        make.width.equalTo(@(230*multiple));
//        make.height.equalTo(@(230*multiple));
//    }];
//    
//    UIImageView *circleImageView2 = [[UIImageView alloc]init];
//    circleImageView2.image = [UIImage imageNamed:@"circleImage1"];
//    [self.view addSubview:circleImageView2];
//    [circleImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(logoImageView.mas_centerX);
//        make.centerY.equalTo(logoImageView.mas_centerY);
//        make.width.equalTo(@(220*multiple));
//        make.height.equalTo(@(220*multiple));
//    }];
    //临时调整
    
    //加速状态
    self.stateLb = [[UILabel alloc]init];
    //self.stateLb.frame = CGRectMake((SWidth-200)/2, 40+self.startBtn.frame.origin.y + self.startBtn.frame.size.height, 200, 40);
    self.stateLb.textColor = [UIColor whiteColor];
    self.stateLb.textAlignment = NSTextAlignmentCenter;
    self.stateLb.font = [UIFont systemFontOfSize:20.0f];
    self.stateLb.text = @"尚未进行加速";
    [self.view addSubview:self.stateLb];
    [self.stateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.circleImageView.mas_bottom).offset(30*multiple);
        make.width.equalTo(@(200));
        make.height.equalTo(@(40));
    }];
    
    
    UISwitch * kSwitch = [[UISwitch alloc]init];
    [self.view addSubview:kSwitch];
    [kSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.stateLb.mas_bottom).offset(40*multiple);
        //make.width.equalTo(@(100));
        make.height.equalTo(@(20));
    }];
    [kSwitch setOn:NO];
    [kSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    self.kSwitch = kSwitch;
}

//闪烁效果
-(void) picturesTwinkle {
    self.circleImageView.image = [UIImage imageNamed:@"circleImage2"];
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    theAnimation.duration=1;
    theAnimation.repeatCount = 10000;
    theAnimation.removedOnCompletion = NO;
    theAnimation.fromValue = [NSNumber numberWithFloat:1];
    theAnimation.toValue = [NSNumber numberWithFloat:1.5];
    [self.circleImageView.layer addAnimation:theAnimation forKey:@"animateTransform"];
}

// 正向开始旋转
-(void)picturesRotatingActionPositive {
   self.circleImageView.image = [UIImage imageNamed:@"circleImage3"];
   
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: - M_PI * 2.0 ];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 10000;
    
    rotationAnimation.removedOnCompletion = NO;
    
    [self.circleImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

// 逆向向开始旋转
-(void)picturesRotatingActionReverse {
    self.circleImageView.image = [UIImage imageNamed:@"circleImage3"];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 10000;
    
    rotationAnimation.removedOnCompletion = NO;
    
    [self.circleImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

//结束旋转
- (void)endAction {
    [self.circleImageView.layer removeAllAnimations];
    
    self.circleImageView.image = [UIImage imageNamed:@"circleImage1"];
}
//完成旋转 加载整个图片
-(void)finishAction  {
    [self.circleImageView.layer removeAllAnimations];
    
    self.circleImageView.image = [UIImage imageNamed:@"circleImage1"];
}


#pragma mark VPNS
//创建VPN 配置文件
-(void)createVPNProfile:(BOOL) isFromNet{
    
    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        if (error) {
            NSLog(@"Load config failed[%@]", error.localizedDescription);
            
            [self connecterror];
            return;
        } else {
            NSLog(@"Load config success");
        }
        
        if ([NEVPNManager sharedManager].protocolConfiguration) {
            // config exists
            //return;
        }
        
        [self setupIPSec];
        
        [[NEVPNManager sharedManager] saveToPreferencesWithCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"Save config failed[%@]", error.localizedDescription);
                [self connecterror];
            } else {
                NSLog(@"Save config success");
                
                [self startConnect:isFromNet];
            }
        }];
    }];
}

//移除VPN 配置
- (void)removeVPNProfile
{
    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error){
        if (!error)
        {
            [[NEVPNManager sharedManager] removeFromPreferencesWithCompletionHandler:^(NSError *error){
                if(error)
                {
                    NSLog(@"Remove error: %@", error);
                }
                else
                {
                    NSLog(@"removeFromPreferences");
                }
            }];
        }
    }];
    
}

//配置VPN 本地信息

- (void) setupIPSec {
    
    
    NSLog(@"identifierStr===%@",self.identifierStr);
    
    NSLog(@"decoded===%@",self.decoded);
    
    
    NEVPNProtocolIKEv2 *p_ikev2 = [[NEVPNProtocolIKEv2 alloc]init];
    
    //NEVPNProtocolIPSec *p = [[NEVPNProtocolIPSec alloc]init];
    //配置IPSec protocol self.identifierStr
    p_ikev2.username = self.identifierStr;//Your username
    p_ikev2.serverAddress = self.decoded[@"host"];//Your server address
    
    NSLog(@"**********************%@**********************",self.decoded[@"host"]);
    
    if ([self createKeychainValue:self.decoded[@"password"] forIdentifier:@"VPN_PASSWORD"]) {
        p_ikev2.passwordReference = [self searchKeychainCopyMatching:@"VPN_PASSWORD"];//VPN_PASSWORD
    }
    
    // PSK
    
    p_ikev2.authenticationMethod = NEVPNIKEAuthenticationMethodNone;
    
//    if ([self createKeychainValue:self.decoded[@"keychain"] forIdentifier:@"PSK"]) {
//        p_ikev2.sharedSecretReference = [self searchKeychainCopyMatching:@"PSK"];
//    }
    
    p_ikev2.remoteIdentifier = self.decoded[@"host"];
    //p.localIdentifier = @"myvpn";
    
    p_ikev2.useExtendedAuthentication = YES;
    
    p_ikev2.disconnectOnSleep = NO;
    
    
    //[NEVPNManager sharedManager].protocol = p_ikev2;
    [NEVPNManager sharedManager].protocolConfiguration = p_ikev2;
    [[NEVPNManager sharedManager] setOnDemandEnabled:NO];
    [[NEVPNManager sharedManager] setLocalizedDescription:VPN_NAME];//VPN自定义名字
    [[NEVPNManager sharedManager] setEnabled:YES];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tipLb startShimmer];
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        
        //[self picturesTwinkle];
        [self picturesRotatingActionPositive];
        
        self.kSwitch.userInteractionEnabled = NO;
        [self startAction];
        
    }else {
        [self disconnect];
        [self endAction];
    }
}


-(void)startAction
{
    self.nodeView.userInteractionEnabled = NO;
    
    if (![self isExistenceNetwork]) {
        [self endAction];
        return;
    }
    
    NSLog(@"点击了startAction");
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = [user objectForKey:@"VPINFO"];
    
    if (data != nil) {
        
        self.decoded = [NSKeyedUnarchiver unarchiveObjectWithData:data];

        if (self.isSuccess) {
            if (self.isStartVPN) {
                
                //VPN配置
                [self createVPNProfile:NO];
                
            } else {
                [self disconnect];
            }
        } else {
            NSLog(@"VPN配置错误");
        }
    } else {
        [self loadData];
    }
}

- (void) startVPNConnect{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VPNStatusDidChangeNotification) name:NEVPNStatusDidChangeNotification object:nil];
    
    [[NEVPNManager sharedManager]loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        if (!error) {
            
            NSLog(@"start Connectioning!");
            
            //[self setupIPSec];
            
            NSError *startError;
            [[NEVPNManager sharedManager].connection startVPNTunnelAndReturnError:&startError];
            if (startError) {
                NSLog(@"Start VPN failed: [%@]", startError.localizedDescription);
                //[GiFHUD dismiss];
                
                self.error = startError.localizedDescription;
                
                [self connecterror];
                [self loadData];

            } else {
                NSLog(@"connection success");
            }
        } else {
            NSLog(@"Start error: %@", error.localizedDescription);
            
            self.error = error.localizedDescription;
            //[GiFHUD dismiss];
            [self connecterror];
            [self loadData];
        }
    }];
}

- (void)startConnect:(BOOL)isFromNet{
    self.stateLb.text = @"加速准备中";
    
    if (isFromNet) {
        [self performSelector:@selector(startVPNConnect) withObject:nil afterDelay:2.0f];
    } else {
        [self startVPNConnect];
    }
    
}

//断开VPN
- (void)disconnect {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VPNStatusDidChangeNotification) name:NEVPNStatusDidChangeNotification object:nil];
    
    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        if (!error)
        {
            [[NEVPNManager sharedManager].connection stopVPNTunnel];
        }
    }];
}

#pragma mark - VPN状态切换通知
- (void)VPNStatusDidChangeNotification
{
//    NEVPNStatusConnected 已连接
//    NEVPNStatusDisconnected 断开
//    NEVPNStatusConnecting 正在连接
//    NEVPNStatusDisconnecting 正在断线
//    NEVPNStatusInvalid 无效状态，配置有错
//    NEVPNStatusReasserting 暂时无法获得确切状态
    switch ([NEVPNManager sharedManager].connection.status)
    {
        case NEVPNStatusInvalid:
        {
            NSLog(@"NEVPNStatusInvalid");
            self.nodeView.userInteractionEnabled = YES;
            [self endAction];
            self.kSwitch.userInteractionEnabled = YES;
            break;
        }
        case NEVPNStatusDisconnected:
        {
            NSLog(@"NEVPNStatusDisconnected");
            self.nodeView.userInteractionEnabled = YES;
            
            self.kSwitch.on = NO;
            
            if (!self.isStartVPN) {
               [self endAction];
            }
            
            self.stateLb.text = @"已停止加速";
            self.kSwitch.userInteractionEnabled = YES;
            self.isStartVPN = YES;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
        case NEVPNStatusConnecting:
        {
            NSLog(@"NEVPNStatusConnecting");
            self.kSwitch.on = YES;
            
            self.stateLb.text = @"加速准备中";
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            break;
        }
        case NEVPNStatusConnected:
        {
            NSLog(@"NEVPNStatusConnected");
            self.kSwitch.userInteractionEnabled = YES;
            self.nodeView.userInteractionEnabled = YES;
            
            [self picturesRotatingActionReverse];
            //[GiFHUD dismiss];
            self.isStartVPN = NO;
            self.stateLb.text = @"已经开启加速模式";
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
        case NEVPNStatusReasserting:
        {
            NSLog(@"NEVPNStatusReasserting");
            self.nodeView.userInteractionEnabled = YES;
            break;
        }
        case NEVPNStatusDisconnecting:
        {
            NSLog(@"NEVPNStatusDisconnecting");
            self.nodeView.userInteractionEnabled = YES;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark VPN end

-(void)clicksetAction:(id)tap
{
    NSLog(@"点击了clicksetAction");
    
    [self.tipLb stopShimmer];
    
    AboutViewController *aboutVC = [[AboutViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:aboutVC];
    [self presentViewController:navi animated:YES completion:nil];
}

-(void)clickAction:(id)tap
{
    NSLog(@"点击了clickAction");
    
    [self.tipLb stopShimmer];
    
    [self disconnect];
    
    NodeManagerViewController *nodeVC = [[NodeManagerViewController alloc]init];
    nodeVC.jsonArray = self.nodeArray;
    nodeVC.delegae = self;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:nodeVC];
    
    [self presentViewController:navi animated:YES completion:nil];
}

- (NSString *) JWTForAuthorization {

    if (self.localeStr == nil || [self.localeStr isEqual:@""] ) {
        self.localeStr = @"US";
    }
    
    NSDictionary *payload = @{@"deviceId":self.identifierStr, @"protocol":@"IKEV2", @"locale":self.localeStr};
    NSString *secret = @"YzIwYjgyNGUtNmI0YS00ZTBmLTliZmEtMTkzZDA4OWZhODkzCg==";
    
    NSError *error;
    NSString *Authorization = [Jwt encodeWithPayload:payload andKey:secret andAlgorithm:HS256 andError:&error];
    
    return Authorization;
}

//获取节点信息
- (void) loadNode {
    NSString *urlString = @"https://api.zhaoerdan.com/api/clients/locales?";
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *country = [locale localeIdentifier];
    if ([country isEqual:@"zh_CN"]) {
        urlString = @"https://api.zhaoerdan.com/api/clients/locales?";
    } else {
        urlString = @"https://v6.zhaoerdan.com/api/clients/locales?";
    }

    
    [[NetworkSingleton sharedManager] GET:urlString parameters:nil success:^(id responseObject) {
        
        self.nodeArray = responseObject;
        NSLog(@"%@", self.nodeArray);
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
}

-(void) connecterror {
    self.kSwitch.on = NO;
    self.kSwitch.userInteractionEnabled = YES;
    self.nodeView.userInteractionEnabled = YES;
    self.stateLb.text = @"网络问题";
    
    [self endAction];
}

//获取VP信息
- (void) loadData{
    //https://api.zhaoerdan.com/api/clients/locales
    NSString *urlString = @"https://api.zhaoerdan.com/api/clients/register?";
    
    NSLocale *locale = [NSLocale currentLocale];
    NSString *country = [locale localeIdentifier];
    if ([country isEqual:@"zh_CN"]) {
        urlString = @"https://api.zhaoerdan.com/api/clients/register?";
    } else {
        urlString = @"https://v6.zhaoerdan.com/api/clients/register?";
    }
    
    NSString *Authorization = [self JWTForAuthorization];
    
    NSDictionary *parameters = [NSDictionary new];
    
    if (self.error != nil) {
        parameters = @{@"error":self.error, @"accessId":self.accessId};
    }
    
    [[NetworkSingleton sharedManager] POST:urlString parameters:parameters withJWT:Authorization success:^(id responseObject) {
        
        NSString *secret = @"YzIwYjgyNGUtNmI0YS00ZTBmLTliZmEtMTkzZDA4OWZhODkzCg==";
        
        NSDictionary *dict = responseObject;
        NSString *token = dict[@"token"];
        
        self.accessId = dict[@"accessId"];
        
        NSError *error;
        
        NSDictionary *dic = [Jwt decodeWithToken:token andKey:secret andVerify:true andError:&error];
        self.decoded = dic;
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [user setObject:data forKey:@"VPINFO"];
        
        self.isSuccess = YES;
        
        //VPN配置
        [self createVPNProfile:YES];
        
    } failure:^(NSError *error) {
        NSLog(@"请求网络数据失败");
        self.isSuccess = NO;
        [self connecterror];
    }];
}


#pragma mark - KeyChain

static NSString * const serviceName = @"im.zorro.ipsec_demo.vpn_config";

- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
    
}

- (NSData *)searchKeychainCopyMatching:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    
    // Add search attributes
    
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    // Add search return types
    
    // Must be persistent ref !!!!
    
    [searchDictionary setObject:@YES forKey:(__bridge id)kSecReturnPersistentRef];
    
    CFTypeRef result = NULL;
    
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &result);
    
    return (__bridge_transfer NSData *)result;
    
}

- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dictionary);
    
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    [dictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    
    if (status == errSecSuccess) {
        
        return YES;
        
    }
    
    return NO;
    
}

-(void)setLocale:(NSString *)localeStr withName:(NSString*)name{
    self.localeStr = localeStr;
    self.imgView.image = [UIImage imageNamed:self.localeStr];
    self.nameLb.text = name;
}

-(BOOL) isExistenceNetwork {
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:{
            isExistenceNetwork = NO;
            NSLog(@"`````````网络不给力");
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前无网络" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            
            [alert addAction:actionOK];
            
            [self presentViewController:alert animated:YES completion:^{
                
                
            }];
            
            
            break;
        }
        case ReachableViaWiFi:{
            isExistenceNetwork = YES;
            break;
        }
        case ReachableViaWWAN:{
            isExistenceNetwork = YES;
            break;
        }
    }
    return isExistenceNetwork;
}


#pragma mark OJLAnimationButtonDelegate
-(void)OJLAnimationButtonDidStartAnimation:(OJLAnimationButton *)OJLAnimationButton{
    NSLog(@"start");
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [OJLAnimationButton stopAnimation];
//    });
}

-(void)OJLAnimationButtonDidFinishAnimation:(OJLAnimationButton *)OJLAnimationButton{
    NSLog(@"stop");
}

-(void)OJLAnimationButtonWillFinishAnimation:(OJLAnimationButton *)OJLAnimationButton{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
