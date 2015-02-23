//
//  BackUpViewController.m
//  graduate
//
//  Created by luck-mac on 15/2/20.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BackUpViewController.h"
#import "QuestionBook.h"
@interface BackUpViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIView *waveView;
@property (weak, nonatomic) IBOutlet UIButton *backUpButton;
@property (weak, nonatomic) IBOutlet UILabel *backUpingLabel;
@property(nonatomic)int total;
@property(nonatomic)int need;
@end

@implementation BackUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_backUpingLabel setHidden:YES];
    _progressView.layer.cornerRadius = 109;
    [_progressView setClipsToBounds:YES];
    // Do any additional setup after loading the view.
    QuestionBook* book = [QuestionBook getInstance];
    [book calculateNeedUpload];
    NSArray* allQuestions = book.allQuestions;
    _total = 0;
    for (NSArray* array in allQuestions) {
        _total = _total + array.count;
    }
    _need = book.needUpload;
    int hasBackUp = _total-_need;
    [_progressLabel setText:[NSString stringWithFormat:@"您已备份%d份笔记，还有%d份未备份",hasBackUp,_need]];
    [self setProgress:_total hasBackUp:hasBackUp];
    self.backUpButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.backUpButton.layer.borderWidth = 1;
    if (_need==0) {
        [self.backUpButton setTitle:@"完成备份" forState:UIControlStateNormal];
    } else {
         [self.backUpButton setTitle:@"开始备份" forState:UIControlStateNormal];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateProgress) name:@"backup" object:nil];
}


- (void)updateProgress
{
    QuestionBook* book = [QuestionBook getInstance];
    _need = book.needUpload;
    int hasBackUp = _total-_need;
    [_progressLabel setText:[NSString stringWithFormat:@"您已备份%d份笔记，还有%d份未备份",hasBackUp,_need]];
    [self setProgress:_total hasBackUp:hasBackUp];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)setProgress:(int)total hasBackUp:(int)hasBackUp
{
    
    int percent = hasBackUp/(total+0.0)*100;
    if (total==0) {
        percent = 100;
    }
    [_percentLabel setText:[NSString stringWithFormat:@"%d%@",percent,@"%"]];
    CGFloat offSet;
    offSet = (total-hasBackUp)/(total+0.0)* _progressView.frame.size.width;
    _waveView.transform = CGAffineTransformMakeTranslation(0, offSet);
    if (total==hasBackUp) {
        [ToolUtils setIgnoreNetwork:NO];
        [_backUpingLabel setHidden:YES];
        [_backUpButton setHidden:NO];
        [_progressLabel setHidden:NO];
        [self.backUpButton setTitle:@"完成备份" forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [ToolUtils setIgnoreNetwork:NO];
}


- (IBAction)backUp:(id)sender {
    if (_need==0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [_backUpButton setHidden:YES];
        [_progressLabel setHidden:YES];
        [_backUpingLabel setHidden:NO];
        [ToolUtils setIgnoreNetwork:YES];
        [[QuestionBook getInstance]updateQuestions];
    }
}
- (IBAction)goBack:(id)sender {
    if (!self.backUpingLabel.hidden) {
        [[[UIAlertView alloc]initWithTitle:@"放弃备份" message:@"您将要放弃备份，这可能使您的笔记不全而无法使用足迹打印等功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放弃", nil] show];

    } else {
        [self.navigationController popViewControllerAnimated:YES];

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
