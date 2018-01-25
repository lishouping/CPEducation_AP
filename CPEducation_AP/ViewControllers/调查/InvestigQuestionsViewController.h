//
//  InvestigQuestionsViewController.h
//  CPEducation_AP
//
//  Created by lishouping on 2017/6/30.
//  Copyright © 2017年 李寿平. All rights reserved.
//

#import "RootViewController.h"
//代理
//@protocol investigQuestionsViewDelegate <NSObject>
//
//-(void)pass:(NSString*)Volue;



//
//@end
@interface InvestigQuestionsViewController : RootViewController
@property(nonatomic,strong)NSString *contentid;
//用于通知刷新
//@property(nonatomic,strong)NSString *refresh;

//@property(nonatomic,weak)id<investigQuestionsViewDelegate> delegate;  //声明代理
@property (nonatomic,strong)NSString *refresh;
@end
