//
//  MyQuestionRootViewController.m
//  graduate
//
//  Created by luck-mac on 15/3/15.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MyQuestionRootViewController.h"
#import "MyQuestionVC.h"
#import "ButtonGroup.h"
#import "UIImage+Graduate.h"
@interface MyQuestionRootViewController ()
@property (weak, nonatomic) IBOutlet UIButton *myNoteButton;
@property (weak, nonatomic) IBOutlet UIButton *myCollectionButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIView *myNoteView;
@property (strong,nonatomic) MyQuestionVC* myQuestionVC;
@property (weak, nonatomic) IBOutlet ButtonGroup *buttonGroupView;

@end

@implementation MyQuestionRootViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Func" bundle:nil];
    _myQuestionVC = [storyboard instantiateViewControllerWithIdentifier:@"myQuestions"];
    _myQuestionVC.type = self.subject.type;
    _myQuestionVC.shoudUpdate = self.subject.shoudUpdate;
    _myQuestionVC.subject = self.subject.name;
    _myQuestionVC.view.frame = self.myNoteView.frame;
    [self.view addSubview:_myQuestionVC.view];
    [self addChildViewController:_myQuestionVC];
}

- (void)initViews
{
    [_myNoteButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    [_myCollectionButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    [_buttonGroupView loadButton:@[_myNoteButton,_myCollectionButton]];
    _buttonGroupView.layer.borderColor = [UIColor whiteColor].CGColor;
    _buttonGroupView.layer.borderWidth = 1;
    _buttonGroupView.layer.cornerRadius = 5;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)selectMode:(id)sender {
    [_myQuestionVC selectPhotos:sender];
    
}
- (IBAction)onBackButtonClicked:(id)sender {
    if (self.navigationController.childViewControllers.count==1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
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
