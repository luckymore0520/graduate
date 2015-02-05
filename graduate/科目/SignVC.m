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




- (IBAction)sign:(id)sender {
    
    NSArray* signList = [CoreDataHelper query:nil tableName:@"Sign"];
    for (Sign* sign in signList) {
        if ([sign.myDay isEqualToString:[NSString stringWithFormat:@"%d", [ToolUtils getCurrentDay].integerValue]]) {
            [ToolUtils showMessage:@"您今日已打卡"];
            return;
        }
    }
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    Sign* sign = (Sign*)[NSEntityDescription insertNewObjectForEntityForName:@"Sign" inManagedObjectContext:helper.managedObjectContext];
    sign.subject = self.subject;
    sign.myDay = [NSString stringWithFormat:@"%d", [ToolUtils getCurrentDay].integerValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:[NSDate date]];
    sign.date = destDateString;
    NSError* error;
    BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        [ToolUtils showMessage:@"打卡成功"];
    }

    [[[MSign alloc]init]load:self type:self.type subject:self.subject date:sign.date];
    
    
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
