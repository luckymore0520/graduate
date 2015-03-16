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
#import "MyCollectionRootView.h"
@interface MyQuestionRootViewController ()
@property (weak, nonatomic) IBOutlet UIButton *myNoteButton;
@property (weak, nonatomic) IBOutlet UIButton *myCollectionButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIView *myNoteView;
@property (strong,nonatomic) MyQuestionVC* myQuestionVC;
@property (strong,nonatomic) MyCollectionRootView* myCollection;
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
    
    _myCollection = [[MyCollectionRootView alloc]initWithNibName:NSStringFromClass([MyCollectionRootView class]) bundle:nil];
    _myCollection.view.frame = self.myNoteView.frame;
    [self.view addSubview:_myCollection.view];
    [self.view addSubview:_myQuestionVC.view];
    [self addChildViewController:_myQuestionVC];
    [self addChildViewController:_myCollection];
    [self selectButton:self.myNoteButton];
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
- (IBAction)selectButton:(id)sender {
    if (sender == self.myNoteButton) {
        [self.myQuestionVC.view setHidden:NO];
        [self.myCollection.view setHidden:YES];
    } else {
        [self.myQuestionVC.view setHidden:YES];
        [self.myCollection.view setHidden:NO];
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
