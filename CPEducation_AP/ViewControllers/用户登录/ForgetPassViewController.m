//
//  ForgetPassViewController.m
//  CPEducation_AP
//
//  Created by lishouping on 16/12/22.
//  Copyright © 2016年 李寿平. All rights reserved.
//

#import "ForgetPassViewController.h"
static NSInteger isstop = 1;
@interface ForgetPassViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    UILabel *labtitle1;
    UILabel *labphone;
    UITextField *tfphone;
    UILabel *labvcode;
    UITextField *tfvcode;
    UIButton *btnSendCode;
    UILabel *labtitle2;
    UILabel *labnewpass;
    UITextField *tfnewpass;
    UILabel *labsubnewpass;
    UITextField *tfsubnewpass;
    UIButton *btnSubmit;
     MBProgressHUD *hud;
}
@end

@implementation ForgetPassViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO]; // 隐藏导航栏
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1];
    [self.navigationController.navigationBar  setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    //    [self.navigationItem setHidesBackButton:YES];   // 隐藏返回按钮
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"忘记密码";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self makeUI];
    // Do any additional setup after loading the view.
}
- (void)makeUI{
    labtitle1 = [UILabel new];
    [self.view addSubview:labtitle1];
    [labtitle1 zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(5);
        layout.topSpace(5);
        layout.autoHeight();
        layout.autoWidth();
    }];
    [labtitle1 setText:@"第一步，手机验证。请保持您的手机畅通！"];
    labtitle1.textColor = [UIColor grayColor];
    labtitle1.font = [UIFont systemFontOfSize:13];
    
    labphone = [UILabel new];
    [self.view addSubview:labphone];
    [labphone zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(5);
        layout.topSpaceByView(labtitle1, 10);
        layout.heightValue(30);
        layout.widthValue(70);
    }];
    [labphone setText:@"手机号"];
    labphone.textColor = [UIColor grayColor];
    labphone.font = [UIFont systemFontOfSize:14];
    
    tfphone = [UITextField new];
    [self.view addSubview:tfphone];
    [tfphone zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpaceByView(labphone, 5);
        layout.topSpaceByView(labtitle1, 10);
        layout.rightSpace(5);
        layout.heightValue(30);
        layout.widthValue(kWidth-5-70);
    }];
    tfphone.layer.cornerRadius = 10;
    tfphone.layer.masksToBounds = YES;
    tfphone.layer.borderWidth = 0.5;
    tfphone.placeholder = @"请输入手机号";
    tfphone.delegate = self;
    tfphone.layer.borderColor = [[UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1] CGColor];
    tfphone.textColor = [UIColor grayColor];
    tfphone.font = [UIFont systemFontOfSize:14];
    
    
    labvcode = [UILabel new];
    [self.view addSubview:labvcode];
    [labvcode zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(5);
        layout.topSpaceByView(labphone, 10);
        layout.heightValue(30);
        layout.widthValue(70);
    }];
    [labvcode setText:@"验证码"];
    labvcode.textColor = [UIColor grayColor];
    labvcode.font = [UIFont systemFontOfSize:14];
    
    tfvcode = [UITextField new];
    [self.view addSubview:tfvcode];
    [tfvcode zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpaceByView(labvcode, 5);
        layout.topSpaceByView(tfphone,10);
        layout.rightSpace(5);
        layout.heightValue(30);
        layout.widthValue(kWidth-5-70);
    }];
    tfvcode.layer.cornerRadius = 10;
    tfvcode.layer.masksToBounds = YES;
    tfvcode.layer.borderWidth = 0.5;
    tfvcode.delegate = self;
    tfvcode.placeholder = @"请输入验证码";
    tfvcode.layer.borderColor = [[UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1] CGColor];
    tfvcode.textColor = [UIColor grayColor];
    tfvcode.font = [UIFont systemFontOfSize:14];
    [tfvcode addTarget:self action:@selector(codeClick) forControlEvents:(UIControlEventEditingDidBegin)];
    
    btnSendCode = [UIButton new];
    [self.view addSubview:btnSendCode];
    [btnSendCode setTitle:@"发送" forState:(UIControlStateNormal)];
    btnSendCode.layer.cornerRadius = 10;
    [btnSendCode addTarget:self action:@selector(btnSendVcode) forControlEvents:(UIControlEventTouchUpInside)];
    [btnSendCode setBackgroundColor:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1]];
     [btnSendCode zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(5);
        layout.rightSpace(5);
        layout.heightValue(30);
        layout.widthValue(kWidth-5-5);
         layout.topSpaceByView(tfvcode, 10);
    }];
    
    
    
    
    
    labtitle2 = [UILabel new];
    [self.view addSubview:labtitle2];
    [labtitle2 zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(5);
        layout.topSpaceByView(btnSendCode, 30);
        layout.autoHeight();
        layout.autoWidth();
    }];
    [labtitle2 setText:@"第二步，修改登录密码。"];
    labtitle2.textColor = [UIColor grayColor];
    labtitle2.font = [UIFont systemFontOfSize:13];
    
    labnewpass = [UILabel new];
    [self.view addSubview:labnewpass];
    [labnewpass zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(5);
        layout.topSpaceByView(labtitle2, 10);
        layout.heightValue(30);
        layout.widthValue(70);
    }];
    [labnewpass setText:@"新密码"];
    labnewpass.textColor = [UIColor grayColor];
    labnewpass.font = [UIFont systemFontOfSize:14];

    tfnewpass = [UITextField new];
    [self.view addSubview:tfnewpass];
    [tfnewpass zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpaceByView(labnewpass, 5);
        layout.topSpaceByView(labtitle2, 10);
        layout.rightSpace(5);
        layout.heightValue(30);
        layout.widthValue(kWidth-5-70);
    }];
    tfnewpass.layer.cornerRadius = 10;
    tfnewpass.layer.masksToBounds = YES;
    tfnewpass.layer.borderWidth = 0.5;
    tfnewpass.placeholder = @"请输入6-8位密码";
    tfnewpass.delegate = self;
      tfnewpass.secureTextEntry = YES;
    tfnewpass.layer.borderColor = [[UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1] CGColor];
    tfnewpass.textColor = [UIColor grayColor];
    tfnewpass.font = [UIFont systemFontOfSize:14];


    labsubnewpass = [UILabel new];
    [self.view addSubview:labsubnewpass];
    [labsubnewpass zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(5);
        layout.topSpaceByView(tfnewpass, 10);
        layout.heightValue(30);
        layout.widthValue(70);
    }];
    [labsubnewpass setText:@"确认密码"];
    labsubnewpass.textColor = [UIColor grayColor];
    labsubnewpass.font = [UIFont systemFontOfSize:14];

    tfsubnewpass = [UITextField new];
    [self.view addSubview:tfsubnewpass];
    [tfsubnewpass zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpaceByView(labsubnewpass, 5);
        layout.topSpaceByView(tfnewpass,10);
        layout.rightSpace(5);
        layout.heightValue(30);
        layout.widthValue(kWidth-5-70);
    }];
    
    tfsubnewpass.layer.cornerRadius = 10;
    tfsubnewpass.layer.masksToBounds = YES;
    tfsubnewpass.layer.borderWidth = 0.5;
    tfsubnewpass.placeholder = @"请输入6-8位密码";
    tfsubnewpass.delegate = self;
    tfsubnewpass.layer.borderColor = [[UIColor colorWithRed:181.0/255.0 green:181.0/255.0 blue:181.0/255.0 alpha:1] CGColor];
    tfsubnewpass.secureTextEntry = YES;
    tfsubnewpass.textColor = [UIColor grayColor];
    tfsubnewpass.font = [UIFont systemFontOfSize:14];

    btnSubmit = [UIButton new];
    [self.view addSubview:btnSubmit];
    [btnSubmit setTitle:@"确定" forState:(UIControlStateNormal)];
    btnSubmit.layer.cornerRadius = 10;
    [btnSubmit addTarget:self action:@selector(btnSubmit) forControlEvents:(UIControlEventTouchUpInside)];
    [btnSubmit setBackgroundColor:[UIColor grayColor]];
    btnSubmit.userInteractionEnabled = NO;
    [btnSubmit zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(5);
        layout.rightSpace(5);
        layout.heightValue(30);
        layout.widthValue(kWidth-5-5);
        layout.topSpaceByView(tfsubnewpass, 10);
    }];
    
    
}

- (void)codeClick{
    isstop = 0;
    [btnSendCode setBackgroundColor:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1]];
    btnSendCode.userInteractionEnabled = YES;
}
- (void)btnSendVcode{
    if (tfvcode.text.length==0) {
        if (tfphone.text.length == 0) {
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [al show];
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",@"确定要发送验证码？"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
            alert.delegate = self;
            [alert show];
        }
    }else{
         [self verifyCode];
        
    }
    
}

- (void)btnSubmit{
    if (tfnewpass.text.length==0) {
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"新密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
    }else if (tfnewpass.text.length<6||tfnewpass.text.length>18){
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"新密码不合法" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
    }else if (tfsubnewpass.text.length==0){
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"确认密码不合法" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
    }else if (tfsubnewpass.text.length<6||tfsubnewpass.text.length>18){
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"确认密码不合法" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
    }else if (![tfnewpass.text isEqualToString:tfsubnewpass.text]){
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"两次密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
    }else{
        [self updatePassWord];
    }
}
// 发送验证码请求
-(void)sendCode{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"ServerSendCode"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"telephone": tfphone.text
                                 };
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
            [self openCountdown];
        }
        
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
            [alert show];
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}
// 验证验证码
-(void)verifyCode{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"VerifyCode"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"telephone": tfphone.text,
                                 @"code":tfvcode.text
                                 };
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
            NSData *jsonData = [[responseObject objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
            NSString *userid = [dic objectForKey:@"userid"];
            NSString *name = [dic objectForKey:@"name"];
            NSString *telephone = [dic objectForKey:@"telephone"];
            NSString *sex = [dic objectForKey:@"sex"];
            NSString *birthday = [dic objectForKey:@"birthday"];
            
            [userDefaults setObject:@"true" forKey:@"islogin_CP"];
            [userDefaults setObject:userid forKey:@"userid_CP"];
            [userDefaults setObject:name forKey:@"name_CP"];
            [userDefaults setObject:sex forKey:@"sex_CP"];
            [userDefaults setObject:telephone forKey:@"telephone_CP"];
            [userDefaults setObject:birthday forKey:@"birthday_CP"];
            
            

            isstop = 0;
            [btnSendCode setBackgroundColor:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1]];
            btnSendCode.userInteractionEnabled = YES;
            [btnSendCode setTitle:@"通过" forState:UIControlStateNormal];

            btnSubmit.userInteractionEnabled = YES;
           [btnSubmit setBackgroundColor:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1]];
        }
        
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
            [alert show];
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}

// 请求修改密码
-(void)updatePassWord{
    //开始显示HUD
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"修改中";
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];
    
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"ChangePassword"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"telephone": tfphone.text,
                                 @"newpassword":tfnewpass.text
                                 };
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
             [hud hide:YES afterDelay:0.5];
             hud.labelText=@"修改成功";
             [self.navigationController popViewControllerAnimated:NO];
        }
        
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
            [alert show];
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}


#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tfphone resignFirstResponder];
    [tfvcode resignFirstResponder];
    [tfsubnewpass resignFirstResponder];
    [tfnewpass resignFirstResponder];
    return YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:@"发送"]) {
        [self sendCode];
        //[self openCountdown];
    }
}


// 开启倒计时效果
-(void)openCountdown{
    __block NSInteger time = 60; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
         if (isstop==0) {
              time = 0;
         }
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
               
                if (isstop==0) {
                     [btnSendCode setTitle:@"通过" forState:UIControlStateNormal];
                 
                }else{
                     [btnSendCode setTitle:@"重新发送" forState:UIControlStateNormal];
                }
                [btnSendCode setBackgroundColor:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1]];
                btnSendCode.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [btnSendCode setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [btnSendCode setBackgroundColor:[UIColor grayColor]];
                btnSendCode.userInteractionEnabled = NO;
                
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
