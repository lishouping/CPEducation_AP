//
//  NoticeDeatileViewController.m
//  CPEducation_AP
//  通知详情 文字
//  Created by lishouping on 16/12/22.
//  Copyright © 2016年 李寿平. All rights reserved.
//

#import "NoticeDeatileViewController.h"
#import "AnnexTableViewCell.h"
#import "LinkUrlViewController.h"
static NSString *iscollect = @"0";
@interface NoticeDeatileViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *labNoticeTitle;
    UILabel *labNoticeSubTitle;
    UILabel *labNoticeFrom;
    UILabel *labNoticeCreateTime;
    UIView *contentView;
    UIView *headView;
    UILabel *labNoticeContent;
    UIButton *btnLink;
    UITableView *tableViewAnnex;
    MBProgressHUD *hud;
    NSString *title;
    
    NSString *link_url;
    
    UIButton *rightBtn;
    
}
@property(nonatomic,strong)NSMutableArray *dateArray;
@end

@implementation NoticeDeatileViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通知详情";
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self makeUI];
    [self createUITableView];
      [self loadDate];
    [self createRightBtn];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshsign" object:@1];
    // Do any additional setup after loading the view.
}

- (void)createRightBtn{
    rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *rightBtnItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnButtonClick) forControlEvents:UIControlEventTouchUpInside];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        UIBarButtonItem * negativeSpacer=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width=-15;
        self.navigationItem.rightBarButtonItems=@[negativeSpacer,rightBtnItem];
    }
    else
    {
        self.navigationItem.rightBarButtonItem=rightBtnItem;
    }
}

-(void)rightBtnButtonClick{
    if ([iscollect isEqualToString:@"0"]) {
        [rightBtn setImage:[UIImage imageNamed:@"cp_collected"] forState:UIControlStateNormal];
        [self addCollect];
    }else if ([iscollect isEqualToString:@"1"]){
        [rightBtn setImage:[UIImage imageNamed:@"cp_collected_no"] forState:UIControlStateNormal];
        [self addCollect];
    }
}

// 创建TableView
- (void)createUITableView{
    tableViewAnnex = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    tableViewAnnex.delegate = self;
    tableViewAnnex.dataSource = self;
    
    [self.view addSubview:tableViewAnnex];
    
   tableViewAnnex.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
- (void)makeUI{
    headView= [UIView new];
    [self.view addSubview:headView];
    
    labNoticeTitle = [UILabel new];
    labNoticeTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
     [labNoticeTitle setTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]];
    [headView addSubview:labNoticeTitle];
    [labNoticeTitle zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.leftSpace(10);
        layout.topSpace(10);
        layout.rightSpace(10);
        layout.autoHeight();
    }];

    labNoticeSubTitle = [UILabel new];
    labNoticeSubTitle.font = [UIFont fontWithName:@"Helvetica" size:12];
    [labNoticeSubTitle setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]];
    [headView addSubview:labNoticeSubTitle];
    [labNoticeSubTitle zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(labNoticeTitle,10);
        layout.leftSpace(10);
        layout.rightSpace(10);
        layout.autoHeight();
    }];
    
    UIView *lineView = [UIView new];
    [lineView setBackgroundColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]];
    [headView addSubview:lineView];
    [lineView zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(labNoticeSubTitle,10);
        layout.leftSpace(10);
        layout.rightSpace(10);
        layout.heightValue(0.5);
    }];
    
     labNoticeFrom = [UILabel new];
     [labNoticeFrom setTextColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
     [labNoticeFrom setFont:[UIFont systemFontOfSize:12]];
     [headView addSubview:labNoticeFrom];
     [labNoticeFrom zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
         layout.topSpaceByView(lineView,10);
         layout.leftSpace(10);
         layout.autoHeight();
         layout.widthValue(kWidth/2);
     }];
    
    labNoticeCreateTime = [UILabel new];
    labNoticeCreateTime.textAlignment = UITextAlignmentRight;
    [labNoticeCreateTime setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]];
    [labNoticeCreateTime setFont:[UIFont systemFontOfSize:12]];
    [headView addSubview:labNoticeCreateTime];
    [labNoticeCreateTime zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.rightSpace(10);
        layout.widthValue(kWidth/2);
        layout.topSpaceByView(lineView,10);
    }];
    labNoticeContent = [UILabel new];
    labNoticeContent.font = [UIFont systemFontOfSize:14];
    [labNoticeContent setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]];
    [headView addSubview:labNoticeContent];
    [labNoticeContent zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(labNoticeCreateTime,10);
        layout.leftSpace(10);
        layout.rightSpace(10);
        layout.autoHeight();
    }];
    
    UIView *lineView1 = [UIView new];
    [lineView1 setBackgroundColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]];
    [headView addSubview:lineView1];
    [lineView1 zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(labNoticeContent,10);
        layout.leftSpace(10);
        layout.rightSpace(10);
        layout.heightValue(0.5);
    }];
    
    
    btnLink = [UIButton new];
    [btnLink setTitle:@"原文链接" forState:UIControlStateNormal];
    [btnLink setFont:[UIFont systemFontOfSize:12]];
    [btnLink setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnLink setBackgroundColor:[UIColor whiteColor]];
    [btnLink addTarget:self action:@selector(linkUrlClick) forControlEvents:UIControlEventTouchUpInside];
    btnLink.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [headView addSubview:btnLink];
    [btnLink zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(lineView1,5);
        layout.leftSpace(kWidth-100-10);
        layout.rightSpace(10);
        layout.widthValue(100);
    }];
    

}

-(void)loadDate{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"GetDateDetails"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"userid": [userDefaults objectForKey:@"userid_CP"],
                                 @"contentid":self.contentid
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
            
            NSDictionary *dic =responseObject[@"data"];

            title = [dic objectForKey:@"title"];//主标题
            NSString *subtitle = [dic objectForKey:@"subtitle"];//副标题
            NSString *publishclient = [dic objectForKey:@"publishclient"];//发布设备
            NSString *sendtime = [dic objectForKey:@"sendtime"];// 发布时间
            NSString *video_url = [dic objectForKey:@"video_url"];//视频地址
            link_url = [dic objectForKey:@"link_url"];//链接地址
            NSString *content = [dic objectForKey:@"content"];//正文内容
            NSString *arefavorites = [dic objectForKey:@"arefavorites"];//是否收藏
            if ([arefavorites isEqualToString:@"0"]) {
                iscollect = @"0";
                [rightBtn setImage:[UIImage imageNamed:@"cp_collected_no"] forState:UIControlStateNormal];
            }else{
                iscollect = @"1";
                [rightBtn setImage:[UIImage imageNamed:@"cp_collected"] forState:UIControlStateNormal];
            }
            
            NSArray *imgArray = [dic objectForKey:@"picturelist"];//图片列表
            NSArray *attachmentlist = [dic objectForKey:@"attachmentlist"];//附件列表
            
            [self.dateArray addObjectsFromArray:attachmentlist];
            
            [labNoticeTitle setText:title];
            [labNoticeSubTitle setText:subtitle];
            if ([publishclient isEqualToString:@""]) {
                [labNoticeFrom setText:@"来自 电脑端"];
            }else if ([publishclient isEqualToString:@"null"]){
                [labNoticeFrom setText:@"来自 电脑端"];
            }else{
                [labNoticeFrom setText:publishclient];
            }
            [labNoticeCreateTime setText:sendtime];
            [labNoticeContent setText:content];
            if ([link_url isEqualToString:@""]) {
                btnLink.hidden = YES;
            }
            
            CGSize maximumLabelSize = CGSizeMake(kWidth-10-10, 9999);//labelsize的最大值
            CGSize expectSize = [labNoticeContent sizeThatFits:maximumLabelSize];
            CGSize maximumLabelSize1 = CGSizeMake(kWidth-10-10, 9999);//labelsize的最大值
            CGSize expectSize1 = [labNoticeTitle sizeThatFits:maximumLabelSize1];
            CGSize maximumLabelSize2 = CGSizeMake(kWidth-10-10, 9999);//labelsize的最大值
            CGSize expectSize2 = [labNoticeSubTitle sizeThatFits:maximumLabelSize2];
            CGSize maximumLabelSize3 = CGSizeMake(kWidth-10-10, 9999);//labelsize的最大值
            CGSize expectSize3 = [labNoticeFrom sizeThatFits:maximumLabelSize3];
     
            headView.frame = CGRectMake(0, 0, kWidth, expectSize.height+expectSize1.height+expectSize2.height+expectSize3.height+100);
            tableViewAnnex.tableHeaderView = headView;
            [tableViewAnnex reloadData];
            
            NSString *signstate = [dic objectForKey:@"signstate"];// 签收状态
            
            if ([signstate isEqualToString:@"0"]) {
                
                NSString *signtime = [[dic objectForKey:@"signtime"] substringToIndex:19];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"签收成功" message:[NSString stringWithFormat:@"%@",signtime] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
                [alert show];
            }
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




// 链接点击
-(void)linkUrlClick{
    LinkUrlViewController *lvc = [[LinkUrlViewController alloc] init];
    lvc.linkUrl = link_url;
    [self.navigationController pushViewController:lvc animated:YES];
}

-(void)addCollect{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"AddCollect"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"userid": [userDefaults objectForKey:@"userid_CP"],
                                 @"contentid":self.contentid,
                                 @"collectstate":iscollect
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
        NSString *dic =responseObject[@"message"];
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"1000"]) {
            
           
            if ([dic isEqualToString:@"收藏成功"]) {
                iscollect = @"1";
            }else{
                if ([dic isEqualToString:@"取消收藏成功"]) {
                    iscollect = @"0";
                }
            }
          
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dateArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnexTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"avc"];
    if (cell==nil)
    {
        cell=[[AnnexTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"avc"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.annexName.text = [[self.dateArray objectAtIndex:indexPath.row] objectForKey:@"filename"];
    if ([[[self.dateArray objectAtIndex:indexPath.row] objectForKey:@"filename"] containsString:@"jpg"]) {
        [cell.annexImg setImage:[UIImage imageNamed:@"cp_jpg"]];
    }else if ([[[self.dateArray objectAtIndex:indexPath.row] objectForKey:@"filename"]  containsString:@"png"]){
        [cell.annexImg setImage:[UIImage imageNamed:@"cp_png"]];
    }else if ([[[self.dateArray objectAtIndex:indexPath.row] objectForKey:@"filename"]  containsString:@"gif"]){
        [cell.annexImg setImage:[UIImage imageNamed:@"cp_gif"]];
    }else if ([[[self.dateArray objectAtIndex:indexPath.row] objectForKey:@"filename"]  containsString:@"doc"]){
        [cell.annexImg setImage:[UIImage imageNamed:@"cp_doc"]];
    }else if ([[[self.dateArray objectAtIndex:indexPath.row] objectForKey:@"filename"]  containsString:@"docx"]){
        [cell.annexImg setImage:[UIImage imageNamed:@"cp_docx"]];
    }else if ([[[self.dateArray objectAtIndex:indexPath.row] objectForKey:@"filename"]  containsString:@"xls"]){
        [cell.annexImg setImage:[UIImage imageNamed:@"cp_xls"]];
    }else if ([[[self.dateArray objectAtIndex:indexPath.row] objectForKey:@"filename"]  containsString:@"xlsx"]){
        [cell.annexImg setImage:[UIImage imageNamed:@"cp_xlsx"]];
    }else if ([[[self.dateArray objectAtIndex:indexPath.row] objectForKey:@"filename"] containsString:@"ppt"]){
        [cell.annexImg setImage:[UIImage imageNamed:@"cp_ppt"]];
    }else if ([[[self.dateArray objectAtIndex:indexPath.row] objectForKey:@"filename"] containsString:@"pdf"]){
        [cell.annexImg setImage:[UIImage imageNamed:@"cp_pdf"]];
    }else{
        [cell.annexImg setImage:[UIImage imageNamed:@"cp_other"]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:tableViewAnnex]) {
        NSString *fileurl = [[self.dateArray objectAtIndex:indexPath.row] objectForKey:@"fileurl"];
        NSString *filename = [NSString stringWithFormat:@"/通知-%@%@", title, [[self.dateArray objectAtIndex:indexPath.row] objectForKey:@"filename"]] ;
        [self downAnndx:fileurl :filename];
    }
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 下载文件处理
- (void)downAnndx:(NSString *)loadURl:(NSString *)saveName{
    
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"CPJWFiles"];
    
    //先以通知、会议、信息、调查的uuid创建一个目录。
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",self.contentid]] isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",self.contentid]] withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建文件夹失败！");
        }
        NSLog(@"创建文件夹成功，文件路径%@",path);
    }
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.tag=1000;
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"Downloading...";
    HUD.square = YES;
    [HUD show:YES];
    //初始化队列
    NSOperationQueue *queue = [[NSOperationQueue alloc ]init];
    //下载地址
    NSURL *url = [NSURL URLWithString:loadURl];
    
    //保存路径
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]initWithRequest:[NSURLRequest requestWithURL:url]];
    op.outputStream = [NSOutputStream outputStreamToFileAtPath:[[path stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",self.contentid]] stringByAppendingPathComponent:saveName] append:NO];
    // 根据下载量设置进度条的百分比
    [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        CGFloat precent = (CGFloat)totalBytesRead / totalBytesExpectedToRead;
        HUD.progress = precent;
    }];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        HUD.labelText = @"下载成功";
        [HUD hide:YES afterDelay:0.5];
        //        [HUD removeFromSuperview];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载失败");
        HUD.labelText = @"下载失败";
        [HUD hide:YES afterDelay:0.5];
        //        [HUD removeFromSuperview];
    }];
    //开始下载
    [queue addOperation:op];
    
    
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
