//
//  MeetingViewController.m
//  CPEducation_AP
//
//  Created by lishouping on 16/12/22.
//  Copyright © 2016年 李寿平. All rights reserved.
//

#import "MeetingViewController.h"
#import "MineViewController.h"
#import "NoticeModelArray.h"

#import "MettingKeyWordsTableViewCell.h"
#import "MettingImageUpTableViewCell.h"
#import "MettingImageDownTableViewCell.h"
#import "MettingVideoTableViewCell.h"
#import "MettingMoreImageTableViewCell.h"

#import "MettingDeatileViewController.h"
#import "MettingDeatledMoreImgViewController.h"
#import "MettingDetaledViedoViewController.h"
#import "MettingDetailedImageUpViewController.h"
#import "MeetingDetaledImageDownViewController.h"

#import "MettingFootView.h"
#import "QRCodeingViewController.h"
#import "MeetingReplyListViewController.h"
static NSInteger position;
static NSInteger pageposition;


@interface MeetingViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UITableView *meettableView;
    UISearchBar *searchMetting;
    //页码
    int page;
    UIButton *btnSign;//签到按钮
    
}
@property(nonatomic,strong)NSMutableArray *meetDataArray;
@end

@implementation MeetingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self loadUnreadInform];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if (myDelegate==nil) {
    }else if ([myDelegate.pagerefresh isEqualToString:@"3" ]){
        page=1;
         [meettableView headerBeginRefreshing];
    }else if ([myDelegate.pagerefresh isEqualToString:@"update"]){
        page=1;
        [meettableView headerBeginRefreshing];
        [self.meetDataArray removeAllObjects];
        myDelegate.pagerefresh = nil;
    }
    else{
        [self refreshNotice];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"昌平教委移动办公";
    // Do any additional setup after loading the view.
    self.meetDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self createRightBtn];
    [self createTableView];
    [self makeUI];
    
    //加上刷新控件
    [self setupTableView];
    [meettableView headerBeginRefreshing];
    
}
- (void)refreshNotice{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    if ([myDelegate.pagerefresh isEqualToString:@"1"]) {
        NSLog(@"刷新+1");
        NoticeModelArray *model1 = self.meetDataArray[pageposition];
        model1.attendstate = @"3";
        NSInteger readnum = [[NSString stringWithFormat:@"%@",model1.attendnumber] integerValue]+1;
        NSString *newreadnum = [NSString stringWithFormat:@"%ld",readnum];
        model1.attendnumber = newreadnum;
        
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:position inSection:0];
        [meettableView reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationFade];
        [meettableView reloadData];
    }else if ([myDelegate.pagerefresh isEqualToString:@"0"]){
        NoticeModelArray *model1 = self.meetDataArray[pageposition];
        model1.attendstate = @"1";
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:position inSection:0];
        [meettableView reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationFade];
        [meettableView reloadData];
    }else if ([myDelegate.pagerefresh isEqualToString:@"2"]){
        NoticeModelArray *model1 = self.meetDataArray[pageposition];
        model1.attendstate = @"2";
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:position inSection:0];
        [meettableView reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationFade];
        [meettableView reloadData];
    }
    myDelegate.pagerefresh =  nil;
}
-(void)setupTableView
{
    //下拉刷新
    [meettableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //上拉加载
    [meettableView addFooterWithTarget:self action:@selector(footerRereshing)];
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
   // [rightBtn setBackgroundColor:[UIColor whiteColor]];
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
- (void)rightBtnButtonClick{
    MineViewController *mvc = [[MineViewController alloc] init];
    [self.navigationController pushViewController:mvc animated:YES];
}

// 创建TableView
- (void)createTableView{
    meettableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, kWidth, kHeight-(10)) style:UITableViewStyleGrouped];
    meettableView.delegate = self;
    meettableView.dataSource = self;
    [self.view addSubview:meettableView];
}
- (void)makeUI{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20+44, kWidth, 40)];
    [titleView setBackgroundColor:[UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:206.0/255.0 alpha:1]];
    [self.view addSubview:titleView];
    
    searchMetting = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kWidth-70, 40)];
    searchMetting.delegate = self;
    searchMetting.showsCancelButton = YES;
    for (id cencelButton in [searchMetting.subviews[0] subviews])
    {
        if([cencelButton isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cencelButton;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
    [titleView addSubview:searchMetting];
    
    btnSign = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-10-50, 5, 50, 30)];
    [btnSign setTitle:@"签到" forState:UIControlStateNormal];
    [btnSign setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btnSign setBackgroundColor:[UIColor colorWithRed:17.0/255 green:133.0/255 blue:231.0/255 alpha:1]];
    btnSign.layer.cornerRadius = 15;
    btnSign.font = [UIFont systemFontOfSize:12];
    [titleView addSubview:btnSign];
    [btnSign addTarget:self action:@selector(signBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)signBtn{
    NSLog(@"----sign------");
    QRCodeingViewController *qrc = [[QRCodeingViewController alloc] init];
    qrc.contentid = @"-199";
    [self.navigationController pushViewController:qrc animated:YES];
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
- (void)loadingDate{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"GetMainContentList"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"userid": [userDefaults objectForKey:@"userid_CP"],
                                 @"content": searchMetting.text,
                                 @"type":@"1",
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
            [self.meetDataArray removeAllObjects];
        }
        int totalPage = [[responseObject objectForKey:@"code"] intValue];
        if (totalPage<page)
        {
            //停止上拉加载
            [meettableView footerEndRefreshing];
            UIAlertView * al=[[UIAlertView alloc]initWithTitle:nil message:@"无更多数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [al show];
            [meettableView headerEndRefreshing];
            return;
        }
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"1000"]) {
            
            NSArray *dateArray = [responseObject objectForKey:@"data"];
            for (NSDictionary * dic in dateArray)
            {
                NoticeModelArray *model = [NoticeModelArray new];
                model.contenttype = [dic objectForKey:@"contenttype"];
                model.templates = [dic objectForKey:@"template"];
                model.contentid = [dic objectForKey:@"contentid"];
                model.title =[dic objectForKey:@"title"];
                model.content = [dic objectForKey:@"content"];
                model.mark = [dic objectForKey:@"mark"];
                model.readLine = [dic objectForKey:@"readLine"];
                model.sendtime = [dic objectForKey:@"sendtime"];
                model.readnumber = [dic objectForKey:@"readnumber"];
                model.picturelist = [dic objectForKey:@"picturelist"];
                model.video_url = [dic objectForKey:@"video_url"];
                model.link_url  = [dic objectForKey:@"link_url"];
                model.attendstate = [dic objectForKey:@"attendstate"];
                model.attendnumber = [dic objectForKey:@"attendnumber"];
                model.messagenumber = [dic objectForKey:@"messagenumber"];
                [self.meetDataArray  addObject:model];
            }
            [meettableView reloadData];
        }
        
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
            [alert show];
            
            
        }
        
        if (page==1)
        {
            [meettableView headerEndRefreshing];
        }
        else
        {
            [meettableView footerEndRefreshing];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
    
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.meetDataArray.count;
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
    
    NoticeModelArray *model1 =  self.meetDataArray[indexPath.section];
    
    if ([model1.templates isEqualToString:@"0"]) {
        [cell setModel:model1];
        cell.mettingRepNumView.tag = indexPath.section;
        [cell.mettingRepNumView addTarget:self action:@selector(replayListClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if ([model1.templates isEqualToString:@"1"]){
        [cell1 setModel:model1];
        cell1.mettingRepNumView.tag = indexPath.section;
        [cell1.mettingRepNumView addTarget:self action:@selector(replayListClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell1;
    }else if ([model1.templates isEqualToString:@"2"]){
        [cell2 setModel:model1];
        cell2.mettingRepNumView.tag = indexPath.section;
        [cell2.mettingRepNumView addTarget:self action:@selector(replayListClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell2;
    }else if ([model1.templates isEqualToString:@"3"]){
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
}
-(void)replayListClick:(UIButton *)btn{
    NoticeModelArray *model1 =  self.meetDataArray[btn.tag];
    MeetingReplyListViewController *mrc = [[MeetingReplyListViewController alloc] init];
    mrc.contentid = model1.contentid;
    [self.navigationController pushViewController:mrc animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeModelArray *model1 =  self.meetDataArray[indexPath.section];
    
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
    
    
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [meettableView reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationFade];
    [meettableView reloadData];
    
    position = indexPath.row;
    pageposition = indexPath.section;

}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    MettingFootView *footview = [[MettingFootView alloc] init];
    NoticeModelArray *model =  self.meetDataArray[section];
    
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
