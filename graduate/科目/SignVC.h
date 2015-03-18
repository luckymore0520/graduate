//
//  SignVC.h
//  graduate
//
//  Created by luck-mac on 15/2/4.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseFuncVC.h"
#import "Sign.h"
#import "ShareApiUtil.h"
@interface SignVC : BaseFuncVC
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (nonatomic,assign)NSInteger reviewCount;
@property (nonatomic,strong)NSString* subject;
@property (nonatomic)NSInteger type;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (nonatomic,strong) Sign* sign;
@property (weak, nonatomic) IBOutlet UIView *maskBackView;
@property (strong,nonatomic)NSString *sharedUrl;

@end
