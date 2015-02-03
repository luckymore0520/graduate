//
//  RegistVC.m
//  graduate
//
//  Created by luck-mac on 15/1/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "RegistVC.h"
#import "CodeVC.h"
#import "MReturn.h"
#import "MGetMobileVerify.h"
@interface RegistVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UIButton *nextBt;

@end

@implementation RegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFields = [NSArray arrayWithObjects:_phoneTextfield, nil];
    self.keyButtons = [NSArray arrayWithObjects:_nextBt, nil];
    [self.navigationController setNavigationBarHidden:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ButtonAction
- (IBAction)nextStep:(id)sender {
    
    if ([ToolUtils checkTel:self.phoneTextfield.text showAlert:YES]) {
        MGetMobileVerify* verify = [[MGetMobileVerify alloc]init];
        [verify load:self phone:self.phoneTextfield.text];
    }
//    
//    if ([ToolUtils checkTel:self.phoneTextfield.text]) {
//        [self performSegueWithIdentifier:@"code" sender:self.phoneTextfield.text];
//    }
}

#pragma mark -apiDelegate
- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MGetMobileVerify"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if ([ret.code_ integerValue]==1) {
            [self performSegueWithIdentifier:@"code" sender:self.phoneTextfield.text];
        } else {
            [ToolUtils showMessage:@"验证码发送失败，请重试"];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"code"]) {
        CodeVC* vc = (CodeVC*)[segue destinationViewController];
        vc.phoneNum = sender;
    }
}


@end
