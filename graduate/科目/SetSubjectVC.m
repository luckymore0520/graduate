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

@end

@implementation SetSubjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _major1Field.delegate = self;
    _major2Field.delegate = self;
    [self initGroup];
    // Do any additional setup after loading the view.
}

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

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  
    [self animationReturn];
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)complete:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)animationReturn
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
}
- (IBAction)resignAll:(id)sender {
    [self animationReturn];
    [_major2Field resignFirstResponder];
    [_major1Field resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.bounds;
    int offset = frame.origin.y +440 - (self.view.frame.size.height - 268);//键盘高度216
    NSLog(@"offset is %d",offset);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
    return YES;
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
