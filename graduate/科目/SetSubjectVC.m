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
@interface SetSubjectVC ()<UITextFieldDelegate,ButtonGroupDelegate>
@property (weak, nonatomic) IBOutlet ButtonGroup *englishGroup;
@property (weak, nonatomic) IBOutlet UIButton *Eng2Bt;
@property (weak, nonatomic) IBOutlet UIButton *Eng1Bt;
@property (weak, nonatomic) IBOutlet UIButton *Eng3Bt;
@property (weak, nonatomic) IBOutlet UIButton *poliBt;
@property (weak, nonatomic) IBOutlet UIButton *math2Bt;
@property (weak, nonatomic) IBOutlet UIButton *math1Bt;
@property (weak, nonatomic) IBOutlet UIButton *math3Bt;
@property (weak, nonatomic) IBOutlet UITextField *major1Field;
@property (weak, nonatomic) IBOutlet UITextField *major2Field;
@property (weak, nonatomic) IBOutlet ButtonGroup *mathGroup;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UILabel *major2Label;
@property (nonatomic,strong)MUser* user;
@end

@implementation SetSubjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGroup];
    self.textFields = [NSArray arrayWithObjects:_major1Field,_major2Field, nil];
    self.keyButtons = [NSArray arrayWithObjects:_completeButton, nil];
//    [_major2Label setHidden:YES];
//    [_major2Field setHidden:YES];
    // Do any additional setup after loading the view.
}

//初始化ButtonGroup
- (void)initGroup
{
    NSArray* mathGroupBts = [NSArray arrayWithObjects:_math1Bt,_math2Bt,_math3Bt ,nil];
    [_mathGroup loadButton:mathGroupBts];
    _mathGroup.canbeNull = YES;
    _mathGroup.name = @"Math";
    _mathGroup.delegate = self;
    
    NSArray* englishGroupBts = [NSArray arrayWithObjects:_Eng1Bt,_Eng2Bt,_Eng3Bt, nil];
    [_englishGroup loadButton:englishGroupBts];
    
    [_poliBt setSelected:YES];
    [_poliBt setUserInteractionEnabled:NO];
    
    _user  = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
    [_mathGroup setSelectedIndex:0];
    for (int i = 0 ; i<mathGroupBts.count; i++) {
        UIButton* button = [mathGroupBts objectAtIndex:i];
        if ([button.titleLabel.text isEqualToString:_user.subjectMath_]) {
            [_mathGroup setSelectedIndex:i];
        }
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


#pragma mark ButtonAction
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)complete:(id)sender {
    if ([_mathGroup selectedIndex]==-1) {
        if (_major1Field.text.length==0&&_major1Field.text.length==0) {
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
    _user.subjectMath_ = [_mathGroup selectedSubject];
    _user.subjectEng_ = [_englishGroup selectedSubject];
    [ToolUtils setUserInfomation:_user.keyValues];
    
    MUpdateSubject* updateSubject = [[MUpdateSubject alloc]init];
    [updateSubject load:self subjectMath:_user.subjectMath_ subjectMajor1:_user.subjectMajor1_ subjectMajor2:_user.subjectMajor2_ subjectEng:_user.subjectEng_];
    
    
#warning 此处调用设置科目的接口

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
        if (index==-1) {
            [_major2Field setHidden:NO];
            [_major2Label setHidden:NO];
        } else {
            [_major2Field setHidden:YES];
            [_major2Label setHidden:YES];
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
