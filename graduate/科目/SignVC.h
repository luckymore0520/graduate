//
//  SignVC.h
//  graduate
//
//  Created by luck-mac on 15/2/4.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseFuncVC.h"

@interface SignVC : BaseFuncVC
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (nonatomic,strong)NSString* subject;
@property (nonatomic)NSInteger type;
@end
