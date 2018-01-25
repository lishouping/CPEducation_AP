//
//  QRCodeingViewController.m
//  CPEducation_AP
//  二维码绑定
//  Created by lishouping on 2017/6/26.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "QRCodeingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeAreaView.h"
#import "QRCodeBacgrouView.h"
#import "UIViewExt.h"

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
@interface QRCodeingViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureSession * session;//输入输出的中间桥梁
    QRCodeAreaView *_areaView;//扫描区域视图
    NSString *mcontentid;
}
@end

@implementation QRCodeingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"二维码扫描";
    // Do any additional setup after loading the view.
    //扫描区域
    CGRect areaRect = CGRectMake((screen_width - 218)/2, (screen_height - 218)/2, 218, 218);
    
    //半透明背景
    QRCodeBacgrouView *bacgrouView = [[QRCodeBacgrouView alloc]initWithFrame:self.view.bounds];
    bacgrouView.scanFrame = areaRect;
    [self.view addSubview:bacgrouView];
    
    //设置扫描区域
    _areaView = [[QRCodeAreaView alloc]initWithFrame:areaRect];
    [self.view addSubview:_areaView];
    
    //提示文字
    UILabel *label = [UILabel new];
    label.text = @"将二维码放入框内，即开始扫描";
    label.textColor = [UIColor whiteColor];
    label.y = CGRectGetMaxY(_areaView.frame) + 20;
    [label sizeToFit];
    label.center = CGPointMake(_areaView.center.x, label.center.y);
    [self.view addSubview:label];
    
    /**
     *  初始化二维码扫描
     */
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置识别区域
    //深坑，这个值是按比例0~1设置，而且X、Y要调换位置，width、height调换位置
    output.rectOfInterest = CGRectMake(_areaView.y/screen_height, _areaView.x/screen_width, _areaView.height/screen_height, _areaView.width/screen_width);
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //开始捕获
    [session startRunning];
}

#pragma 二维码扫描的回调
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [session stopRunning];//停止扫描
        //[_areaView stopAnimaion];//暂停动画
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
        
        mcontentid = metadataObject.stringValue;
        
        if ([self.contentid isEqualToString:mcontentid]) {
            [self getMeetingSign];
        }else if ([self.contentid isEqualToString:@"-199"]){
            self.contentid = mcontentid;
            [self getMeetingSign];
        }else{
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"提示!" message:@"您扫描的二维码不属于本会议" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            al.delegate = self;
            [al show];
        }
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}
- (void)getMeetingSign{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"MeetingSign"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];

    NSDictionary *parameters = @{@"userid": [userDefaults objectForKey:@"userid_CP"],
                                 @"contentid": self.contentid
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
            //会议签到成功
            NSDictionary *dic =responseObject[@"data"];
            
            NSString *time = [dic objectForKey:@"time"];
            
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"会议签到成功" message:time delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            al.delegate = self;
            [al show];
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            if ([self.contentid isEqualToString:@"-199"]) {
                 myDelegate.pagerefresh = @"3";
            }else{
                 myDelegate.pagerefresh = @"1";
            }
           
            
            
        }else if ([[responseObject objectForKey:@"code"] isEqualToString:@"1006"]){
            //您已签到过该会议
            NSDictionary *dic =responseObject[@"data"];
            
            NSString *time = [dic objectForKey:@"time"];
            
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"您已签到过该会议" message:time delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            al.delegate = self;
            [al show];

        }else if ([[responseObject objectForKey:@"code"] isEqualToString:@"1007"]){
            //您还未参加会议
            NSDictionary *dic =responseObject[@"data"];
            
            NSString *time = [dic objectForKey:@"time"];
            
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"您还未参加会议" message:time delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            al.delegate = self;
            [al show];

        }else if ([[responseObject objectForKey:@"code"] isEqualToString:@"1008"]){
            //您已不参加此会议
            NSDictionary *dic =responseObject[@"data"];
            
            NSString *time = [dic objectForKey:@"time"];
            
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"您已不参加此会议" message:time delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            al.delegate = self;
            [al show];

        }else if ([[responseObject objectForKey:@"code"] isEqualToString:@"1009"]){
            //此会议已经结束签到失败
            NSDictionary *dic =responseObject[@"data"];
            
            NSString *time = [dic objectForKey:@"time"];
            
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"此会议已经结束签到失败" message:time delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            al.delegate = self;
            [al show];

        }else if ([[responseObject objectForKey:@"code"] isEqualToString:@"1010"]){
            //此会议不存在
            NSDictionary *dic =responseObject[@"data"];
            
            NSString *time = [dic objectForKey:@"time"];
            
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"此会议不存在" message:time delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            al.delegate = self;
            [al show];

        }else if ([[responseObject objectForKey:@"code"] isEqualToString:@"1011"]){
            //此会议已撤回签到失败
            NSDictionary *dic =responseObject[@"data"];
            
            NSString *time = [dic objectForKey:@"time"];
            
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"此会议已撤回签到失败" message:time delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            al.delegate = self;
            [al show];

        }else if ([[responseObject objectForKey:@"code"] isEqualToString:@"1012"]){
            //此会议已销毁签到失败
            NSDictionary *dic =responseObject[@"data"];
            
            NSString *time = [dic objectForKey:@"time"];
            
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"此会议已销毁签到失败" message:time delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            al.delegate = self;
            [al show];

        }else if ([[responseObject objectForKey:@"code"] isEqualToString:@"1013"]){
            //此会议已删除签到失败
            NSDictionary *dic =responseObject[@"data"];
            
            NSString *time = [dic objectForKey:@"time"];
            
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"此会议已删除签到失败" message:time delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            al.delegate = self;
            [al show];

        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
            [alert show];
            
            
        }
         [self.navigationController popViewControllerAnimated:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
}


@end
