//
//  SubjectVC.m
//  graduate
//
//  Created by luck-mac on 15/1/23.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SubjectVC.h"
#import "ToolUtils.h"
#import "EssenceDetailWebViewController.h"
#import "MQuestionRecommand.h"
#import "MyQuestionRootViewController.h"
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
#import "MUploadDiary.h"
#import "MImgUpload.h"
#import "MUpdateUserInfo.h"
#import "MyTraceList.h"
#import "GodNoteViewController.h"

@interface SubjectVC ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,SCNavigationControllerDelegate,SWTableViewCellDelegate,UIScrollViewDelegate>

//昵称
@property (weak, nonatomic) IBOutlet UIImageView *rollImage;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
//日记
@property (weak, nonatomic) IBOutlet UILabel *dailyNoteLabel;

//编辑日记的视图
@property (strong, nonatomic)  UIView *editView;
@property (strong, nonatomic)  UIPlaceHolderTextView *editTextView;


@property (weak, nonatomic) IBOutlet UIImageView *redDot;


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
@property (weak, nonatomic) IBOutlet UIControl *bootView;
@property (strong,nonatomic)Trace* trace;
//首页新闻
@property (nonatomic,strong)NSArray* newsList;
@property (nonatomic)int nowNewsIndex;
//弹窗
@property (nonatomic,strong)UIAlertView* subjectAlert;
//新闻滚动条
@property (weak, nonatomic) IBOutlet UIScrollView *newsListScrollView;



@end
CGFloat angle;
NSTimer *timer;
@implementation SubjectVC

- (void)viewDidLoad {
    if (self.view.frame.size.height>500) {
        [self.tableview setScrollEnabled:NO];
    }
    
    //新闻的scrollView
    self.newsListScrollView.delegate = self;
    [self.newsListScrollView setPagingEnabled:YES];
    self.newsListScrollView.showsHorizontalScrollIndicator=NO;
    [self setTitle:@"主页"];
    [super viewDidLoad];
    [self.editView removeFromSuperview];
    self.headView.layer.cornerRadius = 42;
    [self.headView setClipsToBounds:YES];
    
    self.headView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headView.layer.borderWidth = 3;
    _subjectImgList  = [NSArray arrayWithObjects:@"英语",@"政治",@"数学",@"专业课一",@"专业课二", nil];
    self.firstOpen = YES;
    [self.view bringSubviewToFront:self.centerLine];
    if (![ToolUtils getNotFirstLogin]) {
        [self.bootView setHidden:NO];
        [ToolUtils setNotFirstLogin:YES];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"UPDATEIMAGE" object:nil];
    if (![ToolUtils connectToInternet]) {
        [self reloadData];
    }
    [self setUserHeadImg];
}



- (void)updateImage
{
    //这个用来查找最近的一条日记
    Trace *trace = [[MyTraceList getInstance] getNearestNoteTrace];
    //    NSLog(@"length of %d",arrayNote.count);
    if (trace) {
        if(trace.note.length){
            [self setDiaryLabel:trace.note];
        }else{
            [self setDiaryLabel:[ToolUtils getDiaryDefault]];
        }
    }else{
        [self setDiaryLabel:[ToolUtils getDiaryDefault]];
    }
    //这里用来设置背景图
    NSArray* array = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"myDay=%@ and user=%@",[NSString stringWithFormat:@"%d",[ToolUtils getCurrentDay].intValue],[ToolUtils getUserid]] tableName:@"Trace"];
    if (array.count>0) {
        Trace* trace = [array firstObject];
        _trace = trace;
        UIImage* plageHolder = nil;
        if (![[SDWebImageManager sharedManager]cachedImageExistsForURL:[ToolUtils getImageUrlWtihString:trace.pictureUrlForSubject width:self.view.frame.size.width*2 height:0] ]) {
            plageHolder = [UIImage imageNamed:@"默认背景"];
        }

        [_backgroundViw sd_setImageWithURL:[ToolUtils getImageUrlWtihString:trace.pictureUrlForSubject width:self.view.frame.size.width*2 height:0] placeholderImage:plageHolder];
    }
    
}

#pragma mark - ButtonAction
- (IBAction)onBootViewTouchedDown:(id)sender {
    [self.bootView setHidden:YES];
}

- (IBAction)onClickImage:(id)sender
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"DiscoverStoryBoard" bundle:nil];
    UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"setInfo"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //加载首页新闻
    [self loadIndexNews];
    if (!self.subjects) {
        self.subjects =[NSMutableArray arrayWithArray:[[QuestionBook getInstance]getMySubjects]];
    }
    [self.tableview reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if ([ToolUtils recommandDay]&&[[ToolUtils recommandDay]isEqualToString:[ToolUtils getCurrentDate]]) {
        [self.redDot setHidden:YES];
    } else {
        [self.redDot setHidden:NO];
    }
    
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer setFireDate:[NSDate distantFuture]];
    
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
    [[[MQuestionRecommand alloc]init]load:self date:[ToolUtils getCurrentDate]];
    MUser* user = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
    [self setUserHeadImg];
    [self updateImage];
    [self.nickNameLabel setText:user.nickname_];
    [self initSubject];
}

-(void)loadIndexNews
{
    MGetNewsList* getNewsList = [[MGetNewsList alloc]init];
    getNewsList = (MGetNewsList*)[getNewsList setPage:1 limit:3];
    [getNewsList load:self type:nil];
}

-(void)showIndexNews
{
    for (UIView* view in self.newsListScrollView.subviews) {
        [view removeFromSuperview];
    }
    CGSize pageScrollViewSize = self.view.frame.size;
    float width = self.newsListScrollView.frame.size.width,height = self.newsListScrollView.frame.size.height;
    self.newsListScrollView.contentSize = CGSizeMake(width * self.newsList.count, 0);
    self.newsListScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    for (int i = 0 ; i < self.newsList.count; i++) {
        MNews *n = self.newsList[i];
        CGRect frame;
        frame.origin.x = width * i;
        frame.origin.y = 0;
        frame.size = CGSizeMake(width, height);
        UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = frame;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.titleLabel.font = [UIFont fontWithName:@"FZLTXHJW--GB1-0" size:20.0];
        [button addTarget:self action:@selector(newsClicked) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:n.title_ forState:UIControlStateNormal];
//        button.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
        [button setTitleColor:[UIColor colorWithRed:67.0/255.0 green:121.0/255.0 blue:183.0/255.0 alpha:1.0] forState:(UIControlStateNormal)];
//        [button.layer setBorderWidth:2.0];
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
//        [button.layer setBorderColor:colorref];
        [self.newsListScrollView addSubview:button];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(moveNews) userInfo:nil repeats:YES];
}

-(void)newsClicked
{
    MNews* nowNews = self.newsList[self.nowNewsIndex];
//    [ToolUtils showMessage:[NSString stringWithFormat:@"点击了新闻了 %@",nowNews.title_]];
    if(nowNews.type_.integerValue ==1){
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"EssenceStoryboard" bundle:nil];
        EssenceDetailWebViewController* detail = [storyboard instantiateViewControllerWithIdentifier:@"essenceWeb"];
        detail.url = [NSURL URLWithString:[nowNews.url_ stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        detail.title = @"新闻详情";
//        [detail addRightButton:@"更多新闻" action:@selector(moreNews) img:nil];
        [detail addRightButtonForNews];
        [self.navigationController pushViewController:detail animated:YES];
    }else if(nowNews.type_.integerValue==3){
        NSLog(@"%@",nowNews.noteId_);
        [ToolUtils showMessage:[NSString stringWithFormat:@"大神笔记%@",nowNews.noteId_]];
    }
}



-(void)moveNews
{
    if(self.nowNewsIndex < self.newsList.count -1){
        self.nowNewsIndex++;
        [self.newsListScrollView setContentOffset:CGPointMake(self.newsListScrollView.frame.size.width*self.nowNewsIndex,0)animated:YES];
    }else if(self.nowNewsIndex == self.newsList.count-1){
        [self.newsListScrollView setContentOffset:CGPointMake(0,0)animated:YES];
        self.nowNewsIndex=0;
    }
}


-(void)setUserHeadImg
{
    MUser* user = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
    if([[ToolUtils getHeadImgLocal] length]){
        [self.headView sd_setImageWithURL:[NSURL URLWithString:[ToolUtils getHeadImgLocal]] placeholderImage:[UIImage imageNamed:user.sex_.integerValue==0?@"原始头像男":@"原始头像女"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
   }else if([user.headImg_ length])
   {
       [self.headView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:user.headImg_ width:164 height:164] placeholderImage:[UIImage imageNamed:user.sex_.integerValue==0?@"原始头像男":@"原始头像女"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       }];
   }
}

-(void)setDiaryLabel:(NSString *)diary
{
    [self.dailyNoteLabel setText:diary];
    if (diary.length<23) {
        self.dailyNoteLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        self.dailyNoteLabel.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)animationLabel:(NSArray*)statics
{
    NSInteger total = [[statics firstObject] integerValue];
    NSInteger totalNew = [statics[1] integerValue];
    NSInteger sign = [statics[2]integerValue];
    NSInteger hasEnd = self.totalLabel.text.integerValue==total
                &&self.totalNewLabel.text.integerValue==totalNew
    &&self.cardLabel.text.integerValue==sign;
    if (!hasEnd) {
        self.totalLabel.text = [NSString stringWithFormat:@"%ld",MIN(self.totalLabel.text.integerValue+1,total)];
        self.totalNewLabel.text = [NSString stringWithFormat:@"%ld",MIN(self.totalNewLabel.text.integerValue+1,totalNew)];
        self.cardLabel.text = [NSString stringWithFormat:@"%ld",MIN(self.cardLabel.text.integerValue+1,sign)];
        [self performSelector:@selector(animationLabel:) withObject:statics afterDelay:(40.0/total)*0.02];
    }
}

- (void)calculateTotal
{
    NSInteger total = 0;
    NSInteger totalNew = 0;
    for (Subject* subject in self.subjects) {
        total+=subject.total;
        totalNew+=subject.newAdd;
    }
    totalNew = MAX(totalNew, _trace.addCount.integerValue);
    
    NSArray* signList = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"userid=%@",[ToolUtils getUserid]] tableName:@"Sign"];
    [self animationLabel:@[[NSNumber numberWithInteger:total],[NSNumber numberWithInteger:totalNew],[NSNumber numberWithInteger:MAX(signList.count,_trace.signCount.integerValue)]]];
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
    } else if([names isEqualToString:@"MIndexNews"]){
        MNewsList* newsList = [MNewsList objectWithKeyValues:data];
        _newsList = newsList.news_;
        [self showIndexNews];
    }else if ([names isEqualToString:@"MQuesCountStatus"])
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
                        subject.shoudUpdate = subject.total < count.engCount_.integerValue || subject.newAdd < count.engAddedCount_.integerValue;
                        subject.total = subject.total>count.engCount_.integerValue?subject.total:count.engCount_.integerValue;
                        subject.newAdd = subject.newAdd>count.engAddedCount_.integerValue?subject.newAdd:count.engAddedCount_.integerValue;
                        break;
                    case 2:
                        subject.shoudUpdate = subject.total < count.polityCount_.integerValue || subject.newAdd<count.polityAddedCount_.integerValue;
                        subject.total = subject.total>count.polityCount_.integerValue?subject.total:count.polityCount_.integerValue;
                        subject.newAdd = subject.newAdd>count.polityAddedCount_.integerValue?subject.newAdd :count.polityAddedCount_.integerValue;
                        break;
                    case 3:
                        subject.shoudUpdate = subject.total < count.mathCount_.integerValue||subject.newAdd<count.mathAddedCount_.integerValue;
                        subject.total = subject.total>count.mathCount_.integerValue?subject.total:count.mathCount_.integerValue;
                        subject.newAdd = subject.newAdd>count.mathAddedCount_.integerValue?subject.newAdd:count.mathAddedCount_.integerValue;
                        break;
                    case 4:
                        subject.shoudUpdate = subject.total < count.major1Count_.integerValue||subject.newAdd<count.major1AddedCount_.integerValue;
                        subject.total = subject.total>count.major1Count_.integerValue?subject.total:count.major1Count_.integerValue;
                        subject.newAdd = subject.newAdd>count.major1AddedCount_.integerValue?subject.newAdd:count.major1AddedCount_.integerValue;
                        break;
                    case 5:
                        subject.shoudUpdate = subject.total < count.major2Count_.integerValue||subject.newAdd<count.major2AddedCount_.integerValue;
                        subject.total = subject.total>count.major2Count_.integerValue?subject.total:count.major2Count_.integerValue;
                        subject.newAdd = subject.newAdd>count.major2AddedCount_.integerValue ? subject.newAdd:count.major2AddedCount_.integerValue;
                        break;
                    default:
                        break;
                }
            }
        }else if ([names isEqualToString:@"MImgUpload"]) {
            MReturn* ret = [MReturn objectWithKeyValues:data];
            NSLog(@"%@return msg",ret.msg_);

            if (ret.code_.integerValue==1) {
                               //            [ToolUtils setHeadImg:ret.msg_];
                NSDictionary *userInfo = [ToolUtils getUserInfo];
                [ToolUtils setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[userInfo objectForKey:@"gender"],@"gender",[userInfo objectForKey:@"nickname"],@"nickname",ret.msg_,@"headImg",nil]];
                NSDictionary* userinfo = [ToolUtils getUserInfo];
                MUpdateUserInfo* updateUserInfo = [[MUpdateUserInfo alloc]init];
                [updateUserInfo load:self nickname:[userinfo objectForKey:@"nickname"] headImg:[[ToolUtils getUserInfo] objectForKey:@"headImg"] sex:[[userinfo objectForKey:@"gender"]isEqualToString:@"男"]?0:1 email:nil];
                
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
    self.subjects =[NSMutableArray arrayWithArray:[[QuestionBook getInstance]getMySubjects]];
    if (_firstOpen) {
        if (![ToolUtils connectToInternet]) {
            [self calculateTotal];
            [self.tableview reloadData];
        } else {
//            [[[MQuesCountStatus alloc]init]load:self];
            [self.tableview reloadData];
        }
    } else {
//        [[[MQuesCountStatus alloc]init]load:self];
        [self.tableview reloadData];
    }
   
}


- (IBAction)startEdit:(id)sender {
    [self editRemark];
}


- (IBAction)recommand:(id)sender {
    if (self.subjects.count<4) {
        [self showSubjectAlert];
    } else {
        [self performSegueWithIdentifier:@"recommand" sender:nil];
        [ToolUtils setRecommandDay:[ToolUtils getCurrentDate]];

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
        [self showSubjectAlert];
    } else {
        SCNavigationController *nav = [[SCNavigationController alloc] init];
        nav.scNaigationDelegate = self;
        [nav showCameraWithParentController:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"recommand"]) {
//        RecommandVC* vc = (RecommandVC*)[segue destinationViewController];
//        vc.questionList = [NSMutableArray arrayWithArray:self.recommandList];
        
        GodNoteViewController *godNote = [[GodNoteViewController alloc] init];
        [self.navigationController pushViewController:godNote animated:YES];
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
        [cell.totalLabel setText:[NSString stringWithFormat:@"%ld篇/",subject.total]];
       [cell.addLabel setText:[NSString stringWithFormat:@"%ld篇新增",subject.newAdd]];
        [cell.arrow setHidden:NO];
        cell.delegate = self;
        if (self.subjects.count<4) {
            [cell.totalLabel setHidden:YES];
            [cell.addLabel setHidden:YES];
        } else {
            [cell.totalLabel setHidden:NO];
            [cell.addLabel setHidden:NO];
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
    if (!_subjects) {
        return 0;
    }
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
        MyQuestionRootViewController* vc = [[MyQuestionRootViewController alloc]initWithNibName:NSStringFromClass([MyQuestionRootViewController class]) bundle:nil];
        vc.subject = subject;
        WKNavigationViewController* nav = [[WKNavigationViewController alloc]initWithRootViewController:vc];
        nav.transitioningDelegate = self;
        [self.navigationController presentViewController:nav animated:YES completion:^{
            
        }];
    } else {
        [self performSegueWithIdentifier:@"editSubject" sender:nil];

    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView==self.newsListScrollView) {
        int index= round(scrollView.contentOffset.x/scrollView.frame.size.width);
        self.nowNewsIndex = index;
    }else{
        if (scrollView.contentSize.height - scrollView.contentOffset.y<=110) {
            if (!_isPresenting) {
                _isPresenting = YES;
                BaseFuncVC* controller = (BaseFuncVC*)[self.parentVC.delegate flipViewController:self.parentVC contentIndex:2];
                UIView *sourceSnapshot = [controller.view snapshotViewAfterScreenUpdates:YES];
                UIImageView* background = [[UIImageView alloc]initWithFrame:sourceSnapshot.frame];
                [background setImage:[UIImage imageNamed:@"首页1"]];
                
                [self.navigationController.view addSubview:sourceSnapshot];
                sourceSnapshot.transform = CGAffineTransformMake(0.8,0,0,0.8, 0,sourceSnapshot.frame.size.height);
                [self.navigationController.view addSubview:background];
                [self.navigationController.view bringSubviewToFront:sourceSnapshot];
                background.transform = CGAffineTransformMake(1,0,0,1, 0,sourceSnapshot.frame.size.height);
                [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    background.transform = CGAffineTransformMake(1,0,0,1, 0,0);
                } completion:^(BOOL finished) {
                }];
                [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    sourceSnapshot.transform = CGAffineTransformMake(0.8,0,0,0.8, 0,0);
                } completion:^(BOOL finished) {
                    [sourceSnapshot removeFromSuperview];
                    [background removeFromSuperview];
                    [self.parentVC pushViewController:controller animated:NO];
                    _isPresenting = NO;
                }];
            }
        }

    }
}


#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.tableview indexPathForCell:cell];
    Subject* subject = [_subjects objectAtIndex:cellIndexPath.row];
    
    NSString* type = @"";
    switch (subject.type) {
        case 1:
            type = @"setEnglish";
            break;
        case 3:
        case 5:
            type = @"setMathOrMajor2";
            break;
        case 4:
            type = @"setMajor1";
            break;
        default:
            break;
    }
    [cell hideUtilityButtonsAnimated:NO];
    ModifySubjectVC* nextVC = [self.storyboard instantiateViewControllerWithIdentifier:type];
    nextVC.type = subject.type;
    nextVC.subject = subject.name;
    [self.navigationController pushViewController:nextVC animated:YES];
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
        [_editTextView setPlaceholder:@"日记不能超过42个字"];
        if(![[ToolUtils getDiaryDefault] isEqualToString:self.dailyNoteLabel.text]){
            [_editTextView setText:self.dailyNoteLabel.text];
        }
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
    [self.navigationController.view bringSubviewToFront:self.editView];
    [self.editTextView becomeFirstResponder];
      
}

-(void)cancelEdit
{
    [self.editTextView resignFirstResponder];
}

-(void)saveRemark
{
    if (self.editTextView.text.length>42) {
        [ToolUtils showMessage:@"日记不能超过42个字"];
        return;
    }
    if ([self.editTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length==0) {
        [ToolUtils showMessage:@"日记不能为空"];
        return;
    }
    [self.editTextView resignFirstResponder];
    [self.dailyNoteLabel setText:self.editTextView.text];
    if (self.editTextView.text.length<23) {
        self.dailyNoteLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        self.dailyNoteLabel.textAlignment = NSTextAlignmentLeft;
    }
    NSString* myDay = [NSString stringWithFormat:@"%ld",[ToolUtils getCurrentDay].integerValue];
    NSArray* array = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"myDay=%@ and user=%@",myDay,[ToolUtils getUserid]] tableName:@"Trace"];
    CoreDataHelper* helper= [CoreDataHelper getInstance];
    Trace* trace;
    if (array.count==0) {
        trace = (Trace *)[NSEntityDescription insertNewObjectForEntityForName:@"Trace" inManagedObjectContext:helper.managedObjectContext];
        trace.myDay = myDay;
        trace.user = [ToolUtils getUserid];
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
    [[[MUploadDiary alloc]init]load:self content:trace.note date:trace.date];
}

-(void)showSubjectAlert
{
    if (!self.subjectAlert) {
        _subjectAlert = [[UIAlertView alloc]initWithTitle:@"设置科目" message:@"该功能取决于您的课程，请先添加课程" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    [_subjectAlert show];
}
#pragma mark -AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.subjectAlert) {
        if (buttonIndex==1) {
            [self performSegueWithIdentifier:@"editSubject" sender:nil];
        }
    }
}



- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    keyboardHeight = keyboardSize.height>=240?keyboardSize.height:240;
    [ToolUtils setKeyboardHeight:[NSNumber numberWithDouble:keyboardHeight]];
    CGRect frame = self.editView.frame;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.editView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height-(keyboardHeight==0?240:keyboardHeight));
    } completion:^(BOOL finished) {
    }];
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
