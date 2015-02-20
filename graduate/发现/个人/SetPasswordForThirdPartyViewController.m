//
//  SetPasswordForThirdPartyViewController.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SetPasswordForThirdPartyViewController.h"
#import "SelfOtherCell.h"
#import "MUser.h"
#import "MPasswdChange.h"
#import "MReturn.h"
@interface SetPasswordForThirdPartyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)MUser* user;
@property (nonatomic,strong)UITextField* passwordField;
@property (nonatomic,strong)UITextField* confirmPasswordField;
@end

@implementation SetPasswordForThirdPartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _user = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
    [self addRightButton:@"保存" action:@selector(save:) img:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)save:(id)sender {
    if (self.passwordField.text.length==0) {
        [ToolUtils showMessage:@"请输入密码"];
        return;
    }
    if (![self.passwordField.text isEqualToString:self.confirmPasswordField.text]) {
        [ToolUtils showMessage:@"两次密码输入不一致"];
        return;
    }
    
    _user.hasPassword_ = [NSNumber numberWithInt:1];
    [ToolUtils setUserInfomation:_user.keyValues];
    [[[MPasswdChange alloc]init]load:self password:[ToolUtils md5:self.passwordField.text] nickname:_user.nickname_ sex:_user.sex_.integerValue];
    
    
    
}


- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MPasswdChange"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [ToolUtils showMessage:@"修改失败，请重试"];
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

#pragma mark -TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelfOtherCell* cell = [tableView dequeueReusableCellWithIdentifier:@"password"];
    if (indexPath.row==0) {
        cell.passwordField.placeholder = _user.account_;
        [cell.passwordField setEnabled:NO];
    }
    if (indexPath.row==1) {
        cell.passwordField.placeholder = @"请设置研大大密码";
        [cell.cellNameLabel setText:@"密码"];
        [cell.cellNameLabel setTextColor:[UIColor colorWithHex:0x333333]];
        self.passwordField = cell.passwordField;
        cell.layer.borderColor = [UIColor colorOfBorder].CGColor;
        cell.layer.borderWidth = 1;
        self.passwordField.delegate = self;
    }
    if (indexPath.row==2) {
        cell.passwordField.placeholder = @"请再次输入";
        self.confirmPasswordField = cell.passwordField;
        [cell.cellNameLabel setText:@"确认密码"];
        [cell.cellNameLabel setTextColor:[UIColor colorWithHex:0x333333]];
        self.confirmPasswordField.delegate = self;
    }
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
@end
