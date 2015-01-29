//
//  SetPasswordViewController.m
//  graduate
//
//  Created by luck-mac on 15/1/23.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SetPasswordViewController.h"
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

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFields = [NSArray arrayWithObjects:_setPasswordField,_comfirmPasswordField,_nickField, nil];
//    self.keyButtons = [NSArray arrayWithObjects:_completeButton,_maleButton,_femaleButton, nil];
    [self.setBtGroup loadButton:[NSArray arrayWithObjects:_maleButton,_femaleButton ,nil]];
    
    NSDictionary* dic = [ToolUtils getUserInfomation];
    if (dic) {
        self.user = [MUser objectWithKeyValues:dic];
        [self.nickField setText:_user.nickname_];
        [self.setBtGroup setSelectedIndex:self.user.sex_.integerValue];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


- (IBAction)complete:(id)sender {
    if (_setPasswordField.text.length==0) {
        [ToolUtils showMessage:@"密码不能为空"];
    } else if (![_setPasswordField.text isEqualToString:_comfirmPasswordField.text])
    {
        [ToolUtils showMessage:@"两次密码不一致"];
    } else if ([_nickField.text length]==0)
    {
        [ToolUtils showMessage:@"昵称不能为空"];
    } else {
        MPasswdChange* pc = [[MPasswdChange alloc]init];
        NSString* password = [ToolUtils md5:self.setPasswordField.text];
        [pc load:self password:password nickname:_nickField.text sex:[_setBtGroup selectedIndex]];
    }
}

#pragma mark -APiDelegate
- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MPasswdChange"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            UIStoryboard *myStoryBoard = [UIStoryboard storyboardWithName:@"Func" bundle:nil];
            RootViewController* _rootVC =(RootViewController*)[myStoryBoard instantiateViewControllerWithIdentifier:@"root"];
            [self.navigationController presentViewController:_rootVC animated:YES completion:^{
            }];
        } else {
            [ToolUtils showMessage:ret.msg_];
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
