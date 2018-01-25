//
//  AppDelegate.m
//  CPEducation_AP
//
//  Created by lishouping on 16/12/22.
//  Copyright © 2016年 李寿平. All rights reserved.
//

#import "AppDelegate.h"
#import "InformationViewController.h"
#import "NoticeViewController.h"
#import "MeetingViewController.h"
#import "InvestigViewController.h"
#import "LoginViewController.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "JPUSHService.h"
#import "ForgetPassViewController.h"

#import "NoticeDeatileViewController.h"
#import "NoticeDetaledViedoViewController.h"
#import "NoticeDeatledMoreImgViewController.h"
#import "NoticeDetailedImageUpViewController.h"
#import "NoticeDetaledImageDownViewController.h"

#import "MettingDeatileViewController.h"
#import "MettingDeatledMoreImgViewController.h"
#import "MettingDetaledViedoViewController.h"
#import "MettingDetailedImageUpViewController.h"
#import "MeetingDetaledImageDownViewController.h"

#import "InvestigDeatileViewController.h"
#import "InvestigDetailedImageUpViewController.h"
#import "InvestigDetaledImageDownViewController.h"
#import "InvestigDetaledViedoViewController.h"
#import "InvestigDeatledMoreImgViewController.h"


#import "InfoDetailedViewController.h"
#import "InfoDetailedImageUpViewController.h"
#import "InfoDetaledImageDownViewController.h"
#import "InfoDeatledMoreImgViewController.h"
#import "InfoDetaledViedoViewController.h"

#import "PendingModel.h"

#import "MineViewController.h"



@interface AppDelegate ()<JPUSHRegisterDelegate,UIAlertViewDelegate>{
    NSDictionary *docmesg;
    NSTimer *timer;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Override point for customization after application launch.
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];

    
    [self createLocalDB];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]] ;
    self.window.backgroundColor = [UIColor whiteColor];
   
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    
    

    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString *islogin =  [userDefaults objectForKey:@"islogin_CP"];
    NSString *telephone =  [userDefaults objectForKey:@"telephone_CP"];
    if ([islogin isEqualToString:@"true"]) {
        [self createAppearance];
        [self createWindowRootViewController];
         [self deleteSql:@"1"];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        [JPUSHService setAlias:telephone callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = navc;
    }
    
    

    
    [NSThread sleepForTimeInterval:2.0];
    [self.window makeKeyAndVisible];
    
    
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:@"loginState"
                                               object:nil];
     NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
    if (userInfo) {
        NSLog(@"推送消息==== %@",userInfo);
        
        NSString *conType = [userInfo objectForKey:@"conType"];
        NSString *contentid = [userInfo objectForKey:@"contentid"];
        NSString *cTitle = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        NSString *pendingTitle;
        
        NSString *pendingContent = [userInfo objectForKey:@"pendingContent"];
        NSString *pendingTime = [userInfo objectForKey:@"pendingTime"];
        NSString *pendingType = [userInfo objectForKey:@"pendingType"];
        NSString *state = [userInfo objectForKey:@"state"];
        NSString *template = [userInfo objectForKey:@"template"];
        if ([pendingType isEqualToString:@"0"]||[pendingType isEqualToString:@"2"]) {
            pendingTitle = [cTitle substringToIndex:cTitle.length-6];
        }else{
            pendingTitle = cTitle;
        }
        NSLog(@"iOS7及以上系统，收到通知:%@",userInfo);
        docmesg = @{
                    @"conType":conType,
                    @"contentid":contentid,
                    @"pendingTitle":pendingTitle,
                    @"pendingContent":pendingContent,
                    @"pendingTime":pendingTime,
                    @"pendingType":pendingType,
                    @"state":state,
                    @"template":template
                    };
        
        if ([[docmesg objectForKey:@"conType"] isEqualToString:@"1"]) {
            if ([[docmesg objectForKey:@"pendingType"] isEqualToString:@"0"]||[[docmesg objectForKey:@"pendingType"] isEqualToString:@"1"]) {//会议提醒
                // 插入重复待办
                BOOL isSucceed;
                // 插入新待办提醒
                PendingModel *model = [[PendingModel alloc] init];
                model.pendingTime  = [[docmesg objectForKey:@"pendingTime"] substringToIndex:19];
                model.pendingTitle = [docmesg objectForKey:@"pendingTitle"];
                model.pendingContent = [docmesg objectForKey:@"pendingContent"];
                model.pendingType = @"0";
                [self.cpeduDateBase beginTransaction];
                isSucceed = [self.cpeduDateBase executeUpdate:@"INSERT INTO Pending (pendingTime, pendingTitle, pendingContent,pendingType) VALUES (?,?,?,?)", model.pendingTime, model.pendingTitle, model.pendingContent,model.pendingType];
                
                if (isSucceed)
                {
                    [self.cpeduDateBase commit];
                    NSLog(@"-----添加待办提醒信息");
                }
                else
                {
                    [self.cpeduDateBase rollback];
                }
            }
        }
       
        
        [self jumpViewController:docmesg];
    }
    return YES;
    
}

// 极光别名注册的回调方法
-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"极光别名注册的回调方法rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    if (iResCode == 0) {
        // 注册成功
        NSLog(@"----设置别名成功");
    }
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
   
    
    NSString *srt = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"---------%@",srt);
    
    InvestigDeatileViewController *VC = [InvestigDeatileViewController new];
    VC.contentid = srt;
    UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
    [self.window.rootViewController presentViewController:na animated:YES completion:nil];
    
    return YES;
}

#pragma mark —页面跳转针对app关闭的情况
- (void)jumpViewController:(NSDictionary*)tfdic
{
    NSString *type = [tfdic objectForKey:@"conType"];////类型 0：通知；1：会议；2：调查；3：公共信息
    NSString *contentid = [tfdic objectForKey:@"contentid"];//内容id
    NSString *template = [tfdic objectForKey:@"template"];////模板id 0-全文字 1-图上文下 2-图下文上 3-多图 4-视频
    NSString *pendingType = [tfdic objectForKey:@"pendingType"];//0-会议提醒 1-非会议提醒 2-再次提醒
    

    if ([type isEqualToString:@"0"]) {
        if ([template isEqualToString:@"0"]) {
            NoticeDeatileViewController *VC = [NoticeDeatileViewController new];
            VC.contentid = contentid;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }else if ([template isEqualToString:@"1"]){
            NoticeDetailedImageUpViewController *VC = [NoticeDetailedImageUpViewController new];
            VC.contentid = contentid;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }else if ([template isEqualToString:@"2"]){
            NoticeDetaledImageDownViewController *VC = [NoticeDetaledImageDownViewController new];
            VC.contentid = contentid;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }else if ([template isEqualToString:@"3"]){
            NoticeDeatledMoreImgViewController *VC = [NoticeDeatledMoreImgViewController new];
            VC.contentid = contentid;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }else if ([template isEqualToString:@"4"]){
            NoticeDetaledViedoViewController *VC = [NoticeDetaledViedoViewController new];
            VC.contentid = contentid;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }
        self.pagerefresh = @"update";
    }else if ([type isEqualToString:@"1"]){//会议
        //pendingType 0-会议提醒 1-非会议提醒 2-再次提醒
        if ([pendingType isEqualToString:@"0"]) {
            if ([template isEqualToString:@"0"]) {
                MettingDeatileViewController *VC = [MettingDeatileViewController new];
                VC.contentid = contentid;
                VC.attendstate = @"0";
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
                [self.window.rootViewController presentViewController:na animated:YES completion:nil];
            }else if ([template isEqualToString:@"1"]){
                MettingDetailedImageUpViewController *VC = [MettingDetailedImageUpViewController new];
                VC.contentid = contentid;
                VC.attendstate = @"0";
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
                [self.window.rootViewController presentViewController:na animated:YES completion:nil];
            }else if ([template isEqualToString:@"2"]){
                MeetingDetaledImageDownViewController *VC = [MeetingDetaledImageDownViewController new];
                VC.contentid = contentid;
                VC.attendstate = @"0";
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
                [self.window.rootViewController presentViewController:na animated:YES completion:nil];
            }else if ([template isEqualToString:@"3"]){
                MettingDeatledMoreImgViewController *VC = [MettingDeatledMoreImgViewController new];
                VC.contentid = contentid;
                VC.attendstate = @"0";
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
                [self.window.rootViewController presentViewController:na animated:YES completion:nil];
            }else if ([template isEqualToString:@"4"]){
                MettingDetaledViedoViewController *VC = [MettingDetaledViedoViewController new];
                VC.contentid = contentid;
                VC.attendstate = @"0";
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
                [self.window.rootViewController presentViewController:na animated:YES completion:nil];
            }
            self.pagerefresh = @"update";
        }else if ([pendingType isEqualToString:@"1"]){
            if ([template isEqualToString:@"0"]) {
                MettingDeatileViewController *VC = [MettingDeatileViewController new];
                VC.contentid = contentid;
                VC.attendstate = @"0";
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
                [self.window.rootViewController presentViewController:na animated:YES completion:nil];
            }else if ([template isEqualToString:@"1"]){
                MettingDetailedImageUpViewController *VC = [MettingDetailedImageUpViewController new];
                VC.contentid = contentid;
                VC.attendstate = @"0";
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
                [self.window.rootViewController presentViewController:na animated:YES completion:nil];
            }else if ([template isEqualToString:@"2"]){
                MeetingDetaledImageDownViewController *VC = [MeetingDetaledImageDownViewController new];
                VC.contentid = contentid;
                VC.attendstate = @"0";
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
                [self.window.rootViewController presentViewController:na animated:YES completion:nil];
            }else if ([template isEqualToString:@"3"]){
                MettingDeatledMoreImgViewController *VC = [MettingDeatledMoreImgViewController new];
                VC.contentid = contentid;
                VC.attendstate = @"0";
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
                [self.window.rootViewController presentViewController:na animated:YES completion:nil];
            }else if ([template isEqualToString:@"4"]){
                MettingDetaledViedoViewController *VC = [MettingDetaledViedoViewController new];
                VC.contentid = contentid;
                VC.attendstate = @"0";
                UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
                [self.window.rootViewController presentViewController:na animated:YES completion:nil];
            }
            self.pagerefresh = @"update";
        }else if ([pendingType isEqualToString:@"2"]){
            MineViewController *VC = [MineViewController new];
            VC.selectpos = @"1";
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }
    }else if ([type isEqualToString:@"2"]){ //调查
        if ([template isEqualToString:@"0"]) {
            InvestigDeatileViewController *VC = [InvestigDeatileViewController new];
            VC.contentid = contentid;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }else if ([template isEqualToString:@"1"]){
            InvestigDetailedImageUpViewController *VC = [InvestigDetailedImageUpViewController new];
            VC.contentid = contentid;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }else if ([template isEqualToString:@"2"]){
            InvestigDetaledImageDownViewController *VC = [InvestigDetaledImageDownViewController new];
            VC.contentid = contentid;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }else if ([template isEqualToString:@"3"]){
            InvestigDeatledMoreImgViewController *VC = [InvestigDeatledMoreImgViewController new];
            VC.contentid = contentid;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }else if ([template isEqualToString:@"4"]){
            InvestigDetaledViedoViewController *VC = [InvestigDetaledViedoViewController new];
            VC.contentid = contentid;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }
        self.pagerefresh = @"update";
    }else if ([type isEqualToString:@"3"]){ //公共信息
        if ([template isEqualToString:@"0"]) {
            InfoDetailedViewController *VC = [InfoDetailedViewController new];
            VC.contentid = contentid;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }else if ([template isEqualToString:@"1"]){
            InfoDetailedImageUpViewController *VC = [InfoDetailedImageUpViewController new];
            VC.contentid = contentid;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }else if ([template isEqualToString:@"2"]){
            InfoDetaledImageDownViewController *VC = [InfoDetaledImageDownViewController new];
            VC.contentid = contentid;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }else if ([template isEqualToString:@"3"]){
            InfoDeatledMoreImgViewController *VC = [InfoDeatledMoreImgViewController new];
            VC.contentid = contentid;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }else if ([template isEqualToString:@"4"]){
            InfoDetaledViedoViewController *VC = [InfoDetaledViedoViewController new];
            VC.contentid = contentid;
            UINavigationController *na = [[UINavigationController alloc] initWithRootViewController:VC];
            [self.window.rootViewController presentViewController:na animated:YES completion:nil];
        }
        self.pagerefresh = @"update";
    }

}
// 创建数据库
-(void)createLocalDB{
    self.cpeduDateBase=[CpeduDateBase shareInstance];
    //[self setPending];
}
#pragma mark - login changed

- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    
    if (loginSuccess) {//登陆成功加载主窗口控制器
            [self createAppearance];
            [self createWindowRootViewController];
    }
    else{//登陆失败加载登陆页面控制器
        NSLog(@"-------------%id",loginSuccess);
    }
    
}
//导航条的颜色以及tabBar的背景色 tabBarItem的title的颜色
-(void)createAppearance
{
    //状态栏的颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=7.0)
    {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1]];
        //导航条标题的颜色
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
        //tabBar的背景色
        [UITabBar appearance].barTintColor=[UIColor colorWithRed:252.0/255 green:252.0/255 blue:252.0/255 alpha:1];
        //tabBarItem的title的颜色
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1] forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithRed:158.0/255 green:158.0/255 blue:158.0/255 alpha:1] forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    }
    else
    {
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:26.0/255 green:31.0/255 blue:44.0/255 alpha:1]];
        //导航条标题的颜色
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
        //tabBar的背景色
        [UITabBar appearance].barTintColor=[UIColor colorWithRed:252.0/255 green:252.0/255 blue:252.0/255 alpha:1];
        //tabBarItem的title的颜色
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1] forKey:NSForegroundColorAttributeName] forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithRed:158.0/255 green:158.0/255 blue:158.0/255 alpha:1] forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
    }
    
}


//创建TabBarController
-(void)createWindowRootViewController
{
    NSArray * classViewControllerArray=@[@"NoticeViewController",@"MeetingViewController",@"InvestigViewController",@"InformationViewController"];
    NSArray * titleArray=@[@"通知",@"会议",@"调查",@"信息"];
    NSArray * itemSelectImageArray=@[@"notice_press",@"metting_press",@"survey_press",@"info_press"];
    NSArray * itemNormalImageArray=@[@"notice_normal",@"metting_normal",@"survey_normal",@"info_normal"];
    NSMutableArray * viewControllersArray=[NSMutableArray arrayWithCapacity:0];
    int i=0;
    for (NSString * vcName in classViewControllerArray)
    {
        Class ViewController=NSClassFromString(vcName);
        UIViewController * vc=(UIViewController *)[[ViewController alloc]init];
        vc.title=titleArray[i];
        UINavigationController * nvc=[[UINavigationController alloc]initWithRootViewController:vc];
        if ([[[UIDevice currentDevice]systemVersion] floatValue]>=7.0) {
            nvc.tabBarItem.selectedImage = [[UIImage imageNamed:itemSelectImageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            nvc.tabBarItem.image = [[UIImage imageNamed:itemNormalImageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            //tabbar.tintColor = [UIColor whiteColor];
//            if (i==0) {
//                nvc.tabBarItem.badgeColor = [UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1];
//                nvc.tabBarItem.badgeValue = @"12";
//            }
            
        }else{
            
            [nvc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:itemSelectImageArray[i]] withFinishedUnselectedImage:[UIImage imageNamed:itemNormalImageArray[i]]];
        }
        i++;
        [viewControllersArray addObject:nvc];
    }
    UITabBarController * tbc=[[UITabBarController alloc]init];
    tbc.viewControllers=viewControllersArray;
    self.window.rootViewController=tbc;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary*)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
    NSString *conType = [userInfo objectForKey:@"conType"];
    NSString *contentid = [userInfo objectForKey:@"contentid"];
    NSString *cTitle = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *pendingTitle;
    
    NSString *pendingContent = [userInfo objectForKey:@"pendingContent"];
    NSString *pendingTime = [userInfo objectForKey:@"pendingTime"];
    NSString *pendingType = [userInfo objectForKey:@"pendingType"];
    NSString *state = [userInfo objectForKey:@"state"];
    NSString *template = [userInfo objectForKey:@"template"];
    if ([pendingType isEqualToString:@"0"]||[pendingType isEqualToString:@"2"]) {
        pendingTitle = [cTitle substringToIndex:cTitle.length-6];
    }else{
        pendingTitle = cTitle;
    }
    NSLog(@"iOS7及以上系统，收到通知:%@",userInfo);
    docmesg = @{
                @"conType":conType,
                @"contentid":contentid,
                @"pendingTitle":pendingTitle,
                @"pendingContent":pendingContent,
                @"pendingTime":pendingTime,
                @"pendingType":pendingType,
                @"state":state,
                @"template":template
                };
    
    if ([[docmesg objectForKey:@"conType"] isEqualToString:@"1"]) {
        if ([[docmesg objectForKey:@"pendingType"] isEqualToString:@"0"]||[[docmesg objectForKey:@"pendingType"] isEqualToString:@"1"]) {//会议提醒
            // 插入重复待办
            BOOL isSucceed;
            // 插入新待办提醒
            PendingModel *model = [[PendingModel alloc] init];
            model.pendingTime  = [[docmesg objectForKey:@"pendingTime"] substringToIndex:19];
            model.pendingTitle = [docmesg objectForKey:@"pendingTitle"];
            model.pendingContent = [docmesg objectForKey:@"pendingContent"];
            model.pendingType = @"0";
            [self.cpeduDateBase beginTransaction];
            isSucceed = [self.cpeduDateBase executeUpdate:@"INSERT INTO Pending (pendingTime, pendingTitle, pendingContent,pendingType) VALUES (?,?,?,?)", model.pendingTime, model.pendingTitle, model.pendingContent,model.pendingType];
            
            if (isSucceed)
            {
                [self.cpeduDateBase commit];
                NSLog(@"-----添加待办提醒信息");
            }
            else
            {
                [self.cpeduDateBase rollback];
            }
        }
    }
    
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示!" message:[NSString stringWithFormat:@"%@",@"收到新消息是否查看"] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"查看", nil];
    alert.delegate = self;
    [alert show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSString *conType = [userInfo objectForKey:@"conType"];
    NSString *contentid = [userInfo objectForKey:@"contentid"];
    NSString *cTitle = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *pendingTitle;
    
    NSString *pendingContent = [userInfo objectForKey:@"pendingContent"];
    NSString *pendingTime = [userInfo objectForKey:@"pendingTime"];
    NSString *pendingType = [userInfo objectForKey:@"pendingType"];
    NSString *state = [userInfo objectForKey:@"state"];
    NSString *template = [userInfo objectForKey:@"template"];
    if ([pendingType isEqualToString:@"0"]||[pendingType isEqualToString:@"2"]) {
        pendingTitle = [cTitle substringToIndex:cTitle.length-6];
    }else{
        pendingTitle = cTitle;
    }
    NSLog(@"iOS7及以上系统，收到通知:%@",userInfo);
    docmesg = @{
    @"conType":conType,
    @"contentid":contentid,
    @"pendingTitle":pendingTitle,
    @"pendingContent":pendingContent,
    @"pendingTime":pendingTime,
    @"pendingType":pendingType,
    @"state":state,
    @"template":template
    };
    if ([[docmesg objectForKey:@"conType"] isEqualToString:@"1"]) {
        if ([[docmesg objectForKey:@"pendingType"] isEqualToString:@"0"]||[[docmesg objectForKey:@"pendingType"] isEqualToString:@"2"]) {//会议提醒
            // 插入重复待办
            BOOL isSucceed;
            // 插入新待办提醒
            PendingModel *model = [[PendingModel alloc] init];
            model.pendingTime  = [[docmesg objectForKey:@"pendingTime"] substringToIndex:19];
            model.pendingTitle = [docmesg objectForKey:@"pendingTitle"];
            model.pendingContent = [docmesg objectForKey:@"pendingContent"];
            model.pendingType = @"0";
            [self.cpeduDateBase beginTransaction];
            isSucceed = [self.cpeduDateBase executeUpdate:@"INSERT INTO Pending (pendingTime, pendingTitle, pendingContent,pendingType) VALUES (?,?,?,?)", model.pendingTime, model.pendingTitle, model.pendingContent,model.pendingType];
            
            if (isSucceed)
            {
                [self.cpeduDateBase commit];
                NSLog(@"-----添加待办提醒信息");
            }
            else
            {
                [self.cpeduDateBase rollback];
            }
        }
    }
    

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示!" message:[NSString stringWithFormat:@"%@",@"收到新消息是否查看"] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"查看", nil];
    alert.delegate = self;
    [alert show];
    
    JPushNotificationRequest *notf = [[JPushNotificationRequest alloc] init];
    
    [JPUSHService addNotification:notf];
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",@"收到消息"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
    [alert show];
    
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
     NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:@"查看"]) {
         [self jumpViewController:docmesg];
    }
    
}


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    
    
    return str;
}
-(void)updateAction{
    [self selectSql];
}
-(void)selectSql{
    // 查询表
    //从数据库中读数据
    FMResultSet * set = [self.cpeduDateBase executeQuery:@"select * from Pending where pendingType= ?",@"0"];
    while ([set next])
    {
        NSString *pendingid = [set stringForColumn:@"id"];
        NSString *pendingTime  = [set stringForColumn:@"pendingTime"];
        NSString *pendingTitle  = [set stringForColumn:@"pendingTitle"];
        NSDate *date = [NSDate date]; // 获得时间对象
        NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
        [forMatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [forMatter stringFromDate:date];
        
        NSDate * date1 = [forMatter dateFromString:pendingTime];//数据库时间
        NSDate * date2 = [forMatter dateFromString:dateStr];//当前时间
        if ([dateStr isEqualToString:pendingTime]) {
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"会议提醒" message:pendingTitle delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alert show];
            [timer invalidate];
            timer = nil;
            [self updateSql:pendingid];
        }else if ([self compareOneDay:date2 withAnotherDay:date1]==1){
            NSString *content = [NSString stringWithFormat:@"%@(已过期)",pendingTitle];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"会议提醒" message:content delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alert show];
            [timer invalidate];
            timer = nil;
            [self updateSql:pendingid];
        }
    }
}
-(void)deleteSql:(NSString *)delid{
    //删除表已提醒的
    BOOL isSucceed;
    isSucceed =[self.cpeduDateBase executeUpdate:@"delete from Pending where pendingType= ?",delid];
    if (isSucceed)
    {
        [self.cpeduDateBase commit];
    }
    else
    {
        [self.cpeduDateBase rollback];
    }
}
-(void)updateSql:(NSString *)delid{
    BOOL isSucceed;
    //更新
    isSucceed =[self.cpeduDateBase executeUpdate:@"update Pending set pendingType= ? where id= ?",@"1", delid];
    if (isSucceed){
        [self.cpeduDateBase commit];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }else{
        [self.cpeduDateBase rollback];
    }
}
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"oneDay : %@, anotherDay : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        NSLog(@"oneDay  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //没过指定时间 没过期
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //刚好时间一样.
    //NSLog(@"Both dates are the same");
    return 0;
    
}

@end
