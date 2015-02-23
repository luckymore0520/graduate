//
//  SignVC.m
//  graduate
//
//  Created by luck-mac on 15/2/4.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SignVC.h"
#import "Sign.h"
#import "CoreDataHelper.h"
#import "MSign.h"
#import "MReturn.h"


@implementation SignVC

- (void)viewDidLoad
{
    NSArray* signList = [CoreDataHelper query:nil tableName:@"Sign"];
    int days = signList.count+1;
    for (Sign* sign in signList) {
        if ([sign.myDay isEqualToString:[NSString stringWithFormat:@"%d", [ToolUtils getCurrentDay].integerValue]]) {
            [_signButton setTitle:@"回到主页" forState:UIControlStateNormal];
            days = days-1;
            break;
        }
    }
    [_dayLabel setText:[NSString stringWithFormat:@"%d天",days]];
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"返回主页"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *myAddButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = myAddButton;
}

- (void)backToMain
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)onSignSuccess
{
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    NSArray* signList = [CoreDataHelper query:nil tableName:@"Sign"];
    for (Sign* sign in signList) {
        if ([sign.myDay isEqualToString:[NSString stringWithFormat:@"%d", [ToolUtils getCurrentDay].integerValue]]) {
            sign.reviewCount = [NSNumber numberWithInteger:sign.reviewCount.integerValue+self.reviewCount];
            NSError* error;
            [helper.managedObjectContext save:&error];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    Sign* sign = (Sign*)[NSEntityDescription insertNewObjectForEntityForName:@"Sign" inManagedObjectContext:helper.managedObjectContext];
    sign.subject = self.subject;
    sign.myDay = [NSString stringWithFormat:@"%d", [ToolUtils getCurrentDay].integerValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
    sign.date = destDateString;
    sign.reviewCount = [NSNumber numberWithInteger:self.reviewCount];
    NSError* error;
    BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        [ToolUtils showMessage:@"打卡成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    [[[MSign alloc]init]load:self type:self.type subject:self.subject date:sign.date];
}
- (IBAction)sign:(id)sender {
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    NSArray* signList = [CoreDataHelper query:nil tableName:@"Sign"];
    for (Sign* sign in signList) {
        if ([sign.myDay isEqualToString:[NSString stringWithFormat:@"%d", [ToolUtils getCurrentDay].integerValue]]) {
            sign.reviewCount = [NSNumber numberWithInteger:sign.reviewCount.integerValue+self.reviewCount];
            NSError* error;
            [helper.managedObjectContext save:&error];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    [self.maskBackView setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.transform = CGAffineTransformMakeTranslation(0, -self.shareView.frame.size.height);
    }];
    
    
    
}

- (IBAction)cancelShare:(id)sender {
    [self.maskBackView setHidden:YES];
    [self onSignSuccess];
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.transform = CGAffineTransformMakeTranslation(0,0);
    }];
}


- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    
    if ([names isEqualToString:@"MSign"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            NSLog(@"打卡,同步服务器成功");
        }
    }
    
}
@end
