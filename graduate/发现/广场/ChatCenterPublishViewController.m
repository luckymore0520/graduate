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
#define HEIGHTOFLINE 18.5
@interface ChatCenterPublishViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *contentArea;

@end

@implementation ChatCenterPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentArea.layer.borderColor = [UIColor colorOfBorder].CGColor;
    self.contentArea.layer.borderWidth = 1;
    self.contentArea.delegate = self;
    self.titleField.layer.borderColor = [UIColor colorOfBorder].CGColor;
    self.titleField.layer.borderWidth = 1;
    [self addRightButton:@"发布" action:@selector(publish) img:nil];
    
    
    // Do any additional setup after loading the view.
}
- (IBAction)resignAll:(id)sender {
    [_titleField resignFirstResponder];
    [_contentArea resignFirstResponder];
    self.view.transform = CGAffineTransformMake(self.scale, 0, 0, self.scale, 0, 0);
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
    if (self.titleField.text.length > 20) {
        [ToolUtils showMessage:@"标题不得超过20字"];
        return;
    }
    if(![ToolUtils connectToInternet]){
        [ToolUtils showMessage:@"请确认您的网络是否连接正常"];
        return;
    }
    [self waiting:@"正在发布..."];
    [self resignAll:nil];
    [[[MPostPublish alloc]init]load:self content:self.contentArea.text title:self.titleField.text];
}

- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MPostPublish"]) {
        [self waitingEnd];
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            [ToolUtils showToast:@"发布成功" toView:self.navigationController.view];
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


- (void)textViewDidChange:(UITextView *)textView
{
    CGSize size = CGSizeMake(self.view.frame.size.width,2000);
    CGSize labelsize = [textView.text sizeWithFont:textView.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat offset = MIN(labelsize.height, textView.frame.size.height-200);
    self.view.transform = CGAffineTransformMake(self.scale, 0, 0, self.scale, 0, -offset+HEIGHTOFLINE);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resignAll:nil];
}
@end
