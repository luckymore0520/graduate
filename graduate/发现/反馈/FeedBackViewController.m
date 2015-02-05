//
//  FeedBackViewController.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "FeedBackViewController.h"
#import "MFeedback.h"
#import "MReturn.h"
@interface FeedBackViewController ()<UITextViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *submitBt;
@property (weak, nonatomic) IBOutlet UITextView *textArea;
@property (weak, nonatomic) IBOutlet UITextField *contactField;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textArea.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    self.textArea.layer.borderWidth = 1;
    self.textArea.layer.cornerRadius = 10;
    self.textArea.delegate = self;
    
    self.textFields = [NSArray arrayWithObjects:self.contactField, nil];
    self.keyButtons = [NSArray arrayWithObjects:self.submitBt, nil];
    // Do any additional setup after loading the view.
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.textArea.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            self.placeholder.hidden=NO;//隐藏文字
        }else{
            self.placeholder.hidden=YES;
        }
    }else{//textview长度不为0
        if (self.textArea.text.length==1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                self.placeholder.hidden=NO;
            }else{//不是删除
                self.placeholder.hidden=YES;
            }
        }else{//长度不为1时候
            self.placeholder.hidden=YES;
        }
    }
    return YES;
}
- (IBAction)resignAll:(id)sender {
    [self.textArea resignFirstResponder];
}

- (IBAction)submit:(id)sender {
    if (self.textArea.text.length+self.contactField.text.length==0) {
        [ToolUtils showMessage:@"不能提交空的内容哟！"];
        return;
    }
    
    [[[MFeedback alloc]init]load:self content:self.textArea.text contact:self.contactField.text];
    
    
}

- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MFeedback"]) {
//        MReturn* ret = [MReturn objectWithKeyValues:data];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"谢谢" message:@"我们很重视您的意见，您的意见是我们前进的动力。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
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
