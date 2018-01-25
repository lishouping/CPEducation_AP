//
//  MineViewController.m
//  CPEducation_AP
//  我的
//  Created by lishouping on 16/12/22.
//  Copyright © 2016年 李寿平. All rights reserved.
//

#import "MineViewController.h"
#import "YFViewPager.h"
#import "AnnexModel.h"
#import "GFCalendarView.h"
#import "MineAnnexTableViewCell.h"
#import "SurveyQuestionModel.h"
#import "TixingModel.h"
#import "TixingFrModel.h"
#import "PendingTableViewCell.h"

#import "NoticeFootView.h"
#import "MettingFootView.h"
#import "SurveyFootView.h"
#import "InforFootView.h"
#import "NoticeKeyWordsTableViewCell.h"
#import "NoticeImageUpTableViewCell.h"
#import "NoticeImageDownTableViewCell.h"
#import "NoticeVideoTableViewCell.h"
#import "NoticeMoreImageTableViewCell.h"

#import "JPUSHService.h"
#import "MettingKeyWordsTableViewCell.h"
#import "MettingImageUpTableViewCell.h"
#import "MettingImageDownTableViewCell.h"
#import "MettingVideoTableViewCell.h"
#import "MettingMoreImageTableViewCell.h"

#import "SurveyKeyWordsTableViewCell.h"
#import "SurveyImageUpTableViewCell.h"
#import "SurveyImageDownTableViewCell.h"
#import "SurveyVideoTableViewCell.h"
#import "SurveyMoreImageTableViewCell.h"

#import "InforKeyWordsTableViewCell.h"
#import "InforImageUpTableViewCell.h"
#import "InforImageDownTableViewCell.h"
#import "InforVideoTableViewCell.h"
#import "InforMoreImageTableViewCell.h"

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


#import "MeetingReplyListViewController.h"

#import "LoginViewController.h"

static NSString *favoriteid;
static NSString *contentid;

static NSString *collnumber;
static NSString *pendingnumber;
static NSString *annexnubmer;
static NSInteger anndxselect;

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate,UIAlertViewDelegate>{
    YFViewPager *yfViewPager;
    
    // 不同的View布局
    UIView *collectionView;
    UIView *needWithView;
    UIView *annexView;
    
    UITableView *tableviewColl;
    
    UITableView *tabviewDaiBan;
    
    UITableView *tabviewAnnex;
     MBProgressHUD *hud;
    
    
}
@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property(nonatomic,strong)NSMutableArray *dateArray;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;//使用第三方应用打开文件
@property (nonatomic,strong)NSMutableArray *daibanArray;
@property (nonatomic,strong)NSMutableArray *daiBanArr;
@property (nonatomic,strong)NSMutableArray *collectDateArray;
@property (nonatomic,strong)NSMutableArray *dateArrayNumer;
@end

@implementation MineViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self loadCollDate];
    [self loadingDate];
    [self doFiles];
    [self getnumber];
    
    [super viewWillAppear:animated];
    //    [self.navigationItem setHidesBackButton:YES];   // 隐藏返回按钮
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.daibanArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.daiBanArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.collectDateArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.dateArrayNumer = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self makeUI];
    [self createRightBtn];
    // Do any additional setup after loading the view.
}

- (void)createRightBtn{
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"cp_logout"] forState:UIControlStateNormal];
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

- (void)makeUI{
    collectionView = [[UIView alloc] init];
    collectionView.backgroundColor = [UIColor grayColor];
    needWithView = [[UIView alloc] init];
    
    CGFloat width = self.view.bounds.size.width - 20.0;
    CGPoint origin = CGPointMake(10.0,10);
    
    GFCalendarView *mcal = [[GFCalendarView alloc] initWithFrameOrigin:origin width:width];
    
    // 点击某一天的回调
    mcal.didSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day) {
        
        
        
        
        NSString *str =  [NSString stringWithFormat:@"%ld-%ld-%ld", year, month, day];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:str];
        NSString *currentDateString = [dateFormatter stringFromDate:date];
        
        
        [self.daiBanArr removeAllObjects];
        [self getPendingList:currentDateString];
        
        NSLog(@"%@", currentDateString);

        
    };
    
//    tableviewColl = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-44-40-20) style:UITableViewStyleGrouped];
//    tableviewColl.delegate = self;
//    tableviewColl.dataSource = self;
//    [collectionView addSubview:tableviewColl];
    
    
    tabviewDaiBan = [[UITableView alloc] initWithFrame:CGRectMake(0, width-5, kWidth, kHeight-width-100) style:UITableViewStylePlain];
    tabviewDaiBan.delegate = self;
    tabviewDaiBan.dataSource = self;
    tabviewDaiBan.separatorStyle = UITableViewCellSeparatorStyleNone;
    [needWithView addSubview:tabviewDaiBan];
    [needWithView addSubview:mcal];
    
    
    
    
    annexView = [[UIView alloc] init];
    tabviewAnnex = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-40) style:UITableViewStylePlain];
    tabviewAnnex.delegate = self;
    tabviewAnnex.dataSource = self;
    [annexView addSubview:tabviewAnnex];
    
    
    
    
    NSArray *titles = [[NSArray alloc] initWithObjects:
                       @" 收藏",
                       @" 待办",
                       @" 附件", nil];
    NSArray *icons = [[NSArray alloc] initWithObjects:
                      [UIImage imageNamed:@"cp_collected_mine"],
                      [UIImage imageNamed:@"cp_pending_mine"],
                      [UIImage imageNamed:@"cp_annex_mine"], nil];
    
    NSArray *views = [[NSArray alloc] initWithObjects:
                      collectionView,
                      needWithView,
                      annexView, nil];
    
    yfViewPager = [[YFViewPager alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 20)
                                             titles:titles
                                              icons:icons
                                      selectedIcons:icons
                                              views:views];
    [self.view addSubview:yfViewPager];
    
   
    
    yfViewPager.enabledScroll = false;
    if ([self.selectpos isEqualToString:@"1"]) {
        yfViewPager.selectIndex = 1;
    }
   
    
    // 点击菜单时触发
    [yfViewPager didSelectedBlock:^(id viewPager, NSInteger index) {
        switch (index) {
            case 0:     // 点击第一个菜单
            {
                 self.navigationItem.title = @"我的收藏";
                [self loadCollDate];
            }
                break;
            case 1:     // 点击第二个菜单
            {
                 self.navigationItem.title = @"我的待办";
                
                [self loadingDate];
            }
                break;
            case 2:     // 点击第三个菜单
            {
                 self.navigationItem.title = @"我的附件";
                [self.dateArray removeAllObjects];
                [self doFiles];
            }
                break;
                
            default:
                break;
        }
    }];
    
}
//退出
- (void)rightBtnButtonClick{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",@"确定要注销登录吗？"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注销", nil];
    [alert show];
 
}

- (void)loadingDate{
    if (self.daibanArray.count>0) {
        [self.daibanArray removeAllObjects];
        [self.daiBanArr removeAllObjects];
    }
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"GetPendingList"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"userid": [userDefaults objectForKey:@"userid_CP"],
                                 @"date": @""
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
            
            
            NSString *totalnumber = [responseObject objectForKey:@"totalnumber"];
            
            
            NSDictionary *dicb = [responseObject objectForKey:@"data"];
            
            NSArray *dateArray = [dicb objectForKey:@"pendinglist"];
            
            
            
            
            for (NSDictionary * dic in dateArray)
            {
                TixingFrModel *tixingmodel = [[TixingFrModel alloc] init];
                
                NSString *date = [dic objectForKey:@"date"];
                tixingmodel.date = date;
                NSArray *pendingArray = [dic objectForKey:@"list"];
                tixingmodel.array = pendingArray;
                [self.daibanArray addObject:tixingmodel];
                
            }
            [self getPendingList:@"-1"];
            [tabviewDaiBan reloadData];
        }
        
        else
        {

            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
    
}

// 整合待办列表上的数据

- (void)getPendingList:(NSString *)selDate{
    for (int i=0; i<self.daibanArray.count; i++) {
        TixingFrModel *model = self.daibanArray[i];
        NSString *ndate = model.date;
        
        NSDate *date = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        
        [formatter setDateFormat:@"YYYY-MM-dd"];
        
        NSString *DateTime;
        
        if ([selDate isEqualToString:@"-1"]) {
            DateTime = [formatter stringFromDate:date];
        }else{
            DateTime = selDate;
        }
        
        

        if ([ndate isEqualToString:DateTime]) {
            NSArray *dicarray = model.array;
            for (NSDictionary * dic in dicarray) {
                TixingModel *mo = [[TixingModel alloc] init];
                mo.content = [dic objectForKey:@"content"];
                mo.time = [dic objectForKey:@"time"];
                mo.title = [dic objectForKey:@"title"];
                [self.daiBanArr addObject:mo];
            }
            NSString *collnum = [NSString stringWithFormat:@"%ld",self.daiBanArr.count];
        }
    }
    [tabviewDaiBan reloadData];
}






// 文件处理方法
- (void)doFiles{
    NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/CPJWFiles"];
    NSLog(@"%@",docsDir);

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
//
   // NSArray *subs=[fileManager subpathsAtPath:docsDir];
    
    NSError *errDir = nil;
    NSArray *subs = [fileManager contentsOfDirectoryAtPath:docsDir error:&errDir];
    
    for (int j=0; j<subs.count; j++) {
        BOOL isDir;
        [fileManager fileExistsAtPath:[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",[subs objectAtIndex:j]]] isDirectory:&isDir];
        if (isDir) {
            NSLog(@"这是个****文件夹****");
            NSArray *subs1=[fileManager subpathsAtPath:[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",[subs objectAtIndex:j]]]];
            for (int i=0; i<subs1.count; i++) {
                AnnexModel *model = [[AnnexModel alloc] init];
                NSString *subName = [NSString stringWithFormat:@"%@",[subs1 objectAtIndex:i]];
                model.fileName = subName;
                NSString *path = [NSString stringWithFormat:@"%@/%@/%@",docsDir,[subs objectAtIndex:j],[subs1 objectAtIndex:i]];
                model.filePath = path;
                [self.dateArray addObject:model];
            }
           
        }else{
            NSLog(@"这是个****文件**** ");
        }
    
       
       
    }
     [tabviewAnnex reloadData];

   
}

- (void)loadCollDate{
    tableviewColl = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-44-40-20) style:UITableViewStyleGrouped];
    tableviewColl.delegate = self;
    tableviewColl.dataSource = self;
    [collectionView addSubview:tableviewColl];
    

    [self.collectDateArray removeAllObjects];
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"GetCollectList"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"userid": [userDefaults objectForKey:@"userid_CP"]
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
            
            NSArray *dateArray = [responseObject objectForKey:@"data"];
            for (NSDictionary * dic in dateArray)
            {
                NoticeModelArray *model = [NoticeModelArray new];
                model.favoriteid = [dic objectForKey:@"favoriteid"];
                model.contenttype =[dic objectForKey:@"contenttype"];
                model.templates = [dic objectForKey:@"template"];
                model.contentid = [dic objectForKey:@"contentid"];
                model.title = [dic objectForKey:@"title"];
                model.content = [dic objectForKey:@"content"];
                model.signstate = [dic objectForKey:@"signstate"];
                model.mark = [dic objectForKey:@"mark"];
                model.readLine = [dic objectForKey:@"readLine"];
                model.sendtime = [dic objectForKey:@"sendtime"];
                model.readnumber = [dic objectForKey:@"readnumber"];
                model.signnumber = [dic objectForKey:@"signnumber"];
                model.attendstate = [dic objectForKey:@"attendstate"];
                model.attendnumber  = [dic objectForKey:@"attendnumber"];
                model.picturelist = [dic objectForKey:@"picturelist"];
                model.messagenumber = [dic objectForKey:@"messagenumber"];
                if ([[dic objectForKey:@"contenttype"] isEqualToString:@"2"]) {
                    model.surveystate = [dic objectForKey:@"surveystate"];
                }
                if ([[dic objectForKey:@"contenttype"] isEqualToString:@"2"]) {
                    model.surveynumber = [dic objectForKey:@"surveynumber"];
                }
                [self.collectDateArray  addObject:model];
            }
            [tableviewColl reloadData];
        }
        
        else
        {
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual:tabviewDaiBan]) {
        return self.daiBanArr.count;
    }else if ([tableView isEqual:tableviewColl]){
        return self.collectDateArray.count;
    }
    else{
        return self.dateArray.count;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:tabviewDaiBan]) {
        return 40;
    }else if ([tableView isEqual:tableviewColl]){
       return [tableView zxp_cellHeightWithindexPath:indexPath space:10];
    }
    else{
        return 40;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([tableView isEqual:tableviewColl]) {
        return 30.0;
    }else{
        return 0;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:tabviewDaiBan]) {
        PendingTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"di"];
        if (cell1==nil) {
            cell1 = [[PendingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"di"];
        }
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        TixingModel *mo = self.daiBanArr[indexPath.section];
        cell1.labTitle.text = mo.title;
        cell1.labTime.text = [mo.time substringFromIndex:10];
        return cell1;
    }else if ([tableView isEqual:tableviewColl]){
        NoticeModelArray *model1 = self.collectDateArray[indexPath.section];
        if ([model1.contenttype isEqualToString:@"0"]) {
            NoticeKeyWordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
            if (cell==nil) {
                cell = [[NoticeKeyWordsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            NoticeImageUpTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"idc1"];
            if (cell1==nil) {
                cell1 = [[NoticeImageUpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc1"];
            }
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NoticeImageDownTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"idc2"];
            if (cell2==nil) {
                cell2 = [[NoticeImageDownTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc2"];
            }
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NoticeVideoTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"idc3"];
            if (cell3==nil) {
                cell3 = [[NoticeVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc3"];
            }
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            NoticeMoreImageTableViewCell *cell4 = [tableView dequeueReusableCellWithIdentifier:@"idc4"];
            if (cell4==nil) {
                cell4 = [[NoticeMoreImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc4"];
            }
            cell4.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NoticeModelArray *model1 =  self.collectDateArray[indexPath.section];
            
            if ([model1.templates isEqualToString:@"0"]) {
                [cell setModel:model1];
                return cell;
            }else if ([model1.templates isEqualToString:@"1"]){
                [cell1 setModel:model1];
                return cell1;
            }else if ([model1.templates isEqualToString:@"2"]){
                [cell2 setModel:model1];
                return cell2;
            }else if ([model1.templates isEqualToString:@"3"]){
                [cell4 setModel:model1];
                return cell4;
            }else{
                // 视频
                [cell3 setModel:model1];
                return cell3;
            }
        }else if ([model1.contenttype isEqualToString:@"1"]){
            MettingKeyWordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
            if (cell==nil) {
                cell = [[MettingKeyWordsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            MettingImageUpTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"idc1"];
            if (cell1==nil) {
                cell1 = [[MettingImageUpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc1"];
            }
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            MettingImageDownTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"idc2"];
            if (cell2==nil) {
                cell2 = [[MettingImageDownTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc2"];
            }
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            
            MettingVideoTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"idc3"];
            if (cell3==nil) {
                cell3 = [[MettingVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc3"];
            }
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            MettingMoreImageTableViewCell *cell4 = [tableView dequeueReusableCellWithIdentifier:@"idc4"];
            if (cell4==nil) {
                cell4 = [[MettingMoreImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc4"];
            }
            cell4.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NoticeModelArray *model1 =  self.collectDateArray[indexPath.section];
            if ([model1.templates isEqualToString:@"0"]||[model1.contenttype isEqualToString:@"1"]) {
                [cell setModel:model1];
                cell.mettingRepNumView.tag = indexPath.section;
                [cell.mettingRepNumView addTarget:self action:@selector(replayListClick:) forControlEvents:UIControlEventTouchUpInside];
              
                return cell;
            }
            else if ([model1.templates isEqualToString:@"1"]||[model1.contenttype isEqualToString:@"1"]){
                [cell1 setModel:model1];
                cell1.mettingRepNumView.tag = indexPath.section;
                [cell1.mettingRepNumView addTarget:self action:@selector(replayListClick:) forControlEvents:UIControlEventTouchUpInside];
                return cell1;
            }else if ([model1.templates isEqualToString:@"2"]||[model1.contenttype isEqualToString:@"1"]){
                [cell2 setModel:model1];
                cell2.mettingRepNumView.tag = indexPath.section;
                [cell2.mettingRepNumView addTarget:self action:@selector(replayListClick:) forControlEvents:UIControlEventTouchUpInside];
                return cell2;
            }else if ([model1.templates isEqualToString:@"3"]||[model1.contenttype isEqualToString:@"1"]){
                [cell4 setModel:model1];
                cell4.mettingRepNumView.tag = indexPath.section;
                [cell4.mettingRepNumView addTarget:self action:@selector(replayListClick:) forControlEvents:UIControlEventTouchUpInside];
                return cell4;
            }else{
                // 视频
                [cell3 setModel:model1];
                cell3.mettingRepNumView.tag = indexPath.section;
                [cell3.mettingRepNumView addTarget:self action:@selector(replayListClick:) forControlEvents:UIControlEventTouchUpInside];
                return cell3;
            }
        }else if ([model1.contenttype isEqualToString:@"2"]){
            SurveyKeyWordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
            if (cell==nil) {
                cell = [[SurveyKeyWordsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            SurveyImageUpTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"idc1"];
            if (cell1==nil) {
                cell1 = [[SurveyImageUpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc1"];
            }
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            SurveyImageDownTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"idc2"];
            if (cell2==nil) {
                cell2 = [[SurveyImageDownTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc2"];
            }
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            
            SurveyVideoTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"idc3"];
            if (cell3==nil) {
                cell3 = [[SurveyVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc3"];
            }
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            SurveyMoreImageTableViewCell *cell4 = [tableView dequeueReusableCellWithIdentifier:@"idc4"];
            if (cell4==nil) {
                cell4 = [[SurveyMoreImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc4"];
            }
            cell4.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NoticeModelArray *model1 =  self.collectDateArray[indexPath.section];
            
            if ([model1.templates isEqualToString:@"0"]) {
                [cell setModel:model1];
                return cell;
            }else if ([model1.templates isEqualToString:@"1"]){
                [cell1 setModel:model1];
                return cell1;
            }else if ([model1.templates isEqualToString:@"2"]){
                [cell2 setModel:model1];
                return cell2;
            }else if ([model1.templates isEqualToString:@"3"]){
                [cell4 setModel:model1];
                return cell4;
            }else{
                // 视频
                [cell3 setModel:model1];
                return cell3;
            }
        }else if ([model1.contenttype isEqualToString:@"3"]){
            InforKeyWordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
            if (cell==nil) {
                cell = [[InforKeyWordsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            InforImageUpTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"idc1"];
            if (cell1==nil) {
                cell1 = [[InforImageUpTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc1"];
            }
            cell1.selectionStyle = UITableViewCellSelectionStyleNone;
            
            InforImageDownTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"idc2"];
            if (cell2==nil) {
                cell2 = [[InforImageDownTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc2"];
            }
            cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            
            InforVideoTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"idc3"];
            if (cell3==nil) {
                cell3 = [[InforVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc3"];
            }
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            InforMoreImageTableViewCell *cell4 = [tableView dequeueReusableCellWithIdentifier:@"idc4"];
            if (cell4==nil) {
                cell4 = [[InforMoreImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc4"];
            }
            cell4.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NoticeModelArray *model1 =  self.collectDateArray[indexPath.section];
            
            if ([model1.templates isEqualToString:@"0"]) {
                [cell setModel:model1];
                return cell;
            }else if ([model1.templates isEqualToString:@"1"]){
                [cell1 setModel:model1];
                return cell1;
            }else if ([model1.templates isEqualToString:@"2"]){
                [cell2 setModel:model1];
                return cell2;
            }else if ([model1.templates isEqualToString:@"3"]){
                [cell4 setModel:model1];
                return cell4;
            }else{
                // 视频
                [cell3 setModel:model1];
                return cell3;
            }
        }

    }
    else{
        MineAnnexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
        if (cell==nil) {
            cell = [[MineAnnexTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        AnnexModel *model = self.dateArray[indexPath.section];
        cell.annexName.text = model.fileName;
        NSString *fname = [NSString stringWithFormat:@"%@",model.fileName];
        if ([fname containsString:@"jpg"]) {
            [cell.annexImg setImage:[UIImage imageNamed:@"cp_jpg"]];
        }else if ([fname containsString:@"png"]){
            [cell.annexImg setImage:[UIImage imageNamed:@"cp_png"]];
        }else if ([fname containsString:@"gif"]){
            [cell.annexImg setImage:[UIImage imageNamed:@"cp_gif"]];
        }else if ([fname containsString:@"doc"]){
            [cell.annexImg setImage:[UIImage imageNamed:@"cp_doc"]];
        }else if ([fname containsString:@"docx"]){
            [cell.annexImg setImage:[UIImage imageNamed:@"cp_docx"]];
        }else if ([fname containsString:@"xls"]){
            [cell.annexImg setImage:[UIImage imageNamed:@"cp_xls"]];
        }else if ([fname containsString:@"xlsx"]){
            [cell.annexImg setImage:[UIImage imageNamed:@"cp_xlsx"]];
        }else if ([fname containsString:@"ppt"]){
            [cell.annexImg setImage:[UIImage imageNamed:@"cp_ppt"]];
        }else if ([fname containsString:@"pdf"]){
            [cell.annexImg setImage:[UIImage imageNamed:@"cp_pdf"]];
        }else{
            [cell.annexImg setImage:[UIImage imageNamed:@"cp_other"]];
        }
        
//        [cell.annexDelete addTarget:self action:@selector(deleteAnnexClick:) forControlEvents:UIControlEventTouchUpInside];
//        cell.annexDelete.tag = indexPath.row;
        return cell;
    }
    
    return nil;
}
-(void)deleteAnnexClick:(UIButton *) srt{
    AnnexModel *model = self.dateArray[srt.tag];
    NSString *documentsPath = [NSString stringWithFormat:@"%@",model.filePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
     BOOL res=[fileManager removeItemAtPath:documentsPath error:nil];
    if (res) {
        NSLog(@"删除成功");
        [self.dateArray removeAllObjects];
        [self doFiles];
        [self getnumber];
    }
    
    NSLog(@"%@",model.filePath);
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:tabviewAnnex]) {
        AnnexModel *model = self.dateArray[indexPath.section];
        
        NSURL *url = [NSURL fileURLWithPath:model.filePath];
        
        [self setupDocumentControllerWithURL:url];
        [self.documentController presentOptionsMenuFromRect:CGRectMake(0, 20, 1500, 40) inView:self.view  animated:YES];
    }else if ([tableView isEqual:tableviewColl]){
        NoticeModelArray *model1 = self.collectDateArray[indexPath.section];
        if ([model1.contenttype isEqualToString:@"0"]) {
            ////模板id 0-全文字 1-图上文下 2-图下文上 3-多图 4-视频
            NoticeModelArray *model1 =  self.collectDateArray[indexPath.section];
            if ([model1.templates isEqualToString:@"0"]) {
                NoticeDeatileViewController *ndvc = [[NoticeDeatileViewController alloc] init];
                ndvc.contentid = model1.contentid;
                [self.navigationController pushViewController:ndvc animated:YES];
            }else if ([model1.templates isEqualToString:@"1"]){
                NoticeDetailedImageUpViewController *ndvc = [[NoticeDetailedImageUpViewController alloc] init];
                ndvc.contentid = model1.contentid;
                [self.navigationController pushViewController:ndvc animated:YES];
            }else if ([model1.templates isEqualToString:@"2"]){
                NoticeDetaledImageDownViewController *ndvc = [[NoticeDetaledImageDownViewController alloc] init];
                ndvc.contentid = model1.contentid;
                [self.navigationController pushViewController:ndvc animated:YES];
            }else if ([model1.templates isEqualToString:@"3"]){
                NoticeDeatledMoreImgViewController *ndvc = [[NoticeDeatledMoreImgViewController alloc] init];
                ndvc.contentid = model1.contentid;
                [self.navigationController pushViewController:ndvc animated:YES];
            }else if ([model1.templates isEqualToString:@"4"]){
                NoticeDetaledViedoViewController *ndvc = [[NoticeDetaledViedoViewController alloc] init];
                ndvc.contentid = model1.contentid;
                [self.navigationController pushViewController:ndvc animated:YES];
            }
            
            
            if ([model1.signstate isEqualToString:@"0"]) {
                model1.signstate = @"1";
                
                NSInteger sinu = [[NSString stringWithFormat:@"%@",model1.signnumber] integerValue]+1;
                NSString *newsignmub = [NSString stringWithFormat:@"%ld",sinu];
                model1.signnumber = newsignmub;
            }
            
            NSInteger readnum = [[NSString stringWithFormat:@"%@",model1.readnumber] integerValue]+1;
            NSString *newreadnum = [NSString stringWithFormat:@"%ld",readnum];
            model1.readnumber = newreadnum;
            
            
//            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
//            [tableviewColl reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationFade];
//            [tableviewColl reloadData];
        }else if ([model1.contenttype isEqualToString:@"1"]){
            NoticeModelArray *model1 =  self.collectDateArray[indexPath.section];
            
            if ([model1.templates isEqualToString:@"0"]) {
                MettingDeatileViewController *ndvc = [[MettingDeatileViewController alloc] init];
                ndvc.contentid = model1.contentid;
                ndvc.attendstate = model1.attendstate;
                [self.navigationController pushViewController:ndvc animated:YES];
            }else if ([model1.templates isEqualToString:@"1"]){
                MettingDetailedImageUpViewController *ndvc = [[MettingDetailedImageUpViewController alloc] init];
                ndvc.contentid = model1.contentid;
                ndvc.attendstate = model1.attendstate;
                [self.navigationController pushViewController:ndvc animated:YES];
            }else if ([model1.templates isEqualToString:@"2"]){
                MeetingDetaledImageDownViewController *ndvc = [[MeetingDetaledImageDownViewController alloc] init];
                ndvc.contentid = model1.contentid;
                ndvc.attendstate = model1.attendstate;
                [self.navigationController pushViewController:ndvc animated:YES];
            }else if ([model1.templates isEqualToString:@"3"]){
                MettingDeatledMoreImgViewController *ndvc = [[MettingDeatledMoreImgViewController alloc] init];
                ndvc.contentid = model1.contentid;
                ndvc.attendstate = model1.attendstate;
                [self.navigationController pushViewController:ndvc animated:YES];
            }else if ([model1.templates isEqualToString:@"4"]){
                MettingDetaledViedoViewController *ndvc = [[MettingDetaledViedoViewController alloc] init];
                ndvc.contentid = model1.contentid;
                ndvc.attendstate = model1.attendstate;
                [self.navigationController pushViewController:ndvc animated:YES];
            }
            
            
            
            NSInteger readnum = [[NSString stringWithFormat:@"%@",model1.readnumber] integerValue]+1;
            NSString *newreadnum = [NSString stringWithFormat:@"%ld",readnum];
            model1.readnumber = newreadnum;
            
            
//            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
//            [tableviewColl reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationFade];
//            [tableviewColl reloadData];
        }else if ([model1.contenttype isEqualToString:@"2"]){
            NoticeModelArray *model1 =  self.collectDateArray[indexPath.section];
            if ([model1.templates isEqualToString:@"0"]) {
                InvestigDeatileViewController *ndvc = [[InvestigDeatileViewController alloc] init];
                ndvc.contentid = model1.contentid;
                [self.navigationController pushViewController:ndvc animated:YES];
            }else if ([model1.templates isEqualToString:@"1"]){
                InvestigDetailedImageUpViewController *ndvc = [[InvestigDetailedImageUpViewController alloc] init];
                ndvc.contentid = model1.contentid;
                [self.navigationController pushViewController:ndvc animated:YES];
            }else if ([model1.templates isEqualToString:@"2"]){
                InvestigDetaledImageDownViewController *ndvc = [[InvestigDetaledImageDownViewController alloc] init];
                ndvc.contentid = model1.contentid;
                [self.navigationController pushViewController:ndvc animated:YES];
            }else if ([model1.templates isEqualToString:@"3"]){
                InvestigDeatledMoreImgViewController *ndvc = [[InvestigDeatledMoreImgViewController alloc] init];
                ndvc.contentid = model1.contentid;
                [self.navigationController pushViewController:ndvc animated:YES];
            }else if ([model1.templates isEqualToString:@"4"]){
                InvestigDetaledViedoViewController *ndvc = [[InvestigDetaledViedoViewController alloc] init];
                ndvc.contentid = model1.contentid;
                [self.navigationController pushViewController:ndvc animated:YES];
            }
            
            
            if ([model1.signstate isEqualToString:@"0"]) {
                model1.signstate = @"1";
                
                NSInteger sinu = [[NSString stringWithFormat:@"%@",model1.signnumber] integerValue]+1;
                NSString *newsignmub = [NSString stringWithFormat:@"%ld",sinu];
                model1.signnumber = newsignmub;
            }
            
            NSInteger readnum = [[NSString stringWithFormat:@"%@",model1.readnumber] integerValue]+1;
            NSString *newreadnum = [NSString stringWithFormat:@"%ld",readnum];
            model1.readnumber = newreadnum;
            
            
//            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
//            [tableviewColl reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationFade];
//            [tableviewColl reloadData];
        }else if ([model1.contenttype isEqualToString:@"3"]){
            NoticeModelArray *model1 =  self.collectDateArray[indexPath.section];
            if ([model1.templates isEqualToString:@"0"]) {
                InfoDetailedViewController *ndvc = [[InfoDetailedViewController alloc] init];
                ndvc.contentid = model1.contentid;
                [self.navigationController pushViewController:ndvc animated:YES];
            }else if ([model1.templates isEqualToString:@"1"]){
                InfoDetailedImageUpViewController *ndvc = [[InfoDetailedImageUpViewController alloc] init];
                ndvc.contentid = model1.contentid;
                [self.navigationController pushViewController:ndvc animated:YES];
            }else if ([model1.templates isEqualToString:@"2"]){
                InfoDetaledImageDownViewController *ndvc = [[InfoDetaledImageDownViewController alloc] init];
                ndvc.contentid = model1.contentid;
                [self.navigationController pushViewController:ndvc animated:YES];
            }else if ([model1.templates isEqualToString:@"3"]){
                InfoDeatledMoreImgViewController *ndvc = [[InfoDeatledMoreImgViewController alloc] init];
                ndvc.contentid = model1.contentid;
                [self.navigationController pushViewController:ndvc animated:YES];
            }else if ([model1.templates isEqualToString:@"4"]){
                InfoDetaledViedoViewController *ndvc = [[InfoDetaledViedoViewController alloc] init];
                ndvc.contentid = model1.contentid;
                [self.navigationController pushViewController:ndvc animated:YES];
            }
            
            
            if ([model1.signstate isEqualToString:@"0"]) {
                model1.signstate = @"1";
                
                NSInteger sinu = [[NSString stringWithFormat:@"%@",model1.signnumber] integerValue]+1;
                NSString *newsignmub = [NSString stringWithFormat:@"%ld",sinu];
                model1.signnumber = newsignmub;
            }
            
            NSInteger readnum = [[NSString stringWithFormat:@"%@",model1.readnumber] integerValue]+1;
            NSString *newreadnum = [NSString stringWithFormat:@"%ld",readnum];
            model1.readnumber = newreadnum;
            
            
//            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
//            [tableviewColl reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationFade];
//            [tableviewColl reloadData];
        }
    }
}
-(void)replayListClick:(UIButton *)btn{
    NoticeModelArray *model1 =  self.collectDateArray[btn.tag];
    MeetingReplyListViewController *mrc = [[MeetingReplyListViewController alloc] init];
    mrc.contentid = model1.contentid;
    [self.navigationController pushViewController:mrc animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:tableviewColl]||[tableView isEqual:tabviewAnnex]) {
        return YES;
    }else{
        return NO;
    }
    
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:tableviewColl]) {
         return @"取消收藏";
    }else if ([tableView isEqual:tabviewAnnex]){
         return @"删除附件";
    }else{
        return nil;
    }
    
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
//点击删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:tableviewColl]) {
        NoticeModelArray *model1 = self.collectDateArray[indexPath.section];
        favoriteid = model1.favoriteid;
        contentid = model1.contentid;
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",@"确定要取消收藏吗？"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alert show];
    }else if ([tableView isEqual:tabviewAnnex]){
        anndxselect = indexPath.section;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",@"确认要删除附件吗？"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }
    
    
    
    //在这里实现删除操作
    
    //删除数据，和删除动画
   // [self.myDataArr removeObjectAtIndex:deleteRow];
    //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:deleteRow inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:@"删除"]) {
        [self DeleteCollect];
    }else if ([btnTitle isEqualToString:@"注销"]){
        [JPUSHService setAlias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            [self inputResponseCode:iResCode content:iAlias andSeq:seq];
        } seq:0];
        NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"" forKey:@"userName_CP"];
        [userDefaults setObject:@"" forKey:@"passWord_CP"];
        [userDefaults setObject:@"" forKey:@"islogin_CP"];
        [userDefaults setObject:@"" forKey:@"userid_CP"];
        [userDefaults setObject:@"" forKey:@"name_CP"];
        [userDefaults setObject:@"" forKey:@"sex_CP"];
        [userDefaults setObject:@"" forKey:@"telephone_CP"];
        [userDefaults setObject:@"" forKey:@"birthday_CP"];
        LoginViewController *lovc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:lovc animated:YES];
    }else if ([btnTitle isEqualToString:@"确认"]){
        AnnexModel *model = self.dateArray[anndxselect];
        NSString *documentsPath = [NSString stringWithFormat:@"%@",model.filePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL res=[fileManager removeItemAtPath:documentsPath error:nil];
        if (res) {
            NSLog(@"删除成功");
            [self.dateArray removeAllObjects];
            [self doFiles];
            [self getnumber];
        }
    }
    
    
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
- (void)inputResponseCode:(NSInteger)code content:(NSString *)content andSeq:(NSInteger)seq{
   
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    

    NoticeModelArray *model1 = self.collectDateArray[section];
    
    
    //类型 0：通知；1：会议；2：调查；3：公共信息
    if ([model1.contenttype isEqualToString:@"0"]) {
        NoticeFootView *footview = [[NoticeFootView alloc] init];
         NoticeModelArray *model = self.collectDateArray[section];
        footview.labNoticeReadNum.text = model.readnumber;
        footview.labNoticeFabulous.text = model.signnumber;
        //通知标志（0-无标志 2-置顶 1-热点）mark
        if ([model.mark isEqualToString:@"0"]&[model.readLine isEqualToString:@"0"]) {
            footview.viewNoticeType.hidden = YES;
            footview.viewNoticeLineType.hidden = YES;
            footview.labNoticeCreateTime.frame = CGRectMake(10, 5, 200, 15);
        }else if ([model.mark isEqualToString:@"1"]&[model.readLine isEqualToString:@"1"]){
            footview.labNoticeType.text = @"热";
        }else if ([model.mark isEqualToString:@"2"]&[model.readLine isEqualToString:@"1"]){
            footview.labNoticeType.text = @"置顶";
        }else if ([model.mark isEqualToString:@"1"]&[model.readLine isEqualToString:@"0"]){
            footview.viewNoticeLineType.hidden = YES;
            footview.labNoticeCreateTime.frame = CGRectMake(10+30+5, 5, 200, 15);
        }else if ([model.mark isEqualToString:@"2"]&[model.readLine isEqualToString:@"0"]){
            footview.viewNoticeLineType.hidden = YES;
            footview.labNoticeCreateTime.frame = CGRectMake(10+30+5, 5, 200, 15);
        }else if ([model.mark isEqualToString:@"0"]&[model.readLine isEqualToString:@"1"]){
            footview.viewNoticeType.hidden = YES;
            footview.viewNoticeLineType.frame = CGRectMake(10, 5, 25, 15);
            footview.labNoticeCreateTime.frame = CGRectMake(10+25+10, 5, 200, 15);
        }

        //需要转换的字符串
        NSString *dateString = [model.sendtime substringToIndex:19];
        //设置转换格式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //NSString转NSDate
        NSDate *senddate=[formatter dateFromString:dateString];
        NSString *  locationString=[formatter stringFromDate:senddate];
        NSDate * now = [formatter dateFromString:locationString];

        footview.labNoticeCreateTime.text = [self friendlyTime:(long)[now timeIntervalSince1970]];
        return footview;
    }else if ([model1.contenttype isEqualToString:@"1"]){
        MettingFootView *footview = [[MettingFootView alloc] init];
         NoticeModelArray *model = self.collectDateArray[section];
        NSNumber *number =  @([model.readnumber intValue]);
        NSString *ReadNum = [NSString stringWithFormat:@"%@",number];

        NSNumber *attendnumber =  @([model.attendnumber intValue]);
        NSString *attendnumberstr = [NSString stringWithFormat:@"%@",attendnumber];


        footview.labNoticeReadNum.text = ReadNum;
        footview.labNoticeFabulous.text = attendnumberstr;
        //通知标志（0-无标志 2-置顶 1-热点）mark
        if ([model.mark isEqualToString:@"0"]&[model.readLine isEqualToString:@"0"]) {
            footview.viewNoticeType.hidden = YES;
            footview.viewNoticeLineType.hidden = YES;
            footview.labNoticeCreateTime.frame = CGRectMake(10, 5, 200, 15);
        }else if ([model.mark isEqualToString:@"1"]&[model.readLine isEqualToString:@"1"]){
            footview.labNoticeType.text = @"热";
        }else if ([model.mark isEqualToString:@"2"]&[model.readLine isEqualToString:@"1"]){
            footview.labNoticeType.text = @"置顶";
        }else if ([model.mark isEqualToString:@"1"]&[model.readLine isEqualToString:@"0"]){
            footview.viewNoticeLineType.hidden = YES;
            footview.labNoticeCreateTime.frame = CGRectMake(10+30+5, 5, 200, 15);
        }else if ([model.mark isEqualToString:@"2"]&[model.readLine isEqualToString:@"0"]){
            footview.viewNoticeLineType.hidden = YES;
            footview.labNoticeCreateTime.frame = CGRectMake(10+30+5, 5, 200, 15);
        }else if ([model.mark isEqualToString:@"0"]&[model.readLine isEqualToString:@"1"]){
            footview.viewNoticeType.hidden = YES;
            footview.viewNoticeLineType.frame = CGRectMake(10, 5, 25, 15);
            footview.labNoticeCreateTime.frame = CGRectMake(10+25+10, 5, 200, 15);
        }

        //需要转换的字符串
        NSString *dateString = [model.sendtime substringToIndex:19];
        //设置转换格式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //NSString转NSDate
        NSDate *senddate=[formatter dateFromString:dateString];
        NSString *  locationString=[formatter stringFromDate:senddate];
        NSDate * now = [formatter dateFromString:locationString];

        footview.labNoticeCreateTime.text = [self friendlyTime:(long)[now timeIntervalSince1970]];
        return footview;
    }else if ([model1.contenttype isEqualToString:@"2"]){
        SurveyFootView *footview = [[SurveyFootView alloc] init];
         NoticeModelArray *model = self.collectDateArray[section];
        footview.labNoticeReadNum.text = model.readnumber;
        footview.labNoticeFabulous.text = model.surveynumber;
        //通知标志（0-无标志 2-置顶 1-热点）mark
        if ([model.mark isEqualToString:@"0"]&[model.readLine isEqualToString:@"0"]) {
            footview.viewNoticeType.hidden = YES;
            footview.viewNoticeLineType.hidden = YES;
            footview.labNoticeCreateTime.frame = CGRectMake(10, 5, 200, 15);
        }else if ([model.mark isEqualToString:@"1"]&[model.readLine isEqualToString:@"1"]){
            footview.labNoticeType.text = @"热";
        }else if ([model.mark isEqualToString:@"2"]&[model.readLine isEqualToString:@"1"]){
            footview.labNoticeType.text = @"置顶";
        }else if ([model.mark isEqualToString:@"1"]&[model.readLine isEqualToString:@"0"]){
            footview.viewNoticeLineType.hidden = YES;
            footview.labNoticeCreateTime.frame = CGRectMake(10+30+5, 5, 200, 15);
        }else if ([model.mark isEqualToString:@"2"]&[model.readLine isEqualToString:@"0"]){
            footview.viewNoticeLineType.hidden = YES;
            footview.labNoticeCreateTime.frame = CGRectMake(10+30+5, 5, 200, 15);
        }else if ([model.mark isEqualToString:@"0"]&[model.readLine isEqualToString:@"1"]){
            footview.viewNoticeType.hidden = YES;
            footview.viewNoticeLineType.frame = CGRectMake(10, 5, 25, 15);
            footview.labNoticeCreateTime.frame = CGRectMake(10+25+10, 5, 200, 15);
        }

        //需要转换的字符串
        NSString *dateString = [model.sendtime substringToIndex:19];
        //设置转换格式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //NSString转NSDate
        NSDate *senddate=[formatter dateFromString:dateString];
        NSString *  locationString=[formatter stringFromDate:senddate];
        NSDate * now = [formatter dateFromString:locationString];

        footview.labNoticeCreateTime.text = [self friendlyTime:(long)[now timeIntervalSince1970]];
        return footview;
    }else{
        InforFootView *footview = [[InforFootView alloc] init];
         NoticeModelArray *model = self.collectDateArray[section];
        footview.labNoticeReadNum.text = model.readnumber;
        //通知标志（0-无标志 2-置顶 1-热点）mark
        if ([model.mark isEqualToString:@"0"]&[model.readLine isEqualToString:@"0"]) {
            footview.viewNoticeType.hidden = YES;
            footview.viewNoticeLineType.hidden = YES;
            footview.labNoticeCreateTime.frame = CGRectMake(10, 5, 200, 15);
        }else if ([model.mark isEqualToString:@"1"]&[model.readLine isEqualToString:@"1"]){
            footview.labNoticeType.text = @"热";
        }else if ([model.mark isEqualToString:@"2"]&[model.readLine isEqualToString:@"1"]){
            footview.labNoticeType.text = @"置顶";
        }else if ([model.mark isEqualToString:@"1"]&[model.readLine isEqualToString:@"0"]){
            footview.viewNoticeLineType.hidden = YES;
            footview.labNoticeCreateTime.frame = CGRectMake(10+30+5, 5, 200, 15);
        }else if ([model.mark isEqualToString:@"2"]&[model.readLine isEqualToString:@"0"]){
            footview.viewNoticeLineType.hidden = YES;
            footview.labNoticeCreateTime.frame = CGRectMake(10+30+5, 5, 200, 15);
        }else if ([model.mark isEqualToString:@"0"]&[model.readLine isEqualToString:@"1"]){
            footview.viewNoticeType.hidden = YES;
            footview.viewNoticeLineType.frame = CGRectMake(10, 5, 25, 15);
            footview.labNoticeCreateTime.frame = CGRectMake(10+25+10, 5, 200, 15);
        }

        //需要转换的字符串
        NSString *dateString = [model.sendtime substringToIndex:19];
        //设置转换格式
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //NSString转NSDate
        NSDate *senddate=[formatter dateFromString:dateString];
        NSString *  locationString=[formatter stringFromDate:senddate];
        NSDate * now = [formatter dateFromString:locationString];

        footview.labNoticeCreateTime.text = [self friendlyTime:(long)[now timeIntervalSince1970]];
        return footview;
    }



}

- (NSString *)friendlyTime:(long)datetime
{
    time_t current_time = time(NULL);
    
    time_t delta = current_time - datetime;
    
    if (delta <= 0) {
        return @"刚刚";
    }
    else if (delta <60)
        return [NSString stringWithFormat:@"%ld秒前", delta];
    else if (delta <3600)
        return [NSString stringWithFormat:@"%ld分钟前", delta /60];
    else {
        struct tm tm_now, tm_in;
        localtime_r(&current_time, &tm_now);
        localtime_r(&datetime, &tm_in);
        NSString *format = nil;
        
        if (tm_now.tm_year == tm_in.tm_year) {
            if (tm_now.tm_yday == tm_in.tm_yday)
                format = @"今天 %-H:%M";
            else
                format = @"%-m月%-d日 %-H:%M";
        }
        else
            format = @"%Y年%-m月%-d日 %-H:%M";
        
        char buf[256] = {0};
        strftime(buf, sizeof(buf), [format UTF8String], &tm_in);
        return [NSString stringWithUTF8String:buf];
    }
}





- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (self.documentController == nil)
    {
        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.documentController.delegate = self;
    }
    else
    {
        self.documentController.URL = url;
    }
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}


- (void)DeleteCollect{
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"删除中...";
    hud.minSize = CGSizeMake(100.f, 100.f);
    hud.color=[UIColor blackColor];
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"DeleteCollect"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"userid": [userDefaults objectForKey:@"userid_CP"],
                                 @"favoriteid":favoriteid,
                                 @"contentid":contentid
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
            [self loadCollDate];
            hud.labelText = @"取消成功";
            [hud hide:YES afterDelay:0.5];
            [self getnumber];
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

-(void)getnumber{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"GetPendingList"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"userid": [userDefaults objectForKey:@"userid_CP"],
                                 @"date": @""
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
            
            NSDictionary *dicb = [responseObject objectForKey:@"data"];
            
            NSArray *dateArray = [dicb objectForKey:@"pendinglist"];
            
            NSArray *pendingArray;
            for (NSDictionary * dic in dateArray)
            {
                pendingArray = [dic objectForKey:@"list"];
            }
            
            NSString *num = [NSString stringWithFormat:@"%ld",pendingArray.count];
            pendingnumber = num;
            [self getCollectiNumner];
            if (dateArray.count==0) {
                pendingnumber = @"0";
                [self getCollectiNumner];
            }
        }else if ([[responseObject objectForKey:@"code"] isEqualToString:@"1001"]){
            pendingnumber = @"0";
             [self getCollectiNumner];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         pendingnumber = @"0";
         [self getCollectiNumner];
        NSLog(@"Error: ==============%@", error);
    }];
}
-(void)getCollectiNumner{
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *postUrl1 = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"GetCollectList"];
    NSDictionary *parameters1 = @{@"userid": [userDefaults objectForKey:@"userid_CP"]
                                  };
    AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
    manager1.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
    manager1.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    // 设置超时时间
    [manager1.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager1.requestSerializer.timeoutInterval = 10.f;
    [manager1.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager1 POST:postUrl1 parameters:parameters1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"结果: %@", responseObject);
        
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"1000"]) {
            NSArray *dateArray = [responseObject objectForKey:@"data"];
            NSString *num = [NSString stringWithFormat:@"%ld",dateArray.count];
            collnumber = num;
            [self getFileNumber];
            if (dateArray.count==0) {
                collnumber = @"0";
                [self getFileNumber];
            }
        }else if ([[responseObject objectForKey:@"code"] isEqualToString:@"1001"]){
            collnumber = @"0";
            [self getFileNumber];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        collnumber = @"0";
        [self getFileNumber];
        NSLog(@"Error: ==============%@", error);
    }];
}


-(void)getFileNumber{
    [self.dateArrayNumer removeAllObjects];
    NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/CPJWFiles"];
    NSLog(@"%@",docsDir);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *errDir = nil;
    NSArray *subs = [fileManager contentsOfDirectoryAtPath:docsDir error:&errDir];
    
    if (subs.count>0) {
        for (int j=0; j<subs.count; j++) {
            BOOL isDir;
            [fileManager fileExistsAtPath:[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",[subs objectAtIndex:j]]] isDirectory:&isDir];
            if (isDir) {
                NSLog(@"这是个****文件夹****");
                NSArray *subs1=[fileManager subpathsAtPath:[docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",[subs objectAtIndex:j]]]];
                for (int i=0; i<subs1.count; i++) {
                    AnnexModel *model = [[AnnexModel alloc] init];
                    NSString *subName = [NSString stringWithFormat:@"%@",[subs1 objectAtIndex:i]];
                    model.fileName = subName;
                    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",docsDir,[subs objectAtIndex:j],[subs1 objectAtIndex:i]];
                    model.filePath = path;
                    [self.dateArrayNumer addObject:model];
                }
                
            }else{
                NSLog(@"这是个****文件**** ");
            }
        }
        
        if (self.dateArrayNumer.count>0) {
            NSString *num = [NSString stringWithFormat:@"%ld",self.dateArrayNumer.count];
            
            annexnubmer = num;
            [yfViewPager setTipsCountArray:@[collnumber,pendingnumber,annexnubmer]];
        }else{
            [yfViewPager setTipsCountArray:@[collnumber,pendingnumber,@0]];
        }
    }else{
         [yfViewPager setTipsCountArray:@[collnumber,pendingnumber,@0]];
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
