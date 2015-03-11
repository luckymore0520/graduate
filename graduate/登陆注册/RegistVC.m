//
//  RegistVC.m
//  graduate
//
//  Created by luck-mac on 15/1/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "RegistVC.h"
#import "MReturn.h"
#import "MGetMobileVerify.h"
#import "MUser.h"
#import "MRegister.h"
#import "SetPasswordViewController.h"
@interface RegistVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UIButton *nextBt;
@property (weak, nonatomic) IBOutlet UITextField *codeField;

@property (weak, nonatomic) IBOutlet UILabel *timeBt;
@property (weak, nonatomic) IBOutlet UILabel *phoneBackView;
@property (weak, nonatomic) IBOutlet UILabel *codeBackView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@end

@implementation RegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == REGIST) {
        [self setTitle:@"注册"];

    } else {
        [self setTitle:@"找回密码"];
    }
    self.textFields = [NSArray arrayWithObjects:_phoneTextfield,_codeField, nil];
    self.keyButtons = [NSArray arrayWithObjects:_nextBt,_timeButton,_timeBt, nil];
    [self.navigationController setNavigationBarHidden:NO];
    
    _codeBackView.layer.borderColor =    [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    _codeBackView.layer.borderWidth = 1;
    _phoneBackView.layer.borderColor =
    [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    _phoneBackView.layer.borderWidth = 1;
    
    
    
}

- (void) adjustView
{
    
}
#pragma mark ButtonAction
- (IBAction)repeat:(id)sender {
    if([ToolUtils checkTel:self.phoneTextfield.text showAlert:NO])
    {
        [self.codeField becomeFirstResponder];
        [self startTime];
        //    if ([self.timeBt.text isEqualToString:@"重发"]) {
        MGetMobileVerify* verify = [[MGetMobileVerify alloc]init];
        [verify load:self phone:self.phoneTextfield.text];
        //    }
        [self.timeButton setEnabled:NO];
        [self.timeBt setTextColor:[UIColor blackColor]];

    } else {
        [ToolUtils showMessage:@"请输入正确的手机号接受短信验证" title:@"手机号错误"];
    }
   
}

//计时器
-(void)startTime{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.timeBt setText:@"重发"];
                [self.timeButton setEnabled:YES];
                [self.timeBt setTextColor:[UIColor whiteColor]];

            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [self.timeBt setText:[NSString stringWithFormat:@"%@秒后重新发送",strTime]];
                [self.timeButton setEnabled: NO];
                [self.timeBt setTextColor:[UIColor blackColor]];

            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ButtonAction
- (IBAction)nextStep:(id)sender {
    
    if (self.phoneTextfield.text.length==0) {
        [ToolUtils showMessage:@"请输入手机号"];
        return;
    }
    if (self.codeField.text.length==0) {
        [ToolUtils showMessage:@"请输入验证码"];
        return;
    }
    [self waiting:@"正在验证..."];
    MRegister* reg = [[MRegister alloc]init];
    [reg load:self phone:self.phoneTextfield.text code:self.codeField.text];
}

#pragma mark -apiDelegate
- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MGetMobileVerify"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if ([ret.code_ integerValue]==1) {
            [ToolUtils showToast:@"验证码已发送" toView:self.view];
//            [ToolUtils showMessage:@"验证码已发送"];
        } else {
            [ToolUtils showMessage:@"验证码发送失败，请重试"];
        }
    }  else if ([names isEqualToString:@"MRegister"])
    {
        [self waitingEnd];
        MUser* user = [MUser objectWithKeyValues:data];
        if (user.nickname_&&user.nickname_.length>0) {
            self.type = FORGET;
            [ToolUtils showMessage:@"该手机号已注册，你可以直接修改密码"];
        }
        [ToolUtils setUserInfomation:user.keyValues];
        [self performSegueWithIdentifier:@"setDetail" sender:nil];
    }

}

- (void)showAlert:(NSString *)alert functionName:(NSString *)names
{
    [self waitingEnd];
    if ([names isEqualToString:@"MRegister"]) {
        NSLog(@"alert:%@",alert);
        [ToolUtils showMessage:@"请仔细核对验证码,重新输入" title:@"验证码错误"];
    }
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==_phoneTextfield) {
        [self.timeButton setEnabled:YES];
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.phoneTextfield) {
        return [super textFieldShouldReturn:textField];
    } else {
        [self nextStep:nil];
        return [super textFieldShouldReturn:textField];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setDetail"]) {
        SetPasswordViewController* nextVC = segue.destinationViewController;
        if (self.type == REGIST) {
            nextVC.isReset = NO;
        } else {
            nextVC.isReset = YES;
        }
    }
}


@end
