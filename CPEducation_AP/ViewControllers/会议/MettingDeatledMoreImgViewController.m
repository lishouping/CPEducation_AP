//
//  MettingDeatledMoreImgViewController.m
//  CPEducation_AP
//
//  Created by lishouping on 2017/6/26.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "MettingDeatledMoreImgViewController.h"
#import "AnnexTableViewCell.h"
#import "LinkUrlViewController.h"
#import "SDCycleScrollView.h"
#import "MettingNotpart.h"
#import "QRCodeingViewController.h"
static NSString *iscollect = @"0";


@interface MettingDeatledMoreImgViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
{
    UILabel *labNoticeTitle;
    UILabel *labNoticeSubTitle;
    UILabel *labNoticeFrom;
    UILabel *labNoticeCreateTime;
    UIView *headView;
    UILabel *labNoticeContent;
    UIButton *btnLink;
    UITableView *tableViewAnnex;
    MBProgressHUD *hud;
    NSString *title;
    NSString *link_url;
    
    UIView *moreImageView;
    
    UIButton *btnPartic;//参与未参与
    UIButton *btnSign;
    UIButton *btnCanjia;
    UIButton *btnSIgnFinish;
    UIButton *rightBtn;
}
@property(nonatomic,strong)NSMutableArray *dateArray;

@end

@implementation MettingDeatledMoreImgViewController

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
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:@"refreshstates"
                                               object:nil];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if (myDelegate==nil) {
    }else if ([myDelegate.pagerefresh isEqualToString:@"1" ]){
        self.attendstate = @"3";
        [self getAttendState];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"会议详情";
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self loadDate];
    [self createUITableView];
    // Do any additional setup after loading the view.
    [self createFootView];
    [self createRightBtn];
    
     [self getAttendState];

    // Do any additional setup after loading the view.
}
- (void)loginStateChange:(NSNotification *)notification
{
    NSString *loginSuccess = [notification.object stringValue];
    if ([loginSuccess isEqualToString:@"1"]) {
        self.attendstate = @"1";
        [self getAttendState];
    }
    
    
    
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

- (void)createFootView{
    UIView *fooview = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight-40-44-20, kWidth, 40)];
    [fooview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:fooview];
    
    btnPartic = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWidth/2-1, 40)];
    [btnPartic setTitle:@"不参加" forState:UIControlStateNormal];
    [btnPartic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnPartic setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
    [fooview addSubview:btnPartic];
    [btnPartic addTarget:self action:@selector(particClick) forControlEvents:UIControlEventTouchUpInside];
    
    btnCanjia = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/2+1, 0, kWidth/2-1, 40)];
    [btnCanjia setTitle:@"参加" forState:UIControlStateNormal];
    [btnCanjia setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCanjia setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
    [btnCanjia addTarget:self action:@selector(btnCanjiaClick) forControlEvents:UIControlEventTouchUpInside];
    [fooview addSubview:btnCanjia];
    
    btnSign = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/2+1, 0, kWidth/2-1, 40)];
    [btnSign setTitle:@"签到" forState:UIControlStateNormal];
    [btnSign setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSign setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
    [fooview addSubview:btnSign];
    [btnSign addTarget:self action:@selector(btnSignClick) forControlEvents:UIControlEventTouchUpInside];
    
    btnSIgnFinish = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    [btnSIgnFinish setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
    [btnSIgnFinish setTitle:@"已签到" forState:UIControlStateNormal];
    [btnSIgnFinish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fooview addSubview:btnSIgnFinish];
    [btnSIgnFinish addTarget:self action:@selector(btnHadSign) forControlEvents:UIControlEventTouchUpInside];
    btnSIgnFinish.hidden = YES;
    
}

-(void)getAttendState{
    //参与状态(0-待参加 1-不参加 2-已参加 3-已签到)
    if ([self.attendstate isEqualToString:@"0"]) {
        [btnPartic setTitle:@"不参加" forState:UIControlStateNormal];
        btnSign.hidden = YES;
    }else if ([self.attendstate isEqualToString:@"1"]){
        [btnPartic setTitle:@"不参加" forState:UIControlStateNormal];
        [btnPartic setBackgroundColor:[UIColor grayColor]];
        [btnPartic setEnabled:NO];
        btnCanjia.hidden = NO;
        btnSign.hidden = YES;
    }else if ([self.attendstate isEqualToString:@"2"]){
        [btnPartic setTitle:@"不参加" forState:UIControlStateNormal];
        [btnPartic setEnabled:YES];
        [btnPartic setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
        btnSign.hidden = NO;
        btnCanjia.hidden = YES;
    }else{
        btnSIgnFinish.hidden = NO;
    }
}
// 不参加
-(void)particClick{
    if ([self.attendstate isEqualToString:@"0"]||[self.attendstate isEqualToString:@"2"]) {
        MettingNotpart *part = [[MettingNotpart alloc] init];
        part.contentid = self.contentid;
        [self.navigationController pushViewController:part animated:YES];
    }
    
}
// 签到
-(void)btnSignClick{
    [self btnQianDaoClick];
}
//参加
-(void)btnCanjiaClick{
    [self AttendMeeting:@"2"];
}
// 签到点击事件
-(void)btnQianDaoClick{
    QRCodeingViewController *qrcov = [[QRCodeingViewController alloc] init];
    qrcov.contentid = self.contentid;
    [self.navigationController pushViewController:qrcov animated:YES];
}
// 已签到
-(void)btnHadSign{
    [self meetingSign];
}

// 创建TableView
- (void)createUITableView{
    tableViewAnnex = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-44-20) style:UITableViewStylePlain];
    tableViewAnnex.delegate = self;
    tableViewAnnex.dataSource = self;
    [self.view addSubview:tableViewAnnex];
    
    tableViewAnnex.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}


-(void)loadDate{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"GetDateDetails"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"userid": [userDefaults objectForKey:@"userid_CP"],
                                 @"contentid":self.contentid,
                                 @"type":@"1"
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
            
            NSString *signstate = [dic objectForKey:@"signstate"];// 签收状态
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
            NSArray *imgArray = [dic objectForKey:@"picturelist"];//图片列
            NSMutableArray *mcv = [[NSMutableArray alloc] initWithCapacity:0];
            NSMutableArray *titvc = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary * dic in imgArray)
            {
                NSString *picture = [dic objectForKey:@"picture"];
                NSString *caption = [dic objectForKey:@"caption"];
                [mcv addObject:picture];
                [titvc addObject:caption];
            }
            NSArray *imagesURLStrings = [mcv copy];
            NSArray *titles = [titvc copy];
            

            NSArray *attachmentlist = [dic objectForKey:@"attachmentlist"];//附件列表
            
            [self.dateArray addObjectsFromArray:attachmentlist];
            
            
            
            headView = [[UIView alloc] init];
            labNoticeTitle = [[UILabel alloc] init];
            labNoticeTitle.font = [UIFont systemFontOfSize:16];
            [labNoticeTitle setText:title];
            labNoticeTitle.numberOfLines = 0;//根据最大行数需求来设置
            labNoticeTitle.lineBreakMode = NSLineBreakByTruncatingTail;
            [labNoticeTitle setTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1]];
            CGSize maximumLabelSize = CGSizeMake(kWidth-10-10, 9999);//labelsize的最大值
            //关键语句
            CGSize expectSize = [labNoticeTitle sizeThatFits:maximumLabelSize];
            //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
            labNoticeTitle.frame = CGRectMake(10, 10, kWidth-10-10, expectSize.height);
            [headView addSubview:labNoticeTitle];
            
            
            labNoticeSubTitle = [[UILabel alloc] init];
            labNoticeSubTitle.font = [UIFont systemFontOfSize:14];
            [labNoticeSubTitle setText:subtitle];
            [labNoticeSubTitle setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]];
            labNoticeSubTitle.numberOfLines = 0;//根据最大行数需求来设置
            labNoticeSubTitle.lineBreakMode = NSLineBreakByTruncatingTail;
            CGSize maximumLabelSize1 = CGSizeMake(kWidth-10-10, 9999);//labelsize的最大值
            //关键语句
            CGSize expectSize1 = [labNoticeTitle sizeThatFits:maximumLabelSize1];
            //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
            labNoticeSubTitle.frame = CGRectMake(10, expectSize.height+10, kWidth-10-10, expectSize1.height);
            [headView addSubview:labNoticeSubTitle];
            
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, expectSize.height+expectSize1.height+10, kWidth-10-10, 0.5)];
            [lineView setBackgroundColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]];
            [headView addSubview:lineView];
            
            
            
            labNoticeFrom = [[UILabel alloc] initWithFrame:CGRectMake(10, expectSize.height+expectSize1.height+10+10, kWidth/2, 20)];
            [labNoticeFrom setText:@"来自 电脑端"];
            [labNoticeFrom setTextColor:[UIColor colorWithRed:0.0/255.0 green:137.0/255.0 blue:230.0/255.0 alpha:1]];
            [labNoticeFrom setFont:[UIFont systemFontOfSize:12]];
            [headView addSubview:labNoticeFrom];
            if ([publishclient isEqualToString:@""]) {
                [labNoticeFrom setText:@"来自 电脑端"];
            }else if ([publishclient isEqualToString:@"null"]){
                [labNoticeFrom setText:@"来自 电脑端"];
            }
            else{
                [labNoticeFrom setText:publishclient];
            }
            
            labNoticeCreateTime = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2, expectSize.height+expectSize1.height+10+10, kWidth/2-10, 20)];
            [labNoticeCreateTime setText:sendtime];
            labNoticeCreateTime.textAlignment = UITextAlignmentRight;
            [labNoticeCreateTime setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]];
            [labNoticeCreateTime setFont:[UIFont systemFontOfSize:12]];
            [headView addSubview:labNoticeCreateTime];
            
            moreImageView = [[UIView alloc] initWithFrame:CGRectMake(10, expectSize.height+expectSize1.height+10+10+30, kWidth-10-10, 180)];
            //[moreImageView setBackgroundColor:[UIColor grayColor]];

 
            SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth-10-10, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
            cycleScrollView2.titlesGroup = titles;
            cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
            [moreImageView addSubview:cycleScrollView2];
            
            //         --- 模拟加载延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
            });
            cycleScrollView2.autoScroll = false;
            
            
            [headView addSubview:moreImageView];
            
            
            
            
            
            labNoticeContent = [[UILabel alloc] init];
            labNoticeContent.font = [UIFont systemFontOfSize:14];
            [labNoticeContent setText:content];
            [labNoticeContent setTextColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]];
            labNoticeContent.numberOfLines = 0;//根据最大行数需求来设置
            labNoticeContent.lineBreakMode = NSLineBreakByTruncatingTail;
            CGSize maximumLabelSize2 = CGSizeMake(kWidth-10-10, 9999);//labelsize的最大值
            CGSize expectSize2 = [labNoticeContent sizeThatFits:maximumLabelSize2];
            labNoticeContent.frame = CGRectMake(10, expectSize.height+expectSize1.height+180+60, kWidth-10-10, expectSize2.height);
            [headView addSubview:labNoticeContent];
            
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10,expectSize.height+expectSize2.height+expectSize1.height+10+10+180+50, kWidth-10-10, 0.5)];
            [lineView1 setBackgroundColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]];
            [headView addSubview:lineView1];
            
            btnLink = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-100, expectSize.height+expectSize2.height+expectSize1.height+10+10+180+60, 100, 15)];
            [btnLink setTitle:@"原文链接" forState:UIControlStateNormal];
            [btnLink setFont:[UIFont systemFontOfSize:12]];
            [btnLink setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [btnLink setBackgroundColor:[UIColor whiteColor]];
            [btnLink addTarget:self action:@selector(linkUrlClick) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:btnLink];
            if ([link_url isEqualToString:@""]) {
                btnLink.hidden = YES;
            }
            
            
            headView.frame = CGRectMake(0, 0, kWidth-10-10, expectSize.height+expectSize1.height+10+10+expectSize2.height+60+200);
            [self.view addSubview:headView];
            
            tableViewAnnex.tableHeaderView = headView;
            [tableViewAnnex reloadData];
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
        NSString *filename = [NSString stringWithFormat:@"/会议-%@%@", title, [[self.dateArray objectAtIndex:indexPath.row] objectForKey:@"filename"]] ;
        
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

// 会议参加不参加接口
- (void)AttendMeeting:(NSString *) attend{
    //开始显示HUD
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //    hud.labelText=@"正在登录";（1-不参加 2-参加 3-回复）
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];
    
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"MeetingAttend"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"userid": [userDefaults objectForKey:@"userid_CP"],
                                 @"contentid":self.contentid,
                                 @"type":attend,
                                 @"reason":@""
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
            [hud hide:YES afterDelay:0.5];
            
            NSDictionary *dic =responseObject[@"data"];
            
            NSString *time = [dic objectForKey:@"time"];
            
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            myDelegate.pagerefresh = @"2";
            
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"参加会议申请提交成功" message:time delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            al.delegate = self;
            [al show];
            self.attendstate = @"2";
            [self getAttendState];
            [hud hide:YES afterDelay:0.5];
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
// 会议已签到
- (void)meetingSign{
    //开始显示HUD
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];
    
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"MeetingSign"];
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
            //返回到上个页面
            //[self.navigationController popViewControllerAnimated:YES];
            [hud hide:YES afterDelay:0.5];
            
            NSDictionary *dic =responseObject[@"data"];
            
            NSString *time = [dic objectForKey:@"time"];
            
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:@"签到时间" message:time delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            al.delegate = self;
            [al show];
            
            [hud hide:YES afterDelay:0.5];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"------");
        
    }
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
