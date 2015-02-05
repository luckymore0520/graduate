//
//  ChatCenterPublishViewController.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ChatCenterPublishViewController.h"
#import "MPostPublish.h"
#import "MReturn.h"
@interface ChatCenterPublishViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *contentArea;

@end

@implementation ChatCenterPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentArea.layer.borderColor = [UIColor blackColor].CGColor;
    self.contentArea.layer.borderWidth = 1;
    self.titleField.layer.borderColor = [UIColor blackColor].CGColor;
    self.titleField.layer.borderWidth = 1;
    [self addRightButton:@"发布" action:@selector(publish) img:nil];
    
    
    // Do any additional setup after loading the view.
}

- (void)publish
{
    if (self.titleField.text.length==0) {
        [ToolUtils showMessage:@"标题不能为空"];
        return;
    }
    if (self.contentArea.text.length==0) {
        [ToolUtils showMessage:@"内容不能为空"];
        return;
    }
    
    [[[MPostPublish alloc]init]load:self content:self.contentArea.text title:self.titleField.text];
    
}

- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MPostPublish"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            [ToolUtils showToast:@"发布成功" toView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [ToolUtils showMessage:@"发布失败，请重试"];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
