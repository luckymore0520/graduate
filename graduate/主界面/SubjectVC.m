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
#import "MUser.h"
#import "CoreDataHelper.h"
#import "Trace.h"
#import "UIPlaceHolderTextView.h"
@interface SubjectVC ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,SCNavigationControllerDelegate,SWTableViewCellDelegate>
//昵称
@property (weak, nonatomic) IBOutlet UIImageView *rollImage;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
//日记
@property (weak, nonatomic) IBOutlet UILabel *dailyNoteLabel;

//编辑日记的视图
@property (strong, nonatomic)  UIView *editView;
@property (strong, nonatomic)  UIPlaceHolderTextView *editTextView;

//键盘消失按钮
@property (weak, nonatomic) IBOutlet UIButton *keyboardBt;

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundViw;

//选中的按钮（四个科目）
@property (nonatomic,weak  )UIButton* selectedBt;

@property (nonatomic,strong)NSArray* recommandList;
@property (nonatomic,strong)NSMutableArray* imgViewList;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong)NSMutableArray* subjects;

@property (nonatomic,copy)UIPanGestureRecognizer* recognizor;
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNewLabel;
@property (nonatomic)BOOL isPresenting;
@property (nonatomic)BOOL firstOpen;
@property (nonatomic,strong)NSArray* subjectImgList;
@property (weak, nonatomic) IBOutlet UIView *centerLine;

@end
CGFloat angle;
@implementation SubjectVC

- (void)viewDidLoad {
    if (self.view.frame.size.height>500) {
        [self.tableview setScrollEnabled:NO];
    }
    [super viewDidLoad];
    [self.editView removeFromSuperview];
    self.headView.layer.cornerRadius = 42;
    [self.headView setClipsToBounds:YES];
    
    self.headView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headView.layer.borderWidth = 3;
    _subjectImgList  = [NSArray arrayWithObjects:@"英语",@"政治",@"数学",@"专业课一",@"专业课二", nil];
    self.firstOpen = YES;
    [self reloadData];
    [self.view bringSubviewToFront:self.centerLine];


}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void) startAnimation
{
    if (angle>360) {
        return;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.005];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.rollImage.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

-(void)endAnimation
{
    angle += 10;
    [self startAnimation];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    angle = 0;

    [self startAnimation];
    if (self.firstOpen) {
        self.firstOpen = NO;
    } else {
        [self reloadData];
    }
}

- (void)reloadData
{
    [[[MQuestionRecommand alloc]init]load:self];
    MUser* user = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
    [self.headView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:user.headImg_ width:164 height:164] placeholderImage:[UIImage imageNamed:user.sex_.integerValue==0?@"原始头像男":@"原始头像女"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    NSArray* array = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"myDay=%@ and user=%@",[NSString stringWithFormat:@"%d",[ToolUtils getCurrentDay].intValue],[ToolUtils getUserid]] tableName:@"Trace"];
    if (array.count>0) {
        Trace* trace = [array firstObject];
        [_backgroundViw sd_setImageWithURL:[ToolUtils getImageUrlWtihString:trace.pictureUrlForSubject width:self.view.frame.size.width*2 height:0] placeholderImage:nil];
        [self.dailyNoteLabel setText:trace.note];
        if (trace.note.length<23) {
            self.dailyNoteLabel.textAlignment = NSTextAlignmentCenter;
        } else {
            self.dailyNoteLabel.textAlignment = NSTextAlignmentLeft;
            
        }
    }
    [self.nickNameLabel setText:user.nickname_];
    [self initSubject];
}


- (void)calculateTotal
{
    int total = 0;
    int totalNew = 0;
    for (Subject* subject in self.subjects) {
        total+=subject.total;
        totalNew+=subject.newAdd;
    }
    [self.totalLabel setText:[NSString stringWithFormat:@"%d",total]];
    [self.totalNewLabel setText:[NSString stringWithFormat:@"%d",totalNew]];
    
    NSArray* signList = [CoreDataHelper query:nil tableName:@"Sign"];

    [self.cardLabel setText:[NSString stringWithFormat:@"%d",signList.count]];

    
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
        int total = 0;
        for (Subject* subject in self.subjects) {
            total+=subject.total;
        }
        
        if (total<count.totoalCount_.integerValue) {
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
        }
        
        
        
        [self calculateTotal];
        [self.tableview reloadData];
    }
}

- (void)showError:(NSError *)error functionName:(NSString *)names
{
    if ([names isEqualToString:@"MQuesCountStatus"]) {
        [self calculateTotal];
        [self.tableview reloadData];
    }
}

- (void)initSubject
{
    self.subjects =[NSMutableArray arrayWithArray:[[QuestionBook getInstance]getMySubjects] ];
//    [self.tableview reloadData];
    [[[MQuesCountStatus alloc]init]load:self];
//    [self calculateTotal];
    
}





- (IBAction)startEdit:(id)sender {
    [self editRemark];
}


- (IBAction)recommand:(id)sender {
    if (self.subjects.count<4) {
        [self performSegueWithIdentifier:@"editSubject" sender:nil];

    } else {
        [self performSegueWithIdentifier:@"recommand" sender:nil];

    }
}

- (IBAction)goToMyTraces:(id)sender {
    TraceRootVC* root = [self.storyboard instantiateViewControllerWithIdentifier:@"traceRoot"];
    BOOL shoudUpdate = NO;
    for (Subject* subject in self.subjects) {
        if (subject.shoudUpdate) {
            shoudUpdate = YES;
        }
    }
    root.shoudUpdate = shoudUpdate;
    [self.navigationController pushViewController:root animated:YES];
}

- (IBAction)takePhoto:(id)sender {
    if (self.subjects.count<4) {
        [self performSegueWithIdentifier:@"editSubject" sender:nil];

    } else {
        SCNavigationController *nav = [[SCNavigationController alloc] init];
        nav.scNaigationDelegate = self;
        [nav showCameraWithParentController:self];
    }
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
        vc.subject = ((Subject*)sender).name;
        
        
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
        [cell.imgView setImage:[UIImage imageNamed:@"添加课程"]];
    } else {
        Subject* subject = [_subjects objectAtIndex:indexPath.row];
        [cell.imgView setImage:[UIImage imageNamed:[self.subjectImgList objectAtIndex:subject.type-1]]];
        [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:100.0f];
        [cell.nameLabel setText:subject.name];
        [cell.totalLabel setText:[NSString stringWithFormat:@"%d篇/",subject.total]];
       [cell.addLabel setText:[NSString stringWithFormat:@"%d篇新增",subject.newAdd]];
        
        cell.delegate = self;
        if (self.subjects.count<4) {
            [cell.totalLabel setHidden:YES];
            [cell.addLabel setHidden:YES];
            
        }
    }
    return cell;
    
}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];

    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"编辑课程"];
    
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
    
    if (self.subjects.count==4) {
        Subject* subject = [_subjects objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"myQuestion" sender:subject];
        
        
    } else {
        [self performSegueWithIdentifier:@"editSubject" sender:nil];

    }
    
    
    
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

- (void)swipeableTableViewCellDidEndScrolling:(SWTableViewCell *)cell{
    if (cell.isUtilityButtonsHidden) {
        [((SubjectCell*)cell).arrow setHidden:NO];
    }
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
    
    [((SubjectCell*)cell).arrow setHidden:YES];
    return YES;
}


- (void)editRemark
{
    [self addMask];
    if (!_editView) {
        CGRect frame = CGRectMake(0, SC_DEVICE_SIZE.height, SC_DEVICE_SIZE.width, 160);
        _editView = [[UIView alloc]initWithFrame:frame];
        _editView.backgroundColor = [UIColor whiteColor];
        [self.navigationController.view addSubview:_editView];
        CGRect textFrame = CGRectMake(0, 50, SC_DEVICE_SIZE.width, 110);
        
        _editTextView = [[UIPlaceHolderTextView alloc]initWithFrame:textFrame];
        [_editTextView setPlaceholder:@"日记不能超过46个字"];
        [_editTextView setText:self.dailyNoteLabel.text];
        _editTextView.layer.borderWidth = 1;
        _editTextView.layer.borderColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:0.5].CGColor;
        _editTextView.font = [UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:16];
        _editTextView.placeholderColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _editTextView.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [_editView addSubview:_editTextView];
        CGRect leftBtFrame = CGRectMake(15, 5, 40, 40);
        UIButton* cancelButton = [[UIButton alloc]initWithFrame:leftBtFrame];
        [cancelButton addTarget:self action:@selector(cancelEdit) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor: [UIColor colorWithRed:31/255.0 green:118/255.0 blue:220/255.0 alpha:1] forState:UIControlStateNormal];
        [_editView addSubview:cancelButton];
        
        CGRect rightBtFrame = CGRectMake(SC_DEVICE_SIZE.width-55, 5, 40, 40);
        UIButton* saveButton = [[UIButton alloc]initWithFrame:rightBtFrame];
        [saveButton addTarget:self action:@selector(saveRemark) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitleColor: [UIColor colorWithRed:31/255.0 green:118/255.0 blue:220/255.0 alpha:1] forState:UIControlStateNormal];
        [_editView addSubview:saveButton];
    }
    [self.view bringSubviewToFront:self.editView];
    [self.editTextView becomeFirstResponder];
    CGRect frame = _editView.frame;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        NSLog(@"%lf",-frame.size.height-(keyboardHeight==0?240:keyboardHeight));
        self.editView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height-(keyboardHeight==0?240:keyboardHeight));
    } completion:^(BOOL finished) {
        //        [self.keyboardBt setHidden:NO];
    }];
    
}

-(void)cancelEdit
{
    [self.editTextView resignFirstResponder];
}

-(void)saveRemark
{
    if (self.editTextView.text.length>46) {
        [ToolUtils showMessage:@"日记不能超过46个字"];
        return;
    }
    [self.editTextView resignFirstResponder];
    [self.dailyNoteLabel setText:self.editTextView.text];
    if (self.editTextView.text.length<23) {
        self.dailyNoteLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        self.dailyNoteLabel.textAlignment = NSTextAlignmentLeft;

    }
    
    NSString* myDay = [NSString stringWithFormat:@"%d",[ToolUtils getCurrentDay].integerValue];
    NSArray* array = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"myDay=%@ and user=%@",myDay,[ToolUtils getUserid]] tableName:@"Trace"];
    CoreDataHelper* helper= [CoreDataHelper getInstance];
    Trace* trace;
    if (array.count==0) {
        trace = (Trace *)[NSEntityDescription insertNewObjectForEntityForName:@"Trace" inManagedObjectContext:helper.managedObjectContext];
        trace.myDay = myDay;
        trace.user = [ToolUtils getUserid];
        NSLog(@"..................此处照理不可能发生");
    } else {
        trace = [array firstObject];
    }
    trace.note = self.editTextView.text;
    
    NSError* error;
    BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful! 日记~~~~~~~~~");
    }
    
    
}


- (void) keyboardWasHidden:(NSNotification *) notif
{
    [self removeMask];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.editView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
    }];
    
}



@end
