//
//  ModifyPasswordViewController.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ModifyPasswordViewController.h"
#import "MUser.h"
#import "MPasswdChange.h"
#import "MReturn.h"
@interface ModifyPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (nonatomic,strong)MUser* user;
@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _user = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
    [self setTitle:@"设置密码"];
    [self addRightButton:@"保存" action:@selector(save:) img:nil];
    self.passwordField.layer.borderWidth = 1;
    self.passwordField.layer.borderColor = [UIColor colorOfBorder].CGColor;
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)save:(id)sender {
    if (_oldPasswordField.text.length==0) {
        [ToolUtils showMessage:@"请输入旧密码"];
        return;
    }
    if (_passwordField.text.length==0) {
        [ToolUtils showMessage:@"请输入新密码"];
        return;
    }
    if (!([_passwordField.text isEqualToString:_confirmPasswordField.text])) {
        [ToolUtils showMessage:@"两次密码输入不一致"];
        return;
    }
    [self waiting:@"正在保存"];
    [[[MPasswdChange alloc]init]load:self password:[ToolUtils md5:self.passwordField.text] nickname:_user.nickname_ sex:_user.sex_.integerValue oldPassword:[ToolUtils md5:_oldPasswordField.text]];
}

- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    [self waitingEnd];
    if ([names isEqualToString:@"MPasswdChange"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            [ToolUtils showMessage:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [ToolUtils showMessage:@"您输入的旧密码错误"];
        }
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
