//
//  ModifySubjectVC.h
//  graduate
//
//  Created by luck-mac on 15/2/1.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseFuncVC.h"
#import "ButtonGroup.h"
@interface ModifySubjectVC : BaseFuncVC<ButtonGroupDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet ButtonGroup *btGroup;
@property (weak, nonatomic) IBOutlet UIButton *firstBt;
@property (weak, nonatomic) IBOutlet UIButton *secondBt;
@property (weak, nonatomic) IBOutlet UIButton *thirdBt;
@property (weak, nonatomic) IBOutlet UIButton *fourthBt;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UITextField *majorField;
@property (nonatomic)NSInteger type;
@property (nonatomic,strong)NSString* subject;
@end
