//
//  LinkUrlViewController.m
//  CPEducation_AP
//  公共 链接地址调用
//  Created by lishouping on 17/2/14.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "LinkUrlViewController.h"

@interface LinkUrlViewController ()<UIWebViewDelegate>{
    UIWebView *webview;
    UIView *opaqueView;
    UIActivityIndicatorView *activityIndicatorView;
}

@end

@implementation LinkUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"链接详情";
    [self makeui];
    // Do any additional setup after loading the view.
}

- (void)makeui{
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    [webview setUserInteractionEnabled:YES];//是否支持交互
    //[webView setDelegate:self];
    webview.delegate=self;
    [webview setOpaque:NO];//opaque是不透明的意思
    [webview setScalesPageToFit:YES];//自动缩放以适应屏幕
    [self.view addSubview:webview];
    NSURL *url;
    if([self.linkUrl rangeOfString:@"http://"].location !=NSNotFound)//_roaldSearchText
    {
       url = [NSURL URLWithString:self.linkUrl];
    }
    else
    {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://",self.linkUrl]];
    }
    
    [webview loadRequest:[NSURLRequest requestWithURL:url]];
    
    opaqueView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    [activityIndicatorView setCenter:opaqueView.center];
    [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [opaqueView setBackgroundColor:[UIColor blackColor]];
    [opaqueView setAlpha:0.6];
    [self.view addSubview:opaqueView];
    [opaqueView addSubview:activityIndicatorView];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicatorView startAnimating];
    opaqueView.hidden = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicatorView startAnimating];
    opaqueView.hidden = YES;
}

//UIWebView如何判断 HTTP 404 等错误
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSURL *url = [NSURL URLWithString:self.linkUrl];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ((([httpResponse statusCode]/100) == 2)) {
        // self.earthquakeData = [NSMutableData data];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [ webview loadRequest:[ NSURLRequest requestWithURL: url]];
        webview.delegate = self;
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                  NSLocalizedString(@"HTTP Error",
                                                    @"Error message displayed when receving a connection error.")
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:userInfo];
        
        if ([error code] == 404) {
            NSLog(@"xx");
            webview.hidden = YES;
        }
        
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
