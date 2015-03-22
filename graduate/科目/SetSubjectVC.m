//
//  SetSubjectVC.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SetSubjectVC.h"
#import "ButtonGroup.h"
#import "MUpdateSubject.h"
#import "MUser.h"
#import "MReturn.h"
#import "QuestionBook.h"
@interface SetSubjectVC ()<UITextFieldDelegate,ButtonGroupDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet ButtonGroup *englishGroup;
@property (weak, nonatomic) IBOutlet UIButton *Eng2Bt;
@property (weak, nonatomic) IBOutlet UIButton *Eng1Bt;
@property (weak, nonatomic) IBOutlet UIButton *Eng3Bt;
@property (weak, nonatomic) IBOutlet UIButton *poliBt;
@property (weak, nonatomic) IBOutlet UIButton *math2Bt;
@property (weak, nonatomic) IBOutlet UIButton *math1Bt;
@property (weak, nonatomic) IBOutlet UIButton *math3Bt;
@property (weak, nonatomic) IBOutlet UIButton *mathNoBt;
@property (weak, nonatomic) IBOutlet UITextField *major1Field;
@property (weak, nonatomic) IBOutlet UITextField *major2Field;
@property (weak, nonatomic) IBOutlet ButtonGroup *mathGroup;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UILabel *major2Label;
@property (weak, nonatomic) IBOutlet UIView *major2Line;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *completeAccessoryView;
@property (nonatomic,strong)MUser* user;
@end

@implementation SetSubjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGroup];
    self.textFields = [NSArray arrayWithObjects:_major1Field,_major2Field, nil];
    self.keyButtons = [NSArray arrayWithObjects:_major2Field, nil];
    self.completeAccessoryView = [[NSBundle mainBundle]loadNibNamed:@"CompleteButtonAccessoryView" owner:self options:nil][0];
    self.completeAccessoryView.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    self.major1Field.inputAccessoryView = self.completeAccessoryView;
    self.major2Field.inputAccessoryView = self.completeAccessoryView;
    
}

- (void)addMaskBt
{
    if (self.maskBt) {
        [self.maskBt setHidden:YES];
        [self.maskBt removeFromSuperview];
    }
    self.maskBt = [[UIButton alloc]initWithFrame:self.tableView.tableHeaderView.bounds];
    [self.tableView.tableHeaderView addSubview:self.maskBt];
    [self.maskBt addTarget:self action:@selector(resignAll) forControlEvents:UIControlEventTouchUpInside];
    for (UITextField* textField in self.textFields) {
        [self.tableView.tableHeaderView bringSubviewToFront:textField];
    }
    
    for (UIButton* button in self.keyButtons) {
        [self.tableView.tableHeaderView bringSubviewToFront:button];
    }
}
- (void)initViews
{
    
}

//初始化ButtonGroup
- (void)initGroup
{
    NSArray* mathGroupBts = [NSArray arrayWithObjects:_math1Bt,_math2Bt,_math3Bt ,_mathNoBt, nil];
    [_mathGroup loadButton:mathGroupBts];
    _mathGroup.name = @"Math";
    _mathGroup.delegate = self;
    
    NSArray* englishGroupBts = [NSArray arrayWithObjects:_Eng1Bt,_Eng2Bt,_Eng3Bt, nil];
    [_englishGroup loadButton:englishGroupBts];
    
    [_poliBt setSelected:YES];
    [_poliBt setUserInteractionEnabled:NO];
    
    _user  = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
    [_mathGroup setSelectedIndex:0];
    BOOL hasMath = NO;
    for (int i = 0 ; i<mathGroupBts.count; i++) {
        UIButton* button = [mathGroupBts objectAtIndex:i];
        if ([button.titleLabel.text isEqualToString:_user.subjectMath_]) {
            [_mathGroup setSelectedIndex:i];
            hasMath = YES;
            break;
        }
    }
    if (!hasMath) {
        [_mathGroup setSelectedIndex:3];
    }
    for (int i = 0 ; i<englishGroupBts.count; i++) {
        UIButton* button = [englishGroupBts objectAtIndex:i];
        if ([button.titleLabel.text isEqualToString:_user.subjectEng_]) {
            [_englishGroup setSelectedIndex:i];
        }
    }
    [_major1Field setText:_user.subjectMajor1_];
    [_major2Field setText:_user.subjectMajor2_];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -textFieldDelegate
//开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{   CGRect frame;
    if (self.major2Field) {
        frame = _major2Field.frame;
    } else
    {
        frame = textField.frame;

    }
    CGFloat offset = frame.origin.y - (self.view.frame.size.height - MAX(keyboardHeight, 240));//键盘高度216
    if (textField.inputAccessoryView) {
        offset = offset+ textField.inputAccessoryView.frame.size.height;
    }
    NSTimeInterval animationDuration = 0.30f;
    CGFloat y = [self.view convertRect:textField.frame toView:nil].origin.y-self.navigationController.navigationBar.frame.size.height-20;
    if (offset>0&&  y > offset) {
        [self.tableView setContentOffset:CGPointMake(0, offset) animated:YES];
    }
    [self addMaskBt];
    return YES;
}

- (void)animationReturn
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
    [self.maskBt setHidden:YES];
    [self.maskBt removeFromSuperview];
}


#pragma mark ButtonAction
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)complete:(id)sender {
    if ([_mathGroup selectedIndex]==3) {
        if (_major1Field.text.length==0||_major2Field.text.length==0) {
            [ToolUtils showMessage:@"请填写两门专业课"];
            return;
        }
    } else {
        if (_major1Field.text.length==0||_major1Field.text.length==0) {
            [ToolUtils showMessage:@"请填写至少一门专业课"];
            return;
        }
    }
    _user.subjectMajor1_ = _major1Field.text;
    _user.subjectMajor2_ = _major2Field.text;
    if (_mathGroup.selectedIndex == 3) {
        _user.subjectMath_ = @"";
    } else
    {
        _user.subjectMath_ = [_mathGroup selectedSubject];
    }
    _user.subjectEng_ = [_englishGroup selectedSubject];
    _user.startDay_ = [ToolUtils getCurrentDay];
    [ToolUtils setUserInfomation:_user.keyValues];
    MUpdateSubject* updateSubject = [[MUpdateSubject alloc]init];
    [updateSubject load:self subjectMath:_user.subjectMath_ subjectMajor1:_user.subjectMajor1_ subjectMajor2:_user.subjectMajor2_ subjectEng:_user.subjectEng_];
    
}

#pragma mark -apidelegate
- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MUpdateSubject"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.intValue==1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [ToolUtils showMessage:@"网络请求失败，请重试"];
        }
    }
}

- (void)selectIndex:(NSInteger)index name:(NSString *)buttonName
{
    if ([buttonName isEqualToString:@"Math"]) {
        if (index==3) {
            [_major2Field setHidden:NO];
            [_major2Label setHidden:NO];
            [_major2Line setHidden:NO];
        } else {
            [_major2Field setHidden:YES];
            [_major2Label setHidden:YES];
            [_major2Line setHidden:YES];
        }
    }
}

#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc]init];
    return cell;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self resignAll];
//}

@end
