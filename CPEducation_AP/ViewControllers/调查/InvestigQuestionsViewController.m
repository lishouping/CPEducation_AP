//
//  InvestigQuestionsViewController.m
//  CPEducation_AP
//
//  Created by lishouping on 2017/6/30.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "InvestigQuestionsViewController.h"
#import "QuestionTableViewCell.h"
#import "SurveyQuestionModel.h"
#import "NSString+Jeson.h"
#import "SBJson.h"



@interface InvestigQuestionsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tabSurveyQuestion;
    UILabel *labsurveyendtime;
}
@property(nonatomic,strong)NSMutableArray *dateArray;
@end

@implementation InvestigQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"调查问题";
    self.dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    [self makeUI];
    [self loadDate];
}

- (void)makeUI{
    labsurveyendtime = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,kWidth-10-10, 30)];
    labsurveyendtime.textColor = [UIColor grayColor];
    labsurveyendtime.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:labsurveyendtime];
    tabSurveyQuestion = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kWidth, kHeight-40) style:UITableViewStylePlain];
    tabSurveyQuestion.delegate = self;
    tabSurveyQuestion.dataSource = self;
    [self.view addSubview:tabSurveyQuestion];
}

- (void)loadDate{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"GetDateSurvey"];
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

        if ([[responseObject objectForKey:@"code"] isEqualToString:@"1000"]) {
            
            NSNumber *number = [responseObject objectForKey:@"suveystate"];
            NSString *type = [NSString stringWithFormat:@"%@",number];
            
            NSDictionary *dicy = [responseObject objectForKey:@"data"];

            NSString *endtime = [dicy objectForKey:@"endtime"];
            NSString *title = [NSString stringWithFormat:@"截止时间:%@",endtime];
            [labsurveyendtime setText:title];
            
            //NSArray *dateArray = [dicy objectForKey:@"votelist"];
            NSArray * resultArray=[dicy[@"votelist"] convertToID];
            for (NSDictionary * dic in resultArray)
            {
                
                
                
                SurveyQuestionModel *model = [SurveyQuestionModel new];

                if ([type isEqualToString:@"1"]||[type isEqualToString:@"0"]) {
                     model.voteid = [dic objectForKey:@"voteid"];
                     model.votetitle = [dic objectForKey:@"votetitle"];
                     model.votestate = [dic objectForKey:@"votestate"];
                     model.votenumber = @"-1";
                     model.ranking = @"-1";
                     model.contentid = self.contentid;
                    if ([[dic objectForKey:@"votestate"] isEqualToString:@"1"]) {
                        model.optionrecordid = [dic objectForKey:@"optionrecordid"];
                    }else if ([[dic objectForKey:@"votestate"] isEqualToString:@"0"]){
                        model.optionrecordid = @"-1";
                    }
                }else{
                    model.voteid = [dic objectForKey:@"voteid"];
                    model.votetitle = [dic objectForKey:@"votetitle"];
                    model.votestate = @"-1";
                    model.votenumber = [dic objectForKey:@"votenumber"];
                    model.ranking = [dic objectForKey:@"ranking"];
                    model.contentid = self.contentid;
                    model.optionrecordid = @"-1";
                }
                [self.dateArray  addObject:model];
            }
            [tabSurveyQuestion reloadData];
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
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idc"];
    if (cell==nil) {
        cell = [[QuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"idc"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SurveyQuestionModel *model = self.dateArray[indexPath.section];
    NSString *srt = [NSString stringWithFormat:@"%ld",indexPath.section+1];
    
    cell.labQueNumber.text =  srt;
    cell.labQueTitle.text = model.votetitle;
    cell.labRelult.text = model.votenumber;
    if (![model.votenumber isEqualToString:@"-1"]) {
        if (indexPath.section==0) {
            cell.imgvOne.hidden = NO;
        }
    }
    
    if ([model.votestate isEqualToString:@"-1"]) {
        cell.btnQueAnswer.hidden = YES;
        cell.labRelult.hidden = NO;
    }else{
        cell.btnQueAnswer.hidden = NO;
        cell.labRelult.hidden = YES;
        if ([model.votestate isEqualToString:@"1"]) {
            [cell.btnQueAnswer setTitle:@"已投" forState:(UIControlStateNormal)];
        }else{
            [cell.btnQueAnswer setTitle:@"未投" forState:(UIControlStateNormal)];
        }
    }
    
    [cell.btnQueAnswer addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.btnQueAnswer.tag = indexPath.section;
    
    return cell;
}

- (void)btnClick:(UIButton *)sender{
    SurveyQuestionModel *model = self.dateArray[sender.tag];
    NSLog(@"%@",model.votetitle);
    
    if ([model.votestate isEqualToString:@"1"]) {//已投票
        [self surveyCancelVote:model.optionrecordid];
    }else{
        for (int i=0; i<self.dateArray.count; i++) {
            SurveyQuestionModel *model = self.dateArray[i];
            if ([model.votestate isEqualToString:@"1"]) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",@"只能选择一个答案"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
                [alert show];
                return;
            }
        }
        [self surveyVote:model.voteid];
    }
    
}

//提交投票
- (void)surveyVote:(NSString *) voteid{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"SurveyVote"];
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{@"userid": [userDefaults objectForKey:@"userid_CP"],
                                 @"contentid": self.contentid,
                                 @"voteid":voteid
                                 };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager POST:postUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"1000"]) {

            [self.dateArray removeAllObjects];
            [self loadDate];
            [tabSurveyQuestion reloadData];
            
            
            NSDictionary *dicy = [[responseObject objectForKey:@"data"] convertToID];
            NSString *endtime = [dicy objectForKey:@"time"];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"投票成功" message:[NSString stringWithFormat:@"%@",endtime] delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
            [alert show];
            //投票状态为1
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            myDelegate.pagerefresh = @"1";
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: ==============%@", error);
    }];
    
}

//取消投票
- (void)surveyCancelVote:(NSString *) optionrecordid{
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BaseWebServiceAddress,@"SurveyVoteCancel"];
    NSDictionary *parameters = @{@"voterecordid": optionrecordid
                                 };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager POST:postUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"1000"]) {
            [self.dateArray removeAllObjects];
            [self loadDate];
            [tabSurveyQuestion reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginState" object:@"0"];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",@"取消投票成功"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"好", nil];
            [alert show];
             //投票状态为0
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            myDelegate.pagerefresh = @"0";
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
