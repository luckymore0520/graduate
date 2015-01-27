//
//  RegistVC.m
//  graduate
//
//  Created by luck-mac on 15/1/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "RegistVC.h"
#import "CodeVC.h"
@interface RegistVC ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UIButton *nextBt;

@end

@implementation RegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFields = [NSArray arrayWithObjects:_phoneTextfield, nil];
    self.keyButtons = [NSArray arrayWithObjects:_nextBt, nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ButtonAction
- (IBAction)nextStep:(id)sender {
    if ([ToolUtils checkTel:self.phoneTextfield.text]) {
        [self performSegueWithIdentifier:@"code" sender:self.phoneTextfield.text];
    }
#warning 此处调用发送验证码的接口
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
