//
//  SubjectVC.m
//  graduate
//
//  Created by luck-mac on 15/1/23.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SubjectVC.h"
#import "ToolUtils.h"
#import "YZSwipeBetweenViewController.h"
@interface SubjectVC ()<UIActionSheetDelegate>
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
//日记
@property (weak, nonatomic) IBOutlet UILabel *dailyNoteLabel;

//编辑日记的视图
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UITextView *editTextView;

//键盘消失按钮
@property (weak, nonatomic) IBOutlet UIButton *keyboardBt;

//各科目按钮
@property (weak, nonatomic) IBOutlet UIButton *englishBt;
@property (weak, nonatomic) IBOutlet UIButton *majorBt;
@property (weak, nonatomic) IBOutlet UIButton *politicBt;
@property (weak, nonatomic) IBOutlet UIButton *mathBt;



@property (weak, nonatomic) IBOutlet UIView *testView;

//选中的按钮（四个科目）
@property (nonatomic,weak  )UIButton* selectedBt;

@property (nonatomic,strong)YZSwipeBetweenViewController* traceRoot;
@end

#warning 该页面需要注意添加科目的按钮之后是用来拍照的，等拍照正式方案确定后再加
@implementation SubjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.editView removeFromSuperview];
#warning 此处需要获取用户昵称、今日日记以及各个科目的学习进度，科目封面
}


- (IBAction)buttonTouchDown:(UIButton *)sender {
     [self performSelector:@selector(btLongPress:) withObject:sender afterDelay:1.0];
}
- (IBAction)buttonTouchUpInside:(UIButton*)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(btLongPress:)
                                    object:sender];
    [self performSegueWithIdentifier:@"myQuestion" sender:nil];
}
- (IBAction)buttonTouchOutside:(UIButton*)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(btLongPress:)
                                               object:sender];
}

- (IBAction)resignAll:(id)sender {
    [self.keyboardBt setHidden:YES];
    [self.editTextView resignFirstResponder];
    [self.editView setHidden:YES];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.editView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}



- (IBAction)startEdit:(id)sender {
    CGRect frame = self.editView.frame;
    
    //    [self.editView removeFromSuperview];
    
    //    [self.editView setFrame:frame];
    //    [self.view addSubview:self.editView];
    [self.editView setHidden:NO];
    [self.editTextView becomeFirstResponder];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        NSLog(@"%lf",-frame.size.height-(keyboardHeight==0?240:keyboardHeight));
        self.editView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height-(keyboardHeight==0?240:keyboardHeight));
    } completion:^(BOOL finished) {
        [self.keyboardBt setHidden:NO];
    }];
    
    
}
- (IBAction)save:(id)sender {
    
    
    
}


- (IBAction)setSubject:(id)sender {
    if ([ToolUtils getMySubjects]) {
        [ToolUtils showMessage:@"科目已设置"];
        return;
    }
    [self performSegueWithIdentifier:@"setSubject" sender:nil];
}


- (IBAction)goToMyTraces:(id)sender {
    self.traceRoot = [YZSwipeBetweenViewController new];
    [self presentViewController:self.traceRoot animated:YES completion:^{
        
    }];
}


- (void)btLongPress:(UIButton*)button
{
    self.selectedBt = button;
    UIActionSheet*  sheet;
    if (button==_englishBt) {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"英语一",@"英语二",@"英语三", nil];
    } else if (button==_mathBt)
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"数学一",@"数学二",@"数学三", nil];
    } else if (button== _majorBt)
    {
        
    }
    [sheet showInView:self.view];
}




#pragma mark actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"您选择了%@", [actionSheet buttonTitleAtIndex:buttonIndex]);
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
