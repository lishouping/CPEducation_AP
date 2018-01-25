//
//  MettingNotpart.m
//  CPEducation_AP
//  不参加会议原因
//  Created by lishouping on 2017/6/26.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "MettingNotpart.h"
#import "MettingDeatileViewController.h"

@interface MettingNotpart ()<UIAlertViewDelegate,UITextViewDelegate>{
    UITextView *inputText;
    UIButton *btnSubmit;
    MBProgressHUD *hud;
}

@end

@implementation MettingNotpart

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"不参加原因";
    // Do any additional setup after loading the view.
    [self makeUI];
}
- (void)makeUI{
    inputText = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kWidth-10-10, kHeight-44-50-20-20)];
    inputText.layer.cornerRadius = 5;
    inputText.layer.masksToBounds = YES;
    inputText.delegate = self;
    UIColor *customColor  = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
    inputText.layer.borderColor = customColor.CGColor;
    inputText.layer.borderWidth = 1.0;
    [self.view addSubview:inputText];
    
    btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(0, kHeight-44-10-50, kWidth, 40)];
    [btnSubmit setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
    [btnSubmit setTitle:@"确定" forState:UIControlStateNormal];
    [btnSubmit setFont:[UIFont systemFontOfSize:15]];
    [btnSubmit addTarget:self action:@selector(btnSubmitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
}

- (void)btnSubmitClick{
    if (inputText.text.length == 0) {
        UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"请填写不参加原因" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [al show];
    }else{
        [self noSignMeeting];
    }
}

- (void)noSignMeeting{
    //开始显示HUD
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    hud.labelText=@"正在登录";（1-不参加 2-参加 3-回复）
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];
    
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"MeetingAttend"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"userid": [userDefaults objectForKey:@"userid_CP"],
                                 @"contentid":self.contentid,
                                 @"type":@"1",
                                 @"reason":inputText.text
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
            //返回到上个页面
            //[self.navigationController popViewControllerAnimated:YES];
            
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            myDelegate.pagerefresh = @"0";
            
            [hud hide:YES afterDelay:0.5];
            
            NSDictionary *dic =responseObject[@"data"];
            
            NSString *time = [dic objectForKey:@"time"];

            UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"不参加原因提交成功" message:time delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            al.delegate = self;
            [al show];
            

            [hud hide:YES afterDelay:0.5];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshstates" object:@1];
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
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder]; return NO;
    }
    return YES; 
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"------");
        [self.navigationController popViewControllerAnimated:NO];
    }
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
