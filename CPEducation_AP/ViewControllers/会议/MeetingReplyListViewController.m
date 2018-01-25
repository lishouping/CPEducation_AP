//
//  MeetingReplyListViewController.m
//  CPEducation_AP
//  会议回复列表
//  Created by lishouping on 2017/6/28.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "MeetingReplyListViewController.h"
#import "MeetingReplayTableViewCell.h"
#import "MeetingReplyModel.h"
#import "EmojiTextAttachment.h"
#import "NSAttributedString+EmojiExtension.h"

@interface MeetingReplyListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    UIImageView *imgUser;
    UILabel *lableUser;
    UILabel *labTime;
    UILabel *labMessage;
    UIView *headlineView;
    UITableView *tableviewReplay;

    UIView *footView;
    
    UITextView *inputText;
    UIButton *btnEmselect;
    UIButton *btnSend;
}
@property(nonatomic,strong)NSMutableArray *dateArray1;
@property(nonatomic,strong)NSMutableArray *dateArray;

@property (strong, nonatomic) NSArray *emojiTags;
@property (strong, nonatomic) NSArray *emojiImages;
@end

@implementation MeetingReplyListViewController
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
    self.navigationItem.title = @"不参加原因";
    
    self.dateArray1 = [[NSMutableArray alloc] initWithCapacity:0];
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];

    [self makeUI];
    
    [self loadingDate];
    
    
    //Init
    _emojiTags = @[@"\\ud83d\\ude04", @"\\ud83d\\ude03", @"\\ud83d\\ude00", @"\\ud83d\\ude0a",@"\\u263a\\ufe0f",@"\\u263a\\ufe0f",@"\\ud83d\\ude09",@"\\ud83d\\ude0d",@"\\ud83d\\ude18",@"\\ud83d\\ude1a",@"\\ud83d\\ude17",@"\\ud83d\\ude19",@"\\ud83d\\ude1c",@"\\ud83d\\ude1d",@"\\ud83d\\ude1b",@"\\ud83d\\ude33",@"\\ud83d\\ude01",@"\\ud83d\\ude14",@"\\ud83d\\ude0c",@"\\ud83d\\ude12",@"\\ud83d\\ude1e",@"\\ud83d\\ude23",@"\\ud83d\\ude22",@"\\ud83d\\ude02",@"\\ud83d\\ude2d",@"\\ud83d\\ude2a",@"\\ud83d\\ude25",@"\\ud83d\\ude30",@"\\ud83d\\ude05",@"\\ud83d\\ude13",@"\\ud83d\\ude29",@"\\ud83d\\ude2b",@"\\ud83d\\ude28",@"\\ud83d\\ude31",@"\\ud83d\\ude20",@"\\ud83d\\ude21",@"\\ud83d\\ude24",@"\\ud83d\\ude16",@"\\ud83d\\ude06",@"\\ud83d\\ude0b",@"\\ud83d\\ude37",@"\\ud83d\\ude0e",@"\\ud83d\\ude34",@"\\ud83d\\ude35",@"\\ud83d\\ude32",@"\\ud83d\\ude1f",@"\\ud83d\\ude26",@"\\ud83d\\ude27",@"\\ud83d\\ude08",@"\\ud83d\\udc7f",@"\\ud83d\\ude2e",@"\\ud83d\\ude2c",@"\\ud83d\\ude10",@"\\ud83d\\ude15",@"\\ud83d\\ude2f",@"\\ud83d\\ude36",@"\\ud83d\\ude07",@"\\ud83d\\ude0f",@"\\ud83d\\ude11",@"\\ud83d\\udc72"];
    _emojiImages = @[
                  [UIImage imageNamed:@"ee_1"], [UIImage imageNamed:@"ee_2"], [UIImage imageNamed:@"ee_3"], [UIImage imageNamed:@"ee_4"], [UIImage imageNamed:@"ee_5"], [UIImage imageNamed:@"ee_6"], [UIImage imageNamed:@"ee_5"], [UIImage imageNamed:@"ee_6"], [UIImage imageNamed:@"ee_7"], [UIImage imageNamed:@"ee_8"], [UIImage imageNamed:@"ee_9"], [UIImage imageNamed:@"ee_10"], [UIImage imageNamed:@"ee_11"], [UIImage imageNamed:@"ee_12"], [UIImage imageNamed:@"ee_13"], [UIImage imageNamed:@"ee_14"], [UIImage imageNamed:@"ee_15"], [UIImage imageNamed:@"ee_16"], [UIImage imageNamed:@"ee_17"], [UIImage imageNamed:@"ee_18"], [UIImage imageNamed:@"ee_19"], [UIImage imageNamed:@"ee_20"], [UIImage imageNamed:@"ee_21"], [UIImage imageNamed:@"ee_22"],[UIImage imageNamed:@"ee_23"], [UIImage imageNamed:@"ee_24"], [UIImage imageNamed:@"ee_25"], [UIImage imageNamed:@"ee_26"], [UIImage imageNamed:@"ee_27"], [UIImage imageNamed:@"ee_28"], [UIImage imageNamed:@"ee_29"], [UIImage imageNamed:@"ee_30"], [UIImage imageNamed:@"ee_31"], [UIImage imageNamed:@"ee_32"], [UIImage imageNamed:@"ee_33"], [UIImage imageNamed:@"ee_34"], [UIImage imageNamed:@"ee_35"], [UIImage imageNamed:@"ee_36"], [UIImage imageNamed:@"ee_37"], [UIImage imageNamed:@"ee_38"], [UIImage imageNamed:@"ee_39"], [UIImage imageNamed:@"ee_40"], [UIImage imageNamed:@"ee_41"], [UIImage imageNamed:@"ee_42"], [UIImage imageNamed:@"ee_43"], [UIImage imageNamed:@"ee_44"], [UIImage imageNamed:@"ee_45"], [UIImage imageNamed:@"ee_46"], [UIImage imageNamed:@"ee_47"], [UIImage imageNamed:@"ee_48"], [UIImage imageNamed:@"ee_49"], [UIImage imageNamed:@"ee_50"], [UIImage imageNamed:@"ee_51"], [UIImage imageNamed:@"ee_52"], [UIImage imageNamed:@"ee_53"], [UIImage imageNamed:@"ee_54"], [UIImage imageNamed:@"ee_55"], [UIImage imageNamed:@"ee_56"], [UIImage imageNamed:@"ee_57"], [UIImage imageNamed:@"ee_58"]
                    
     ];

    
    // Do any additional setup after loading the view.
}
- (void)makeUI{
    imgUser = [UIImageView new];
    [imgUser setImage:[UIImage imageNamed:@"cp_replayuser"]];
    [self.view addSubview:imgUser];
    [imgUser zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(10);
        layout.leftSpace(10);
        layout.widthValue(30);
        layout.heightValue(30);
    }];
    
    lableUser = [UILabel new];
    [lableUser setText:@"管理员"];
    [lableUser setFont:[UIFont systemFontOfSize:15]];
    [lableUser setTextColor:[UIColor blackColor]];
    [self.view addSubview:lableUser];
    [lableUser zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(10);
        layout.leftSpaceByView(imgUser, 10);
        layout.widthValue(100);
        layout.heightValue(30);
    }];
    
    labTime = [UILabel new];
    [labTime setText:@"2017年02月12日"];
    [labTime setFont:[UIFont systemFontOfSize:13]];
    [labTime setTextColor:[UIColor grayColor]];
    [self.view addSubview:labTime];
    [labTime zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(10);
        layout.leftSpaceByView(lableUser, 20);
        layout.widthValue(120);
        layout.heightValue(30);
    }];
    
    labMessage = [UILabel new];
    [labMessage setText:@"订单管理"];
    [labMessage setFont:[UIFont systemFontOfSize:13]];
    [labMessage setTextColor:[UIColor grayColor]];
    [self.view addSubview:labMessage];
    [labMessage zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(lableUser, 0);
        layout.leftSpace(50);
        layout.widthValue(kWidth-10-10);
        layout.heightValue(30);
    }];
    
    headlineView = [UIView new];
    [headlineView setBackgroundColor:[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1]];
    [self.view addSubview:headlineView];
    [headlineView zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpaceByView(labMessage, 0);
        layout.leftSpace(0);
        layout.rightSpace(0);
        layout.widthValue(kWidth);
        layout.heightValue(10);
    }];
    
    tableviewReplay = [[UITableView alloc] initWithFrame:CGRectMake(0, 80+10, kWidth, kHeight-60-44-20-80) style:UITableViewStylePlain];
    tableviewReplay.delegate = self;
    tableviewReplay.dataSource = self;
    [self.view addSubview:tableviewReplay];
    
    
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight-50-44-20, kWidth, 50)];
    [footView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:footView];
    
    
    inputText = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, kWidth-100, 40)];
    inputText.layer.cornerRadius = 5;
    inputText.layer.masksToBounds = YES;
    inputText.font = [UIFont systemFontOfSize:15];
    inputText.delegate = self;
    UIColor *customColor  = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1];
    inputText.layer.borderColor = customColor.CGColor;
    inputText.layer.borderWidth = 1.0;
    [footView addSubview:inputText];
    
    
    btnEmselect = [UIButton new];
    [btnEmselect setImage:[UIImage imageNamed:@"ic_ex"] forState:UIControlStateNormal];
    [footView addSubview:btnEmselect];
    [btnEmselect zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(10);
        layout.leftSpaceByView(inputText, 12);
        layout.widthValue(30);
        layout.heightValue(30);
    }];
    
    btnSend = [UIButton new];
    [btnSend setImage:[UIImage imageNamed:@"ic_send"] forState:UIControlStateNormal];
    [footView addSubview:btnSend];
    [btnSend zxp_addConstraints:^(ZXPAutoLayoutMaker *layout) {
        layout.topSpace(10);
        layout.rightSpace(12);
        layout.widthValue(30);
        layout.heightValue(30);
    }];

    [btnSend addTarget:self action:@selector(sendReplayMessage) forControlEvents:UIControlEventTouchUpInside];
}
// 获取列表数据
- (void)loadingDate{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"GetReplyList"];
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
            
            NSArray *dateArray = [responseObject objectForKey:@"data"];
            for (NSDictionary * dic in dateArray)
            {
                
                NSString *meetingtype = [dic objectForKey:@"meetingtype"];
                if ([meetingtype isEqualToString:@"1"]) {
                    MeetingReplyModel *mode1 = [[MeetingReplyModel alloc] init];
                    mode1.replyid = [dic objectForKey:@"replyid"];
                    mode1.userid = [dic objectForKey:@"userid"];
                    mode1.username = [dic objectForKey:@"username"];
                    mode1.replytime = [dic objectForKey:@"replytime"];
                    mode1.content = [dic objectForKey:@"content"];
                    mode1.getuserid = [userDefaults objectForKey:@"userid_CP"];
                    mode1.contentid = self.contentid;
                    [self.dateArray1 addObject:mode1];
                }else if ([meetingtype isEqualToString:@"4"]){
                    MeetingReplyModel *mode2 = [[MeetingReplyModel alloc] init];
                    mode2.replyid = [dic objectForKey:@"replyid"];
                    mode2.userid = [dic objectForKey:@"userid"];
                    mode2.username = [dic objectForKey:@"username"];
                    mode2.replytime = [dic objectForKey:@"replytime"];
                    mode2.content = [dic objectForKey:@"content"];
                    mode2.getuserid = [userDefaults objectForKey:@"userid_CP"];
                    mode2.contentid = self.contentid;
                    [self.dateArray addObject:mode2];
                }
                
            }
            [tableviewReplay reloadData];
            //需要转换的字符串
            MeetingReplyModel *mode3 = [self.dateArray1 objectAtIndex:self.dateArray1.count-1];
            NSString *dateString = [mode3.replytime substringToIndex:19];
            NSLog(@"%@",dateString);
            //设置转换格式
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //NSString转NSDate
            NSDate *senddate=[formatter dateFromString:dateString];
            NSString *  locationString=[formatter stringFromDate:senddate];
            NSDate * now = [formatter dateFromString:locationString];
            
            labTime.text = [self friendlyTime:(long)[now timeIntervalSince1970]];
            lableUser.text = mode3.username;
            labMessage.text = mode3.content;
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
-(BOOL)textFieldShouldReturn:(UITextView *)textField
{
    [inputText resignFirstResponder];
    return YES;
}

// 删除回复列表
- (void)deleteReplyDate:(NSString *) andreplayId:(NSString *) str{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"UserDeleteReply"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"userid": [userDefaults objectForKey:@"userid_CP"],
                                 @"contentid": self.contentid,
                                 @"replyid":str
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
            [self.dateArray removeAllObjects];
            [tableviewReplay reloadData];
            [self loadingDate];
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

-(void)sendReplayMessage{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"MeetingAttend"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"userid": [userDefaults objectForKey:@"userid_CP"],
                                 @"contentid": self.contentid,
                                 @"type":@"4",
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
            
            [self.dateArray removeAllObjects];
            [tableviewReplay reloadData];
            [self loadingDate];
            
            inputText.text = @"";
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
    return self.dateArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MeetingReplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
    if (cell==nil) {
        cell = [[MeetingReplayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    MeetingReplyModel *mode3 = [self.dateArray objectAtIndex:indexPath.section];
    cell.lableUser.text = [NSString stringWithFormat:@"%@",mode3.username];
    cell.labMessage.text = [NSString stringWithFormat:@"%@",mode3.content];
    
    NSTextAttachment* attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"ee_01"];
    
    
    NSString *dateString = [mode3.replytime substringToIndex:19];
    NSLog(@"%@",dateString);
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *senddate=[formatter dateFromString:dateString];
    NSString *  locationString=[formatter stringFromDate:senddate];
    NSDate * now = [formatter dateFromString:locationString];
    cell.labTime.text = [self friendlyTime:(long)[now timeIntervalSince1970]];
    
    cell.btnDel.tag = indexPath.section;
    [cell.btnDel addTarget:self action:@selector(deleteReplay:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([mode3.getuserid isEqualToString:mode3.userid]) {
        cell.btnDel.hidden = NO;
    }else{
        cell.btnDel.hidden = YES;
    }
    
    return cell;
}

- (void)deleteReplay:(UIButton *)btnTag{
    MeetingReplyModel *mode3 = [self.dateArray objectAtIndex:btnTag.tag];
    [self deleteReplyDate:mode3.getuserid :mode3.replyid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
