//
//  SetPasswordViewController.m
//  graduate
//
//  Created by luck-mac on 15/1/23.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "WKNavigationViewController.h"
#import "RootViewController.h"
#import "ButtonGroup.h"
#import "MPasswdChange.h"
#import "MUser.h"
#import "MReturn.h"
@interface SetPasswordViewController ()
@property (nonatomic,strong) MUser* user;
@property (weak, nonatomic) IBOutlet UITextField *setPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *comfirmPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *nickField;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet ButtonGroup *setBtGroup;
@property (weak, nonatomic) IBOutlet UILabel *passwordBack;
@property (weak, nonatomic) IBOutlet UILabel *confirmPasswordBack;
@property (weak, nonatomic) IBOutlet UILabel *nickNameBack;
@property (weak, nonatomic) IBOutlet UILabel *selectSexLabel;
@property (weak, nonatomic) IBOutlet UIButton *completeBt;

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"账号设置"];
    self.textFields = [NSArray arrayWithObjects:_setPasswordField,_comfirmPasswordField,_nickField, nil];
    self.keyButtons = [NSArray arrayWithObjects:_completeButton,_maleButton,_femaleButton, nil];
    [self.setBtGroup loadButton:[NSArray arrayWithObjects:_maleButton,_femaleButton ,nil]];
    
    NSDictionary* dic = [ToolUtils getUserInfomation];
    if (dic) {
        self.user = [MUser objectWithKeyValues:dic];
        [self.nickField setText:_user.nickname_];
        [self.setBtGroup setSelectedIndex:self.user.sex_.integerValue];
    }
    
    [self adjustView];
    
    // Do any additional setup after loading the view.
}

- (void)adjustView
{
    
    if (self.isReset) {
        [self.selectSexLabel setHidden:YES];
        self.nickNameBack.hidden = YES;
        self.nickField.hidden = YES;
        self.setBtGroup.hidden = YES;
        self.completeBt.transform = CGAffineTransformMakeTranslation(0, -130);
    }
    
    
    _passwordBack.layer.borderColor =    [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:0.5].CGColor;
    _passwordBack.layer.borderWidth = 1;

    _confirmPasswordBack.layer.borderColor =    [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    _confirmPasswordBack.layer.borderWidth = 1;
    
    _nickNameBack.layer.borderColor =    [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:0.5].CGColor;
    _nickNameBack.layer.borderWidth = 1;
    
    _setBtGroup.layer.borderColor =    [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:0.5].CGColor;
    _setBtGroup.layer.borderWidth = 1;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


- (IBAction)complete:(id)sender {
    if (_setPasswordField.text.length==0) {
        [ToolUtils showMessage:@"请输入完整信息，完成账号设置" title:@"账号未能设置"];
    } else if (![_setPasswordField.text isEqualToString:_comfirmPasswordField.text])
    {
        [ToolUtils showMessage:@"两次输入密码不同，请重新输入" title:@"密码不一样"];
    } else if ([_nickField.text length]==0)
    {
        [ToolUtils showMessage:@"请输入完整信息，完成账号设置" title:@"账号未能设置"];
    } else {
        [self waiting:@"正在注册..."];
        MPasswdChange* pc = [[MPasswdChange alloc]init];
        NSString* password = [ToolUtils md5:self.setPasswordField.text];
        if (self.isReset) {
            [pc load:self password:password nickname:nil sex:-1];

        } else {
            [pc load:self password:password nickname:_nickField.text sex:[_setBtGroup selectedIndex]];

        }
    }
}

#pragma mark -APiDelegate
- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MPasswdChange"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            [ToolUtils setHasLogin:YES];
            [self waitingEnd];
            UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"Func" bundle:nil];
            RootViewController* _rootVC =(RootViewController*)[myStoryBoard instantiateViewControllerWithIdentifier:@"root"];
            [self.navigationController presentViewController:_rootVC animated:YES completion:^{
            }];
        } else {
            [ToolUtils showMessage:ret.msg_];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.setPasswordField) {
        [self.comfirmPasswordField becomeFirstResponder];
    } else if (textField==self.comfirmPasswordField)
    {
        [self.nickField becomeFirstResponder];
    } else {
        return [super textFieldShouldReturn:textField];
    }
    return YES;
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
