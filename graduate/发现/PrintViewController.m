//
//  PrintViewController.m
//  graduate
//
//  Created by luck-mac on 15/2/20.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "PrintViewController.h"
#import "QuestionBook.h"
#import "MUser.h"
#import "MUpdateUserInfo.h"
#import "Subject.h"
#import "ButtonGroup.h"
#import "IQActionSheetPickerView.h"
#import "MReturn.h"
#import "MQuesPrint.h"
#import "BackUpViewController.h"
@interface PrintViewController ()<IQActionSheetPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *endDateButton;
@property (weak, nonatomic) IBOutlet UIButton *startDateButton;
@property (weak, nonatomic) IBOutlet UIView *printView;
@property (weak, nonatomic) IBOutlet UIView *backupView;
@property (weak, nonatomic) IBOutlet UIButton *setEmailBt;
@property (weak, nonatomic) IBOutlet UIButton *sendBt;
@property (nonatomic,strong) MUser* user;
@property (nonatomic,strong)UIView* editView;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet ButtonGroup *subjectGroup;
@property (nonatomic,strong)UITextField* editTextView;
@property (nonatomic,strong)NSArray* buttonArray;
@property (nonatomic,strong)NSArray* subjects;
@property (nonatomic,strong)UIButton* selectedButton;
@property (nonatomic,strong)NSString* startDate;
@property (nonatomic,strong)NSString* endDate;

@end

@implementation PrintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"打印"];
    _user = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
    _sendBt.layer.borderColor = [UIColor whiteColor].CGColor;
    _sendBt.layer.borderWidth = 1;
    _sendBt.layer.cornerRadius = 5;
    [self setSubject];
    [self setDate];
    
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    if ([[UIScreen mainScreen]bounds].size.height<500) {
        self.scale = 0.75;
    }
    [super initViews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[QuestionBook getInstance] calculateNeedUpload];
    if ([QuestionBook getInstance].needUpload>0) {
        [self.backupView setHidden:NO];
        [self.printView setHidden:YES];
    } else {
        [self.backupView setHidden:YES];
        [self.printView setHidden:NO];
    }
    [self setButton];
    [self.navigationController.navigationBar  setBackgroundImage:[[UIImage imageNamed:@"green"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)]   forBarMetrics:UIBarMetricsDefault];
}
- (void)setDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval secondsPerDay1 = 24*60*60;
    NSDate* now = [NSDate date];
    NSInteger currentDay = [ToolUtils getCurrentDay].integerValue;
    if ([ToolUtils getLastUpdateTime]) {
        [_startDateButton setTitle:[ToolUtils getLastUpdateTime] forState:UIControlStateNormal];
    } else {
        NSDate *startDate = [now addTimeInterval:-currentDay*secondsPerDay1];
        NSString* startDateStr = [dateFormatter stringFromDate:startDate];
        [_startDateButton setTitle:startDateStr forState:UIControlStateNormal];
    }
    [_endDateButton setTitle:[dateFormatter stringFromDate:now] forState:UIControlStateNormal];
    self.endDate = [dateFormatter stringFromDate:now];
    self.startDate = [ToolUtils getLastUpdateTime];
}

- (void)setSubject
{
    _subjects = [[QuestionBook getInstance]getMySubjects];
    _buttonArray = @[_button1,_button2,_button3,_button4];
    if (_subjects.count==4) {
        for (int i = 0 ; i < 4 ; i++) {
            Subject* subject= _subjects[i];
            [_buttonArray[i] setTitle:subject.firstStr forState:UIControlStateNormal];
        }
    }
    [_subjectGroup loadButton:_buttonArray];
    _subjectGroup.canbeNull = YES;

    [_subjectGroup setSelectedIndex:0];
    
    
    
}

- (IBAction)setEmail:(id)sender {
    [self editEmail];
}


- (IBAction)print:(id)sender {
    if (self.subjectGroup.selectedIndex<0) {
        [ToolUtils showMessage:@"请先选择科目"];
        return;
    }
    [self waiting:@"打印中..."];
    Subject* selectedSubject = self.subjects[[self.subjectGroup selectedIndex]];
    NSString* type = [NSString stringWithFormat:@"%ld",selectedSubject.type];
    NSString* start = self.startDateButton.titleLabel.text;
    NSString* endData = self.endDateButton.titleLabel.text;
    [[[MQuesPrint alloc]init]load:self startDate:start endDate:endData type:type];
    
}

- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    [self waitingEnd];
    if ([names isEqualToString:@"MQuesPrint"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue ==1) {
            [ToolUtils setLastUpdateTime:self.endDateButton.titleLabel.text];
            [ToolUtils showMessage:@"打印文件已发送至您邮箱，请查收"];
        }
    }
}


- (IBAction)setDate:(id)sender {
    self.selectedButton = sender;
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"请选择日期" delegate:self];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker showInViewController:self.navigationController];
    [picker setDate:[NSDate date]];
}


- (IBAction)backUp:(id)sender {
    BackUpViewController* backUp = [self.storyboard instantiateViewControllerWithIdentifier:@"backUp"];
    [self.navigationController pushViewController:backUp animated:YES];
}

- (void)setButton
{
    if (_user.email_&&_user.email_.length>0) {
        [_sendBt setHidden:NO];
        [_setEmailBt setHidden:YES];
        [_sendBt setTitle:[NSString stringWithFormat:@"发送打印文件至%@",_user.email_] forState:UIControlStateNormal];
    } else {
        [_sendBt setHidden:YES];
        [_setEmailBt setHidden:NO];
    }
}

- (void)editEmail
{
    [self addMask];
    if (!_editView) {
        CGRect frame = CGRectMake(0, SC_DEVICE_SIZE.height, SC_DEVICE_SIZE.width, 120);
        _editView = [[UIView alloc]initWithFrame:frame];
        _editView.backgroundColor = [UIColor whiteColor];
        [self.navigationController.view addSubview:_editView];
        CGRect textFrame = CGRectMake(0, 50, SC_DEVICE_SIZE.width, 70);
        
        _editTextView = [[UITextField alloc]initWithFrame:textFrame];
        _editTextView.layer.borderWidth = 1;
        _editTextView.layer.borderColor = [UIColor colorWithRed:194/255.0 green:194/255.0 blue:194/255.0 alpha:0.5].CGColor;
        _editTextView.font = [UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:16];
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
        [saveButton addTarget:self action:@selector(saveEmail) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitleColor: [UIColor colorWithRed:31/255.0 green:118/255.0 blue:220/255.0 alpha:1] forState:UIControlStateNormal];
        [_editView addSubview:saveButton];
    }
    self.editTextView.placeholder = @"请设置您的电子邮箱，以便接收下载的资料";
    [self.navigationController.view bringSubviewToFront:self.editView];
    [self.editTextView becomeFirstResponder];
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





-(void)cancelEdit
{
    [self.editTextView resignFirstResponder];
}

-(void)saveEmail
{
    if ([ToolUtils checkEmail:self.editTextView.text]) {
        [self.editTextView resignFirstResponder];
        self.user.email_ = self.editTextView.text;
        [ToolUtils setUserInfomation:self.user.keyValues];
        [[[MUpdateUserInfo alloc]init]load:self nickname:_user.nickname_ headImg:_user.headImg_ sex:_user.sex_.integerValue email:_user.email_];
        [self setButton];
    } else {
        [ToolUtils showMessage:@"邮箱格式不合法,请输入正确的邮箱"];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectTitles:(NSArray *)titles
{
    NSDateFormatter *dateFormatterwithoutYear = [[NSDateFormatter alloc] init];
    // 为日期格式器设置格式字符串
    [dateFormatterwithoutYear setDateFormat:@"YYYY-MM-dd"];
    // 使用日期格式器格式化日期、时间
    NSString *destDateString = [dateFormatterwithoutYear stringFromDate:pickerView.date];
    [self.selectedButton setTitle:destDateString forState:UIControlStateNormal];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    if (self.selectedButton==self.startDateButton) {
        self.startDate = [dateFormatter stringFromDate:pickerView.date];
        NSDate *end = [dateFormatter dateFromString:self.endDate];
        NSDate *start = [dateFormatter dateFromString:self.startDate];
        
        NSTimeInterval timeBetweenNow = [start timeIntervalSinceNow];
        if (timeBetweenNow>0) {
            start = [NSDate date];
            [self.startDateButton setTitle:[dateFormatterwithoutYear stringFromDate:start] forState:UIControlStateNormal];
        }
        NSTimeInterval timeBetween = [end timeIntervalSinceDate:start];
        if (timeBetween<0) {
            self.endDate  = self.startDate;
            [self.endDateButton setTitle:self.startDateButton.titleLabel.text forState:UIControlStateNormal];
        }
    } else {
        self.endDate = [dateFormatter stringFromDate:pickerView.date];
        NSDate *end = [dateFormatter dateFromString:self.endDate];
        NSDate *start = [dateFormatter dateFromString:self.startDate];
        
        NSTimeInterval timeBetweenNow = [end timeIntervalSinceNow];
        if (timeBetweenNow>0) {
            end = [NSDate date];
            [self.endDateButton setTitle:[dateFormatterwithoutYear stringFromDate:end] forState:UIControlStateNormal];
            self.endDate = [dateFormatter stringFromDate:end];
        }
        
        
        
        NSTimeInterval timeBetween = [end timeIntervalSinceDate:start];
        if (timeBetween<0) {
            self.startDate  = self.endDate;
            [self.startDateButton setTitle:self.endDateButton.titleLabel.text forState:UIControlStateNormal];
    
        }
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
