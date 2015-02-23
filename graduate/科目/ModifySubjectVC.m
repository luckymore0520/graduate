//
//  ModifySubjectVC.m
//  graduate
//
//  Created by luck-mac on 15/2/1.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ModifySubjectVC.h"
#import "MUser.h"
@implementation ModifySubjectVC
- (IBAction)save:(id)sender {
    
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"确认修改课程" message:@"原有笔记会存在" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
   
}

- (void)initViews
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initGroup];
    self.textFields = [NSArray arrayWithObjects:_majorField, nil];
    if (self.majorField) {
        self.majorField.inputAccessoryView = [self getAccessoryView];
    }
}

- (UIView*)getAccessoryView
{
    UIView* accessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 60)];
    UIButton* button = [[UIButton alloc]initWithFrame:accessoryView.frame];
    [button addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:_submitButton.titleLabel.font];
    [button setBackgroundImage:[UIImage imageNamed:@"保存按钮"] forState:UIControlStateNormal];
    [accessoryView addSubview:button];
    return accessoryView;
}

//初始化ButtonGroup
- (void)initGroup
{
    _btGroup.delegate = self;
    switch (self.type) {
        case 1:
            [_btGroup loadButton:[NSArray arrayWithObjects:_firstBt,_secondBt,_thirdBt, nil]];
            [_btGroup setSelectContent:self.subject];
            break;
        case 3:
        case 5:
            [_btGroup loadButton:[NSArray arrayWithObjects:_firstBt,_secondBt,_thirdBt,_fourthBt, nil]];
            [_btGroup setSelectContent:self.subject];
            
            if ([_btGroup selectedIndex]==3) {
                [_majorField setHidden:NO];
                [_majorLabel setHidden:NO];
                [_majorLine setHidden:NO];
                if (self.type==5) {
                    [_majorField setText:self.subject];
                }
            }
        case 4:
            [_majorField setText:self.subject];
        default:
            break;
    }
}

- (void)selectIndex:(NSInteger)index name:(NSString *)buttonName
{
    if (self.type==3||self.type==5) {
        if (index==3) {
            [_majorField setHidden:NO];
            [_majorLabel setHidden:NO];
            [_majorLine setHidden:NO];
        } else {
            [_majorField setHidden:YES];
            [_majorLabel setHidden:YES];
            [_majorLine setHidden:YES];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        NSDictionary* userDic = [ToolUtils getUserInfomation];
        MUser *user = [MUser objectWithKeyValues:userDic];
        
        switch (self.type) {
            case 1:
                user.subjectEng_ = [_btGroup selectedSubject];
                
                
                break;
            case 3:
            case 5:
                if ([_btGroup selectedIndex]==3) {
                    user.subjectMajor2_ = _majorField.text;
                    user.subjectMath_=@"";
                } else {
                    user.subjectMath_ = [_btGroup selectedSubject];
                    user.subjectMajor2_ = @"";
                }
                break;
            case 4:
                user.subjectMajor1_ = _majorField.text;
                break;
            default:
                break;
        }
        
        [ToolUtils setUserInfomation:user.keyValues];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
