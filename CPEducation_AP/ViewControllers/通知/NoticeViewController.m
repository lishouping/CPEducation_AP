//
//  NoticeViewController.m
//  CPEducation_AP
//  通知
//  Created by lishouping on 16/12/22.
//  Copyright © 2016年 李寿平. All rights reserved.
//

#import "NoticeViewController.h"
#import "MineViewController.h"

#import "NoticeKeyWordsTableViewCell.h"
#import "NoticeImageUpTableViewCell.h"
#import "NoticeImageDownTableViewCell.h"
#import "NoticeVideoTableViewCell.h"
#import "NoticeMoreImageTableViewCell.h"


#import "UITableView+SDAutoTableViewCellHeight.h"
#import "UIView+SDAutoLayout.h"
#import "NoticeHeaderView.h"
#import "NoticeFootView.h"
#import "NoticeModelArray.h"
#import "LoginViewController.h"

#import "NoticeDeatileViewController.h"
#import "NoticeDetaledViedoViewController.h"
#import "NoticeDeatledMoreImgViewController.h"
#import "NoticeDetailedImageUpViewController.h"
#import "NoticeDetaledImageDownViewController.h"

#import "MeetingDetaledImageDownViewController.h"

static int *position;

@interface NoticeViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    UITableView *tabNotice;
    UISearchBar *searchNotice;
    //页码
    int page;
}
@property(nonatomic,strong)NSMutableArray *dateArray;
@end

@implementation NoticeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [self loadUnreadInform];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if ([myDelegate.pagerefresh isEqualToString:@"update"]){
        page=1;
         [self.dateArray removeAllObjects];
        [tabNotice headerBeginRefreshing];
        myDelegate.pagerefresh = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"昌平教委移动办公";
    // Do any additional setup after loading the view.
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self createRightBtn];
    [self createTableView];
    [self makeUI];
    
//    [self loadUnreadInform];
    //加上刷新控件
    [self setupTableView];
    [tabNotice headerBeginRefreshing];
   
}

//加上刷新控件
-(void)setupTableView
{
    //下拉刷新
    [tabNotice addHeaderWithTarget:self action:@selector(headerRereshing)];
    //上拉加载
    [tabNotice addFooterWithTarget:self action:@selector(footerRereshing)];
    //刷新在viewWillAppear
}


//下拉
- (void)headerRereshing
{
    page=1;
    [self loadingDate];
}
//上拉
-(void)footerRereshing
{
    page++;
    [self loadingDate];
}



- (void)createRightBtn{
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"mine"] forState:UIControlStateNormal];
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
// 创建TableView
- (void)createTableView{
    tabNotice = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, kWidth, kHeight-(10)) style:UITableViewStyleGrouped];
    tabNotice.delegate = self;
    tabNotice.dataSource = self;
    [self.view addSubview:tabNotice];
}
- (void)makeUI{
    searchNotice = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20+44, kWidth, 40)];
    searchNotice.delegate = self;
    searchNotice.showsCancelButton = YES;
    for (id cencelButton in [searchNotice.subviews[0] subviews])
    {
        if([cencelButton isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cencelButton;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
    [self.view addSubview:searchNotice];
}
- (void)loadingDate{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"GetMainContentList"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"userid": [userDefaults objectForKey:@"userid_CP"],
                                 @"content": searchNotice.text,
                                 @"type":@"0",
                                 @"page":[NSString stringWithFormat:@"%d",page],
                                 @"size":@"10",
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
        if (page==1)
        {
            [self.dateArray removeAllObjects];
        }
        int totalPage = [[responseObject objectForKey:@"code"] intValue];
        if (totalPage<page)
        {
            //停止上拉加载
            [tabNotice footerEndRefreshing];
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"无更多数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [al show];
            [tabNotice headerEndRefreshing];
            return;
        }
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"1000"]) {
       
            NSArray *dateArray = [responseObject objectForKey:@"data"];
            for (NSDictionary * dic in dateArray)
            {
                NoticeModelArray *model = [NoticeModelArray new];
                model.contentid = [dic objectForKey:@"contentid"];
                model.title =[dic objectForKey:@"title"];
                model.contenttype = [dic objectForKey:@"contenttype"];
                model.templates = [dic objectForKey:@"template"];
                model.content = [dic objectForKey:@"content"];
                
                model.picturelist = [dic objectForKey:@"picturelist"];
                
                
                model.signstate = [dic objectForKey:@"signstate"];
                model.mark = [dic objectForKey:@"mark"];
                model.sendtime = [dic objectForKey:@"sendtime"];
                model.readnumber = [dic objectForKey:@"readnumber"];
                model.signnumber = [dic objectForKey:@"signnumber"];
                model.readLine = [dic objectForKey:@"readLine"];
                model.video_url = [dic objectForKey:@"video_url"];
                model.link_url  = [dic objectForKey:@"link_url"];
                [self.dateArray  addObject:model];
            }
             [tabNotice reloadData];
        }
        
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
            [alert show];
            
            
        }
        
        if (page==1)
        {
            [tabNotice headerEndRefreshing];
        }
        else
        {
            [tabNotice footerEndRefreshing];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        NSLog(@"Error: ==============%@", error);
    }];

}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"----searchBarCancelButtonClicked------");
    // 取消搜索状态
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"----searchBarSearchButtonClicked------");
    // 调用filterBySubstring:方法执行搜索
    [self loadingDate];
    // 放弃作为第一个响应者，关闭键盘
    [searchBar resignFirstResponder];
}

// 获取徽标上的数字 通知未读条数
-(void)loadUnreadInform{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"UnreadInform"];
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
            
                NSData *jsonData = [[responseObject objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                
                NSString *Inform = [dic objectForKey:@"Inform"];
                
                if ([Inform intValue]!=0) {
                    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:0];
                    if ([Inform intValue]>99) {
                        item.badgeValue=@"99...";
                    }else{
                        item.badgeValue=[NSString stringWithFormat:@"%@",Inform];
                    }
                }
                NSString *meeting = [dic objectForKey:@"meeting"];
                if ([meeting intValue]!=0) {
                    UITabBarItem * item1=[self.tabBarController.tabBar.items objectAtIndex:1];
                    if ([meeting intValue]>99) {
                        item1.badgeValue=@"99...";
                    }else{
                        item1.badgeValue=[NSString stringWithFormat:@"%@",meeting];
                    }
                }
                
                NSString *survey = [dic objectForKey:@"survey"];
                if ([survey intValue] !=0) {
                    UITabBarItem * item2=[self.tabBarController.tabBar.items objectAtIndex:2];
                    if ([survey intValue]>99) {
                        item2.badgeValue=@"99...";
                    }else{
                        item2.badgeValue=[NSString stringWithFormat:@"%@",survey];
                    }
                }
                
                
                NSString *information = [dic objectForKey:@"information"];
                if ([information intValue]!=0) {
                    UITabBarItem * item3=[self.tabBarController.tabBar.items objectAtIndex:3];
                    if ([information intValue]>99) {
                        item3.badgeValue=@"99...";
                    }else{
                        item3.badgeValue=[NSString stringWithFormat:@"%@",information];
                    }
                }
                //item.badgeColor = [UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1];
                [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
               
        }
        
        else
        {
    
        }        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];

}

- (void)rightBtnButtonClick{
    MineViewController *mvc = [[MineViewController alloc] init];
    [self.navigationController pushViewController:mvc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dateArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return [tableView zxp_cellHeightWithindexPath:indexPath space:10];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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

    NoticeModelArray *model1 =  self.dateArray[indexPath.section];
    
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ////模板id 0-全文字 1-图上文下 2-图下文上 3-多图 4-视频
    NoticeModelArray *model1 =  self.dateArray[indexPath.section];
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
    
    
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [tabNotice reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationFade];
    [tabNotice reloadData];
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NoticeFootView *footview = [[NoticeFootView alloc] init];
    NoticeModelArray *model =  self.dateArray[section];
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
        footview.labNoticeType.text = @"热";
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
