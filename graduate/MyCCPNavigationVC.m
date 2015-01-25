//
//  MyCCPNavigationVC.m
//  graduate
//
//  Created by luck-mac on 15/1/18.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MyCCPNavigationVC.h"
#import "ToolUtils.h"
#define SERVER_IP @"sandboxapp.cloopen.com"
#define SERVER_PORT 8883


@interface MyCCPNavigationVC ()

@end

@implementation MyCCPNavigationVC

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    _ccpService = [[CCPCallService alloc]init];
//    [_ccpService setDelegate:self];
//    // Do any additional setup after loading the view.
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//-(void)connectToServer
//{
//    NSDictionary* subAccount = [ToolUtils getSubAccount];
//     [_ccpService connectToCCP:SERVER_IP onPort:SERVER_PORT withAccount:[subAccount objectForKey:@"voipAccount"] withPsw:[subAccount objectForKey:@"voipPwd"] withAccountSid:[subAccount objectForKey:@"subAccountSid"] withAuthToken:[subAccount objectForKey:@"subToken"]];
//}
//
//
//- (void)onConnected
//{
//    NSLog(@"Connect");
//}
//
//- (void)onConnectError:(NSInteger)reason withReasonMessge:(NSString *)reasonMessage
//{
//    NSLog(@"%@",reasonMessage);
//    
//}
//
//- (void)onSendInstanceMessageWithReason:(CloopenReason *)reason andMsg:(InstanceMsg *)data
//{
//    NSLog(@"%d",reason.reason);
//}
//- (void) onReceiveInstanceMessage:(InstanceMsg *)msg
//{
//    NSLog(@"________________________");
//    NSLog(@"%@",msg.description);
//    if ([msg isKindOfClass:[IMTextMsg class]])
//    {
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
