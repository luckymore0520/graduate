//
//  PostViewController.m
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-21.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "PostViewController.h"
#import "QuestionBook.h"
#import "Subject.h"
#import "ButtonGroup.h"
#import "MImgUpload.h"
#import "MUploadQues.h"
#import "MReturn.h"
@interface PostViewController ()
@property (nonatomic, strong) UIView *topContainerView;//顶部view
@property (nonatomic,strong)UIView* bottomContainerView;
@property (nonatomic, strong) UIButton *topLbl;//顶部的标题
@property (nonatomic,strong)NSArray* subjects;
@property (nonatomic,strong)UIView* eidtView;
@property (nonatomic,strong)UITextView* editTextView;
@property (nonatomic,strong)ButtonGroup* subjectView;
@property (nonatomic,strong)Question* question;
@property (nonatomic,strong)UILabel* markLabel;
@property (nonatomic,strong)UIView* labelView;
@end

@implementation PostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (_postImage) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:_postImage];
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        imgView.center = self.view.center;
        [self.view addSubview:imgView];
    }
    
    
    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    backBtn.frame = CGRectMake(0, self.view.frame.size.height - 40, 80, 40);
//    [backBtn setTitle:@"back" forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backBtn];
    
    [self addTopViewWithText:@"重拍"];
    [self addbottomContainerView];
    [self addCameraMenuView];
    [self addSubjectView];
    
    
    
}

#pragma mark -------------UI---------------
//顶部标题
- (void)addTopViewWithText:(NSString*)text {
    if (!_topContainerView) {
        CGRect topFrame = CGRectMake(0, 0, SC_DEVICE_SIZE.width, 44);
        
        UIView *tView = [[UIView alloc] initWithFrame:topFrame];
        tView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tView];
        self.topContainerView = tView;
        UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, topFrame.size.width, topFrame.size.height)];
        emptyView.backgroundColor = [UIColor blackColor];
        emptyView.alpha = 0.4f;
        [_topContainerView addSubview:emptyView];
        
        topFrame.origin.x += 10;
        UIButton *lbl = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 100, topFrame.size.height)];
        [lbl addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.titleLabel.textColor = [UIColor whiteColor];
        lbl.titleLabel.font = [UIFont systemFontOfSize:25.f];
        [_topContainerView addSubview:lbl];
        self.topLbl = lbl;
        
        
        UIButton *editBt = [[UIButton alloc] initWithFrame:CGRectMake(SC_DEVICE_SIZE.width-100, 0, 100, topFrame.size.height)];
        [editBt addTarget:self action:@selector(editRemark) forControlEvents:UIControlEventTouchUpInside];
        editBt.backgroundColor = [UIColor clearColor];
        editBt.titleLabel.textColor = [UIColor whiteColor];
        editBt.titleLabel.font = [UIFont systemFontOfSize:25.f];
        [_topContainerView addSubview:editBt];
        [editBt setTitle:@"编辑" forState:UIControlStateNormal];
        
    }
    [_topLbl setTitle:text forState:UIControlStateNormal];
}


//bottomContainerView，总体
- (void)addbottomContainerView {
    CGFloat bottomY = self.view.frame.size.height - 150;
    
    //    CGFloat bottomY = _captureManager.previewLayer.frame.origin.y + _captureManager.previewLayer.frame.size.height;
    CGRect bottomFrame = CGRectMake(0, bottomY, SC_DEVICE_SIZE.width, 150);
    
    UIView *view = [[UIView alloc] initWithFrame:bottomFrame];
    //    view.backgroundColor = bottomContainerView_UP_COLOR;
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [self.view addSubview:view];
    self.bottomContainerView = view;
}

//拍照菜单栏
- (void)addCameraMenuView {
    
    //拍照按钮
    //    CGFloat downH = (isHigherThaniPhone4_SC ? CAMERA_MENU_VIEW_HEIGH : 0);
    CGFloat cameraBtnLength = 90;
    
    
    [self buildButton:CGRectMake((SC_DEVICE_SIZE.width - cameraBtnLength) / 2, (_bottomContainerView.frame.size.height  - cameraBtnLength) , cameraBtnLength, cameraBtnLength)
         normalImgStr:@"shot.png"
      highlightImgStr:@"shot_h.png"
       selectedImgStr:@""
               action:@selector(save)
           parentView:_bottomContainerView];
    
    
    
    //    //拍照的菜单栏view（屏幕高度大于480的，此view在上面，其他情况在下面）
    //    CGFloat menuViewY = (isHigherThaniPhone4_SC ? SC_DEVICE_SIZE.height - CAMERA_MENU_VIEW_HEIGH : 0);
    //    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, menuViewY, self.view.frame.size.width, CAMERA_MENU_VIEW_HEIGH)];
    //    menuView.backgroundColor = (isHigherThaniPhone4_SC ? bottomContainerView_DOWN_COLOR : [UIColor clearColor]);
    //    [self.view addSubview:menuView];
    //    self.cameraMenuView = menuView;
    //    [self addMenuViewButtons];
}

- (void)addSubjectView
{
    CGRect bottomFrame = _bottomContainerView.frame;
    CGRect subjectFrame = CGRectMake( 0, bottomFrame.size.height-130, SC_DEVICE_SIZE.width, 30);
    _subjectView = [[ButtonGroup alloc]initWithFrame:subjectFrame];
    [_bottomContainerView addSubview:_subjectView];
    
    
    _subjects = [[QuestionBook getInstance]getMySubjects];
    CGFloat buttonWidth = (SC_DEVICE_SIZE.width-16)/4.0;
    NSMutableArray* buttonArrays = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < _subjects.count ; i++) {
        Subject* subject = [_subjects objectAtIndex:i];
        CGRect frame = CGRectMake(5+i*(buttonWidth+4), 0, buttonWidth, 30);
        UIButton* button = [[UIButton alloc]initWithFrame:frame];
        [button setTitle:subject.name forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%@✓",subject.name] forState:UIControlStateSelected];
        [button setTag:subject.type];
        [_subjectView addSubview:button];
        [button.titleLabel setTextColor:[UIColor blueColor]];
//        [button setBackgroundColor:[UIColor whiteColor]];
        [buttonArrays addObject:button];
    }
    [_subjectView loadButton:buttonArrays];
}

- (UIButton*)buildButton:(CGRect)frame
            normalImgStr:(NSString*)normalImgStr
         highlightImgStr:(NSString*)highlightImgStr
          selectedImgStr:(NSString*)selectedImgStr
                  action:(SEL)action
              parentView:(UIView*)parentView {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (normalImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:normalImgStr] forState:UIControlStateNormal];
    }
    if (highlightImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:highlightImgStr] forState:UIControlStateHighlighted];
    }
    if (selectedImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:selectedImgStr] forState:UIControlStateSelected];
    }
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:btn];
    
    return btn;
}


- (void)save
{
    NSData *data;
    if (UIImagePNGRepresentation(_postImage) == nil) {
        
        data = UIImageJPEGRepresentation(_postImage, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(_postImage);
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyyMMddHHmmss"];
    
    NSString* fileName  = [[NSString stringWithFormat:@"%@%@.png",[ToolUtils getUserid],[dateFormatter stringFromDate:[NSDate date]]]stringByReplacingOccurrencesOfString:@" " withString:@""];
    [ToolUtils save:data name:fileName];
    NSError* error;
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    Question* question=(Question *)[NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:helper.managedObjectContext];
    Subject* subject =[_subjects objectAtIndex:[_subjectView selectedIndex]];
    question.questionid = fileName;
    question.subject = subject.name;
    question.type = [NSNumber numberWithInteger :subject.type];
    question.is_highlight = [NSNumber numberWithInt:0];
    question.is_recommand = [NSNumber numberWithInt:1];
    question.img = fileName;
    question.userid = [ToolUtils getUserid];
    question.review_time = 0;
    question.is_master = NO;
    question.isUpload = NO;
    question.review_time = [NSNumber numberWithInt:0];
    question.myDay = [NSString stringWithFormat:@"%d",[ToolUtils getCurrentDay].intValue];
    question.create_time = [ToolUtils getCurrentDate];
    question.remark = self.markLabel.text;
    question.orientation = [NSNumber numberWithInt:1];
    self.question = question;
    BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful! Insert A New Question");
        [[QuestionBook getInstance]insertNewQuestion:question];
        [[[MImgUpload alloc]init]load:self img:_postImage name:fileName];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
        }];
     
    }
}

- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MImgUpload"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            self.question.img = ret.msg_;
            [[[MUploadQues alloc]init]load:self question:self.question];
        }
    } else if ([names isEqualToString:@"MUploadQues"])
    {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            self.question.isUpload=[NSNumber numberWithBool:YES];
            NSError* error;
            CoreDataHelper* helper = [CoreDataHelper getInstance];
            BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
            if (!isSaveSuccess) {
                NSLog(@"Error:%@",error);
            }else{
                NSLog(@"Save successful! Question is Upload");
            }
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}



- (void)editRemark
{
    if (!_eidtView) {
        CGRect frame = CGRectMake(0, SC_DEVICE_SIZE.height, SC_DEVICE_SIZE.width, 200);
        _eidtView = [[UIView alloc]initWithFrame:frame];
        [self.view addSubview:_eidtView];
        
        CGRect textFrame = CGRectMake(0, 50, SC_DEVICE_SIZE.width, 160);
        
        _editTextView = [[UITextView alloc]initWithFrame:textFrame];
        [_eidtView addSubview:_editTextView];
        
        
        CGRect leftBtFrame = CGRectMake(5, 0, 50, 50);
        UIButton* cancelButton = [[UIButton alloc]initWithFrame:leftBtFrame];
        [cancelButton addTarget:self action:@selector(cancelEdit) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton.titleLabel setTextColor:[UIColor blueColor]];
        [_eidtView addSubview:cancelButton];
    
        CGRect rightBtFrame = CGRectMake(SC_DEVICE_SIZE.width-55, 5, 50, 50);
        UIButton* saveButton = [[UIButton alloc]initWithFrame:rightBtFrame];
        [saveButton addTarget:self action:@selector(saveRemark) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton.titleLabel setTextColor:[UIColor blueColor]];

        [_eidtView addSubview:saveButton];
    }
    
    [self.editTextView becomeFirstResponder];
    CGRect frame = _eidtView.frame;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        NSLog(@"%lf",-frame.size.height-(keyboardHeight==0?240:keyboardHeight));
        self.eidtView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height-(keyboardHeight==0?240:keyboardHeight));
    } completion:^(BOOL finished) {
        //        [self.keyboardBt setHidden:NO];
    }];

}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    keyboardHeight = keyboardSize.height;
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.eidtView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)cancelEdit
{
    [self.editTextView resignFirstResponder];
}

-(void)saveRemark
{
    [self.editTextView resignFirstResponder];
    
    
    
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = CGSizeMake(SC_DEVICE_SIZE.width,2000);
    CGSize labelsize = [self.editTextView.text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"labelheight%lf",labelsize.height);
    
    
    CGRect frame = CGRectMake(0, SC_DEVICE_SIZE.height-_bottomContainerView.frame.size.height-labelsize.height-20, SC_DEVICE_SIZE.width, labelsize.height+20);
    if (!_labelView) {
        _labelView = [[UIView alloc]initWithFrame:frame];
        [self.view addSubview:_labelView];
        _labelView.backgroundColor = [UIColor blackColor];
        _labelView.alpha = 0.5;
    } else {
        [_labelView setFrame:frame];
        [_labelView setNeedsDisplay];
    }
    
    CGRect markFrame = CGRectMake(5, 5, SC_DEVICE_SIZE.width-10,labelsize.height+10);
    if (!_markLabel) {
        _markLabel = [[UILabel alloc]initWithFrame:markFrame];
        [_markLabel setText:_editTextView.text];
        [_markLabel setNumberOfLines:0];
        [_markLabel setFont:font];
        [_markLabel setTextColor:[UIColor whiteColor]];
        [_labelView addSubview:_markLabel];
    } else {
        [_markLabel setText:_editTextView.text];
        [_markLabel setFrame:markFrame];
        [_markLabel setNeedsDisplay];
    }

}

@end
