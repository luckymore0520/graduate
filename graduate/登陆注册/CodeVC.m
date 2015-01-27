//
//  CodeVC.m
//  graduate
//
//  Created by luck-mac on 15/1/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "CodeVC.h"

@interface CodeVC ()
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeBt;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (weak, nonatomic) IBOutlet UIButton *nextBt;

@end

@implementation CodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFields = [NSArray arrayWithObjects:_codeField, nil];
    [_phoneNumLabel setText:_phoneNum];
    self.keyButtons = [NSArray arrayWithObjects:_nextBt,_timeButton, nil];
    [self startTime];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ButtonAction
- (IBAction)repeat:(id)sender {
    [self startTime];
    if ([self.timeBt.text isEqualToString:@"重发"]) {
        [ToolUtils showMessage:@"验证码已发送"];
    }
#warning 此处调用重发验证码的接口

}

- (IBAction)nextStep:(id)sender {
    if (_codeField.text.length==0) {
        [ToolUtils showMessage:@"验证码不能为空"];
    }
#warning 此处调用验证验证码的接口
    else {
         [self performSegueWithIdentifier:@"setDetail" sender:nil];
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
                self.timeBt.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [self.timeBt setText:[NSString stringWithFormat:@"%@秒后重新发送",strTime]];
                self.timeBt.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
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
