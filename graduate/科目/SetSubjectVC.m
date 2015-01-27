//
//  SetSubjectVC.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SetSubjectVC.h"
#import "ButtonGroup.h"
@interface SetSubjectVC ()<UITextFieldDelegate>
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

@end

@implementation SetSubjectVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initGroup];
    self.textFields = [NSArray arrayWithObjects:_major1Field,_major2Field, nil];
    self.keyButtons = [NSArray arrayWithObjects:_completeButton, nil];
    // Do any additional setup after loading the view.
}

//初始化ButtonGroup
- (void)initGroup
{
    NSArray* mathGroupBts = [NSArray arrayWithObjects:_math1Bt,_math2Bt,_math3Bt ,nil];
    [_mathGroup loadButton:mathGroupBts];
    
    NSArray* englishGroupBts = [NSArray arrayWithObjects:_Eng1Bt,_Eng2Bt,_Eng3Bt, nil];
    [_englishGroup loadButton:englishGroupBts];
    
    [_poliBt setSelected:YES];
    [_poliBt setUserInteractionEnabled:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ButtonAction
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (IBAction)complete:(id)sender {
    if (_major1Field.text.length==0||_major1Field.text.length==0) {
        [ToolUtils showMessage:@"请填写专业课"];
        return;
    }
    NSDictionary* subjects = [NSDictionary dictionaryWithObjectsAndKeys:[_englishGroup selectedSubject],@"English",[_mathGroup selectedSubject],@"Math",[NSArray arrayWithObjects:_major1Field.text,_major2Field.text, nil],@"Major", nil];
    [ToolUtils setMySubjects:subjects];
#warning 此处调用设置科目的接口
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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
