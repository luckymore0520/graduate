//
//  SubjectVC.m
//  graduate
//
//  Created by luck-mac on 15/1/23.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SubjectVC.h"
#import "ToolUtils.h"
#import "MQuestionRecommand.h"
#import "RecommandVC.h"
#import "QuestionBook.h"
#import "MQuestionList.h"
#import "MUser.h"
#import "SubjectCell.h"
#import "Subject.h"
#import "MAOFlipViewController.h"
#import "SCNavigationController.h"
#import "MyQuestionVC.h"
#import "ModifySubjectVC.h"
#import "PostViewController.h"
#import "TraceRootVC.h"
#import "MQuesCountStatus.h"
#import "MQuestionCount.h"
@interface SubjectVC ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,SCNavigationControllerDelegate,SWTableViewCellDelegate>
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
//日记
@property (weak, nonatomic) IBOutlet UILabel *dailyNoteLabel;

//编辑日记的视图
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UITextView *editTextView;

//键盘消失按钮
@property (weak, nonatomic) IBOutlet UIButton *keyboardBt;


//选中的按钮（四个科目）
@property (nonatomic,weak  )UIButton* selectedBt;

@property (nonatomic,strong)NSArray* recommandList;
@property (nonatomic,strong)NSMutableArray* imgViewList;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong)NSMutableArray* subjects;

@property (nonatomic,copy)UIPanGestureRecognizer* recognizor;
@property (nonatomic)BOOL isPresenting;
@end

@implementation SubjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.editView removeFromSuperview];
#warning 此处需要获取用户昵称、今日日记以及各个科目的学习进度，科目封面
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([ToolUtils getFirstUse]) {
        [[[MQuestionRecommand alloc]init]load:self];
        [self initSubject];

    }
}

- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MQuesRecommend"]) {
        MQuestionList* list = [MQuestionList objectWithKeyValues:data];
        _recommandList = list.list_;
        _imgViewList = [[NSMutableArray alloc]init];
        for (MQuestion* question in _recommandList) {
            CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
            UIImageView* newImage = [[UIImageView alloc]initWithFrame:frame];
            [newImage sd_setImageWithURL:[ToolUtils getImageUrlWtihString:question.img_ width:self.view.frame.size.width height:0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"下载完成 宽%lf 长%lf",image.size.width,image.size.height);
            }];
            [_imgViewList addObject:newImage];
        }
    } else if ([names isEqualToString:@"MQuesCountStatus"])
    {
        MQuestionCount* count = [MQuestionCount objectWithKeyValues:data];
        for (Subject* subject in self.subjects) {
            switch (subject.type) {
                case 1:
                    subject.shoudUpdate = subject.total < count.engCount_.integerValue;
                    subject.total = subject.total>count.engCount_.integerValue?subject.total:count.engCount_.integerValue;
                    break;
                case 2:
                    subject.shoudUpdate = subject.total < count.polityCount_.integerValue;
                    subject.total = subject.total>count.polityCount_.integerValue?subject.total:count.polityCount_.integerValue;
                    break;
                case 3:
                    subject.shoudUpdate = subject.total < count.mathCount_.integerValue;
                    subject.total = subject.total>count.mathCount_.integerValue?subject.total:count.mathCount_.integerValue;
                    break;
                case 4:
                    subject.shoudUpdate = subject.total < count.major1Count_.integerValue;
                    subject.total = subject.total>count.major1Count_.integerValue?subject.total:count.major1Count_.integerValue;
                    break;
                case 5:
                    subject.shoudUpdate = subject.total < count.major2Count_.integerValue;
                    subject.total = subject.total>count.major2Count_.integerValue?subject.total:count.major2Count_.integerValue;
                    break;
                default:
                    break;
            }
        }
        [self.tableview reloadData];
    }
}

- (void)initSubject
{
    self.subjects =[NSMutableArray arrayWithArray:[[QuestionBook getInstance]getMySubjects] ];
    [self.tableview reloadData];
    [[[MQuesCountStatus alloc]init]load:self];
    
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

- (IBAction)recommand:(id)sender {
    [self performSegueWithIdentifier:@"recommand" sender:nil];
}

- (IBAction)goToMyTraces:(id)sender {
    TraceRootVC* root = [self.storyboard instantiateViewControllerWithIdentifier:@"traceRoot"];
    [self.navigationController pushViewController:root animated:YES];
}
- (IBAction)takePhoto:(id)sender {
    SCNavigationController *nav = [[SCNavigationController alloc] init];
    nav.scNaigationDelegate = self;
    [nav showCameraWithParentController:self];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"recommand"]) {
        RecommandVC* vc = (RecommandVC*)[segue destinationViewController];
        vc.questionList = [NSMutableArray arrayWithArray:self.recommandList];
    } else if ([segue.identifier isEqualToString:@"myQuestion"]) {
        MyQuestionVC* vc = (MyQuestionVC*)segue.destinationViewController;
        vc.type = ((Subject*)sender).type;
        vc.shoudUpdate = ((Subject*)sender).shoudUpdate;
    }  else if ([segue.identifier isEqualToString:@"english"]||
        [segue.identifier isEqualToString:@"math"]||
        [segue.identifier isEqualToString:@"major"]) {
        ModifySubjectVC* modify = (ModifySubjectVC*)segue.destinationViewController;
        Subject* subject = (Subject*)sender;
        modify.type = subject.type;
        modify.subject = subject.name;
    }
}


#pragma mark -SCCaptureDelegate
- (void)didTakePicture:(SCNavigationController *)navigationController image:(UIImage *)image {
    PostViewController *con = [[PostViewController alloc] init];
    con.postImage = image;
    [navigationController pushViewController:con animated:NO];
}

#pragma mark -tableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubjectCell* cell = (SubjectCell*)[tableView dequeueReusableCellWithIdentifier:@"subject"];
    
    if (indexPath.row==_subjects.count) {
        [cell.nameLabel setText:@"添加课程"];
        [cell.totalLabel setText:@"添加考试课程"];
        [cell.addLabel setText:@""];
    } else {
        
        
        Subject* subject = [_subjects objectAtIndex:indexPath.row];
        
        
        
        [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:100.0f];
        [cell.nameLabel setText:subject.name];
        [cell.totalLabel setText:[NSString stringWithFormat:@"%d篇",subject.total]];
       [cell.addLabel setText:[NSString stringWithFormat:@"%d篇新增",subject.newAdd]];
        
        cell.delegate = self;
    }
    return cell;
    
}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];

    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"重新编辑"];
    
    return rightUtilityButtons;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_subjects.count<4) {
        return 2;
    } else {
        return _subjects.count;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Subject* subject = [_subjects objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"myQuestion" sender:subject];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%lf",);
    if (scrollView.contentSize.height - scrollView.contentOffset.y<=110) {
        if (!_isPresenting) {
            _isPresenting = YES;
            UIViewController* controller = [self.parentVC.delegate flipViewController:self.parentVC contentIndex:2];
            UIView *sourceSnapshot = [controller.view snapshotViewAfterScreenUpdates:YES];
            CGRect frame = self.navigationController.view.frame;
            frame.origin.y = frame.origin.y+frame.size.height;
            
            [sourceSnapshot setFrame:frame];
            [self.navigationController.view addSubview:sourceSnapshot];
            [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                sourceSnapshot.transform = CGAffineTransformMakeTranslation(0, -sourceSnapshot.frame.size.height);
                
            } completion:^(BOOL finished) {
                [sourceSnapshot removeFromSuperview];
                [self.parentVC pushViewController:controller];
                _isPresenting = NO;
            }];
        }
    }

}


#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.tableview indexPathForCell:cell];
    Subject* subject = [_subjects objectAtIndex:cellIndexPath.row];
    
    
    
    switch (subject.type) {
        case 1:
            [self performSegueWithIdentifier:@"english" sender:subject];
            break;
        case 3:
        case 5:
            [self performSegueWithIdentifier:@"math" sender:subject];
            break;
        case 4:
            [self performSegueWithIdentifier:@"major" sender:subject];
            break;
        default:
            break;
    }
    
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    NSIndexPath *cellIndexPath = [self.tableview indexPathForCell:cell];
    if (cellIndexPath.row==_subjects.count) {
        return NO;
    }
    Subject* subject = [_subjects objectAtIndex:cellIndexPath.row];
    if ([subject.name isEqualToString:@"政治"]) {
        return NO;
    }
    return YES;
}



@end
