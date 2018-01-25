//
//  LoginViewController.m
//  CPEducation_AP
//
//  Created by lishouping on 16/12/22.
//  Copyright © 2016年 李寿平. All rights reserved.
//

#import "LoginViewController.h"
#import "JPUSHService.h"
#import "ForgetPassViewController.h"
static Boolean islogin = false;
#import "PendingModel.h"
#import "CpeduDateBase.h"
@interface LoginViewController ()<UITextFieldDelegate>{
    UITextField *tfuserName;
    UITextField *tfpassWord;
    UIButton *btnLogin;
    UIButton *btnForgetPass;
    UIButton *btnCheckRemPass;
     MBProgressHUD *hud;
    
    NSTimer *timer;
    CpeduDateBase *cpeduDateBase;
    
}

@end

@implementation LoginViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES]; // 隐藏导航栏
    //    [self.navigationItem setHidesBackButton:YES];   // 隐藏返回按钮
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    [self chekLogin];
    [self initFile];
    [self createLocalDB];
    // Do any additional setup after loading the view.
}
// 创建数据库
-(void)createLocalDB{
    cpeduDateBase=[CpeduDateBase shareInstance];
    
    [self deleteSql:@"1"];
     //[self setPending];
}


// 初始化文件夹
- (void)initFile{
    NSString *savePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"CPJWFiles"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:savePath isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建文件夹失败！");
        }
        NSLog(@"创建文件夹成功，文件路径%@",savePath);
    }

}
- (void)chekLogin{
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *islogin_CP = [userDefaults objectForKey:@"islogin_CP"];
    NSString *userName_CP = [userDefaults objectForKey:@"userName_CP"];
    NSString *passWord_CP = [userDefaults objectForKey:@"passWord_CP"];
    if ([islogin_CP isEqualToString:@"true"]) {
        tfuserName.text = userName_CP;
        tfpassWord.text = passWord_CP;
        islogin =true;
        [btnCheckRemPass setImage:[UIImage imageNamed:@"cp_password_press"] forState:UIControlStateNormal];
    }else{
        tfuserName.text = userName_CP;
        tfpassWord.text = passWord_CP;
        islogin = false;
        [btnCheckRemPass setImage:[UIImage imageNamed:@"cp_password_not_press"] forState:UIControlStateNormal];
    }
}

- (void)makeUI{
    UIImageView *imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    [imgBg setImage:[UIImage imageNamed:@"icbackound"]];
    [self.view addSubview:imgBg];
    
    UIView *backgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kHeight, kHeight)];
    [self.view addSubview:backgView];
    
    UIImageView *titleImg = [[UIImageView alloc] initWithFrame:CGRectMake((kWidth/2)-(158/2), 100, 158, 45)];
    [titleImg setImage:[UIImage imageNamed:@"ic_title"]];
    //[titleImg setImage:[self imageWithLogoText:[UIImage imageNamed:@"ic_title"] text:@"接收人"]];
    [backgView addSubview:titleImg];
    
    UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake(30, 100+45+30, 22, 18.5)];
    [userImg setImage:[UIImage imageNamed:@"icuser"]];
    [backgView addSubview:userImg];
    
    tfuserName = [[UITextField alloc] initWithFrame:CGRectMake(30+18.5+10, 100+45+25, kWidth-(30+18.5+5+30), 30)];
    tfuserName.placeholder = @"请输入您的登录账户";
    tfuserName.delegate = self;
    [tfuserName setTextColor:[UIColor whiteColor]];
    tfuserName.font = [UIFont systemFontOfSize:13];
    [backgView addSubview:tfuserName];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(30, 100+45+25+32, kWidth-30-30, 1)];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    [backgView addSubview:lineView];
    
    
    UIImageView *passImg = [[UIImageView alloc] initWithFrame:CGRectMake(30, 100+45+30+50, 22, 18.5)];
    [passImg setImage:[UIImage imageNamed:@"icpass"]];
    [backgView addSubview:passImg];
    
    tfpassWord = [[UITextField alloc] initWithFrame:CGRectMake(30+18.5+10, 100+45+30+45, kWidth-(30+18.5+5+30), 30)];
    tfpassWord.placeholder = @"请输入您的登录密码";
    tfpassWord.delegate = self;
     tfpassWord.secureTextEntry = YES;
    [tfpassWord setTextColor:[UIColor whiteColor]];
    tfpassWord.font = [UIFont systemFontOfSize:13];
    [backgView addSubview:tfpassWord];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(30, 100+45+30+45+2+30, kWidth-30-30, 1)];
    [lineView1 setBackgroundColor:[UIColor whiteColor]];
    [backgView addSubview:lineView1];
    
    
    btnLogin = [[UIButton alloc] initWithFrame:CGRectMake(30, 100+45+30+45+2+30+30, kWidth-30-30, 30)];
    [btnLogin setBackgroundColor:[UIColor colorWithRed:67.0/255.0 green:136.0/255.0 blue:253.0/255.0 alpha:1]];
    btnLogin.layer.cornerRadius = 3.0;
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLogin setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btnLogin addTarget:self action:@selector(LoginClick) forControlEvents:UIControlEventTouchUpInside];
    [backgView addSubview:btnLogin];
  
    
    
    
    btnForgetPass = [[UIButton alloc] initWithFrame:CGRectMake(30, 100+45+30+45+2+30+30+30+15, 60, 20)];
    [btnForgetPass setTitle:@"忘记密码?" forState:UIControlStateNormal];
    btnForgetPass.font = [UIFont systemFontOfSize:12];
    [btnForgetPass setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backgView addSubview:btnForgetPass];
    [btnForgetPass addTarget:self action:@selector(forgetPassChick) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    
    btnCheckRemPass = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-30-20-50, 100+45+30+45+2+30+30+30+15, 20, 20)];
    [btnCheckRemPass setImage:[UIImage imageNamed:@"cp_password_not_press"] forState:UIControlStateNormal];
    [backgView addSubview:btnCheckRemPass];
    [btnCheckRemPass addTarget:self action:@selector(checkboxClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel *labCheckPass = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-60-20, 100+45+30+45+2+30+30+30+15, 60, 20)];
    [labCheckPass setFont:[UIFont systemFontOfSize:12]];
    [labCheckPass setText:@"记住密码"];
    [labCheckPass setTextColor:[UIColor whiteColor]];
    [backgView addSubview:labCheckPass];
}

-(void)checkboxClick{
    
    if(islogin){
        [btnCheckRemPass setImage:[UIImage imageNamed:@"cp_password_not_press"] forState:UIControlStateNormal];
        islogin = false;
    }else{
        //在此实现打勾时的方法
        [btnCheckRemPass setImage:[UIImage imageNamed:@"cp_password_press"] forState:UIControlStateNormal];
        islogin = true;
        
    }
}
// 忘记密码
-(void)forgetPassChick{
    ForgetPassViewController *forv = [[ForgetPassViewController alloc] init];
    [self.navigationController pushViewController:forv animated:YES];
}
-(void)LoginClick{
    if (tfuserName.text.length == 0) {
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"请输入用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
    }else if (tfpassWord.text.length == 0){
        UIAlertView *alv = [[UIAlertView alloc] initWithTitle:nil message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alv show];
    }else{
        //开始显示HUD
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.labelText=@"正在登录";
        hud.minSize = CGSizeMake(100.f, 100.f);
        hud.color=[UIColor blackColor];
        
        NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"UserLogin"];
        NSDictionary *parameters = @{@"username": tfuserName.text,
                                     @"password": tfpassWord.text};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        [manager POST:postUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"结果: %@", responseObject);
            if ([[responseObject objectForKey:@"code"] isEqualToString:@"1000"]) {
                //返回到上个页面
                //[self.navigationController popViewControllerAnimated:YES];
                [hud hide:YES afterDelay:0.5];
                

                NSData *jsonData = [[responseObject objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                
                NSString *name = [dic objectForKey:@"name"];
                NSString *sex = [dic objectForKey:@"sex"];
                NSString *telephone = [dic objectForKey:@"telephone"];
                NSString *birthday = [dic objectForKey:@"birthday"];
                NSString *userid = [dic objectForKey:@"userid"];
                
                
                AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
                myDelegate.isLogin = @"1";
                
                if (islogin) {
                    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:tfuserName.text forKey:@"userName_CP"];
                    [userDefaults setObject:tfpassWord.text forKey:@"passWord_CP"];
                    [userDefaults setObject:@"true" forKey:@"islogin_CP"];
                    [userDefaults setObject:userid forKey:@"userid_CP"];
                    [userDefaults setObject:name forKey:@"name_CP"];
                    [userDefaults setObject:sex forKey:@"sex_CP"];
                    [userDefaults setObject:telephone forKey:@"telephone_CP"];
                    [userDefaults setObject:birthday forKey:@"birthday_CP"];
                    
                }else{
                    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:@"" forKey:@"userName_CP"];
                    [userDefaults setObject:@"" forKey:@"passWord_CP"];
                    [userDefaults setObject:@"" forKey:@"islogin_CP"];
                    [userDefaults setObject:userid forKey:@"userid_CP"];
                    [userDefaults setObject:name forKey:@"name_CP"];
                    [userDefaults setObject:sex forKey:@"sex_CP"];
                    [userDefaults setObject:telephone forKey:@"telephone_CP"];
                    [userDefaults setObject:birthday forKey:@"birthday_CP"];
                    
                }
                [JPUSHService setAlias:telephone callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];

                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAction) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginState" object:@YES];
            }
            
            else
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
                [alert show];
                [hud hide:YES afterDelay:0.5];
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            hud.labelText = @"网络连接异常";
            [hud hide:YES afterDelay:0.5];
            NSLog(@"Error: ==============%@", error);
        }];
        

    }
}
-(void)updateAction{
   [self selectSql];
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
-(void)selectSql{
    // 查询表
    //从数据库中读数据
    FMResultSet * set = [cpeduDateBase executeQuery:@"select * from Pending where pendingType= ?",@"0"];
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


-(void)deleteSql:(NSString *)delid{
    //删除表已提醒的
    BOOL isSucceed;
    isSucceed =[cpeduDateBase executeUpdate:@"delete from Pending where pendingType= ?",delid];
    if (isSucceed)
    {
        [cpeduDateBase commit];
    }
    else
    {
        [cpeduDateBase rollback];
    }
}
-(void)updateSql:(NSString *)delid{
    BOOL isSucceed;
    //更新
    isSucceed =[cpeduDateBase executeUpdate:@"update Pending set pendingType= ? where id= ?",@"1", delid];
    if (isSucceed){
        [cpeduDateBase commit];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }else{
        [cpeduDateBase rollback];
    }
}


#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tfuserName resignFirstResponder];
    [tfpassWord resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIImage *)imageWithLogoText:(UIImage *)img text:(NSString *)text1
{
    /////注：此为后来更改，用于显示中文。zyq,2013-5-8
    CGSize size = CGSizeMake(200, img.size.height);          //设置上下文（画布）大小
    UIGraphicsBeginImageContext(size);                       //创建一个基于位图的上下文(context)，并将其设置为当前上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext(); //获取当前上下文
    CGContextTranslateCTM(contextRef, 0, img.size.height);   //画布的高度
    CGContextScaleCTM(contextRef, 1.0, -1.0);                //画布翻转
    CGContextDrawImage(contextRef, CGRectMake(0, 0, img.size.width, img.size.height), [img CGImage]);  //在上下文种画当前图片
    
    [[UIColor redColor] set];                                //上下文种的文字属性
    CGContextTranslateCTM(contextRef, 0, img.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    [text1 drawInRect:CGRectMake(0, 0, 200, 80) withFont:font];       //此处设置文字显示的位置
    UIImage *targetimg =UIGraphicsGetImageFromCurrentImageContext();  //从当前上下文种获取图片
    UIGraphicsEndImageContext();                            //移除栈顶的基于当前位图的图形上下文。
    return targetimg;
    
    
    //注：此为原来，不能显示中文。无用。
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
    char* text = (char *)[text1 cStringUsingEncoding:NSUnicodeStringEncoding];
    CGContextSelectFont(context, "Georgia", 30, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 255, 0, 0, 1);
    CGContextShowTextAtPoint(context, w/2-strlen(text)*5, h/2, text, strlen(text));
    //Create image ref from the context
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
