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
#import <CoreMotion/CoreMotion.h>
@interface PostViewController ()<ButtonGroupDelegate>
{
    int orientation;
}
@property (nonatomic, strong) UIView *topContainerView;//顶部view
@property (nonatomic,strong)UIView* bottomContainerView;
@property (nonatomic, strong) UIButton *topLbl;//顶部的标题
@property (nonatomic,strong)NSArray* subjects;
@property (nonatomic,strong)UIView* editView;
@property (nonatomic,strong)UITextView* editTextView;
@property (nonatomic,strong)ButtonGroup* subjectView;
@property (nonatomic,strong)ButtonGroup* subjectBackView;

@property (nonatomic,strong)Question* question;
@property (nonatomic,strong)UITextView* markLabel;
@property (nonatomic,strong)UIView* labelView;
@property (nonatomic,strong)CMMotionManager* motionManager;
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
//- (UIImage*)brighten:(UIImage*)selectedImage
//{
//    CIFilter* _colorControlsFilter = [CIFilter filterWithName:@"CIColorControls"];
//    CIImage* _image =[CIImage imageWithCGImage:selectedImage.CGImage];
//    [_colorControlsFilter setValue:_image forKey:@"inputImage"];
//    [_colorControlsFilter setValue:[NSNumber numberWithFloat:1.2] forKey:@"inputContrast"];
//    CIImage *outputImage= [_colorControlsFilter outputImage];//取得输出图像
//    CIContext *_context=[CIContext contextWithOptions:nil];//使用GPU渲染，推荐,但注意GPU的CIContext无法跨应用访问，例如直接在UIImagePickerController的完成方法中调用上下文处理就会自动降级为CPU渲染，所以推荐现在完成方法中保存图像，然后在主程序中调用
//    CGImageRef temp=[_context createCGImage:outputImage fromRect:[outputImage extent]];
//
//    UIImage* returnImage = [UIImage imageWithCGImage:temp];
//    CGImageRelease(temp);//释放CGImage对象
//    return returnImage;
//}

- (void)initViews
{
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    _motionManager = [[CMMotionManager alloc]init];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [self.motionManager startAccelerometerUpdatesToQueue: queue
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 
                                                 NSLog(@"X = %.04f, Y = %.04f, Z = %.04f",accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z);
                                                 if (accelerometerData.acceleration.x < -0.5) {
                                                     orientation = 3;
                                                 } else if (accelerometerData.acceleration.x > 0.5)
                                                 {
                                                     orientation = 4;
                                                 }
                                                 {
                                                     orientation = 1;
                                                 }
                                             }];

    
    [self addTopViewWithText:@"重拍"];
    [self addbottomContainerView];
    [self addCameraMenuView];
    [self addSubjectView];
    [self orientChange:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self animationWithOrient:orientation];
    [_motionManager stopAccelerometerUpdates];
}

- (void)orientChange:(NSNotification *)noti

{
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    [self animationWithOrient:orient];
}

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;   //返回的就是已经改变的图片
}


- (void)animationWithOrient:(UIDeviceOrientation)orient
{
    NSArray* angle = @[@0,@0,@M_PI,@M_PI_2,@-M_PI_2,@0,@0];
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView* view in _bottomContainerView.subviews) {
            if (view==_markLabel) {
                continue;
            }
            if (view.subviews.count==0) {
                
                view.transform = CGAffineTransformMakeRotation([angle[orient]floatValue]);

            } else {
                for (UIView* subView in view.subviews) {
                    subView.transform = CGAffineTransformMakeRotation([angle[orient]floatValue]);
                }
            }
        }
        for (UIView* view in _topContainerView.subviews) {
            view.transform = CGAffineTransformMakeRotation([angle[orient]floatValue]);

        }
    }];
    
}

#pragma mark -------------UI---------------
//顶部标题
- (void)addTopViewWithText:(NSString*)text {
    if (!_topContainerView) {
        CGRect topFrame = CGRectMake(0, 0, SC_DEVICE_SIZE.width, 64);
        
        UIView *tView = [[UIView alloc] initWithFrame:topFrame];
        tView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tView];
        self.topContainerView = tView;
        self.topContainerView.backgroundColor = [UIColor blackColor];
        self.topContainerView.alpha = 0.4;
//        UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, topFrame.size.width, topFrame.size.height)];
//        emptyView.backgroundColor = [UIColor blackColor];
//        emptyView.alpha = 0.4f;
//        [_topContainerView addSubview:emptyView];
        
        topFrame.origin.x += 10;
        UIButton *lbl = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 48, topFrame.size.height-20)];
        [lbl addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [lbl setImage:[UIImage imageNamed:@"重拍按钮"] forState:UIControlStateNormal];
        [_topContainerView addSubview:lbl];
        self.topLbl = lbl;
        
        
        UIButton *editBt = [[UIButton alloc] initWithFrame:CGRectMake(SC_DEVICE_SIZE.width-55, 20, 40, topFrame.size.height-20)];
        [editBt addTarget:self action:@selector(editRemark) forControlEvents:UIControlEventTouchUpInside];
        [editBt setImage:[UIImage imageNamed:@"备注按钮"] forState:UIControlStateNormal];
        [_topContainerView addSubview:editBt];
        
    }
}


//bottomContainerView，总体
- (void)addbottomContainerView {
    CGFloat bottomY = self.view.frame.size.height - 153;
    
    //    CGFloat bottomY = _captureManager.previewLayer.frame.origin.y + _captureManager.previewLayer.frame.size.height;
    CGRect bottomFrame = CGRectMake(0, bottomY, SC_DEVICE_SIZE.width, 153);
    
    UIView *view = [[UIView alloc] initWithFrame:bottomFrame];
    //    view.backgroundColor = bottomContainerView_UP_COLOR;
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.45;
    [self.view addSubview:view];
    self.bottomContainerView = view;
}

//拍照菜单栏
- (void)addCameraMenuView {
    
    //拍照按钮
    //    CGFloat downH = (isHigherThaniPhone4_SC ? CAMERA_MENU_VIEW_HEIGH : 0);
    CGFloat cameraBtnLength = 80;
    
    
    [self buildButton:CGRectMake((SC_DEVICE_SIZE.width - cameraBtnLength) / 2, (_bottomContainerView.frame.size.height  - cameraBtnLength) , cameraBtnLength, cameraBtnLength)
         normalImgStr:@"拍照-确认"
      highlightImgStr:@""
       selectedImgStr:@""
               action:@selector(save)
           parentView:_bottomContainerView];
}



- (void)addSubjectView
{
    CGRect bottomFrame = _bottomContainerView.frame;
    CGRect subjectFrame = CGRectMake( 0, 0, SC_DEVICE_SIZE.width, 65);
    _subjectView = [[ButtonGroup alloc]initWithFrame:subjectFrame];
    _subjectBackView = [[ButtonGroup alloc]initWithFrame:subjectFrame];
    [_bottomContainerView addSubview:_subjectBackView];
    [_bottomContainerView addSubview:_subjectView];
    
    _subjects = [[QuestionBook getInstance]getMySubjects];
    CGFloat buttonWidth = (SC_DEVICE_SIZE.width-16)/4.0;
    NSMutableArray* buttonArrays = [[NSMutableArray alloc]init];
    NSMutableArray* buttonBackArrays = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < _subjects.count ; i++) {
        Subject* subject = [_subjects objectAtIndex:i];
        CGRect frame = CGRectMake(5+i*(buttonWidth+4), 0, buttonWidth, buttonWidth);
        UIButton* button = [[UIButton alloc]initWithFrame:frame];
        [button setTitle:subject.firstStr forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button.titleLabel setFont:[UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:25]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHex:0x585858] forState:UIControlStateSelected];
        [button setTag:subject.type];
        UIButton* backButton = [[UIButton alloc]initWithFrame:frame];
        [backButton setImage:[UIImage imageNamed:@"线圈"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"实圆"] forState:UIControlStateSelected];
        [backButton setTag:subject.type];
        
        
        [_subjectView addSubview:backButton];
        [_subjectView addSubview:button];
        [buttonArrays addObject:button];
        [buttonBackArrays addObject:backButton];
    }
    [_subjectView loadButton:buttonArrays];
    _subjectView.delegate = self;
    [_subjectBackView loadButton:buttonBackArrays];
}


- (void)selectIndex:(NSInteger)index name:(NSString *)buttonName
{
    [_subjectBackView setSelectedIndex:index];
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
    _postImage = [self useImage:_postImage];
    if (UIImagePNGRepresentation(_postImage) == nil) {
        data = UIImageJPEGRepresentation(_postImage, 1);
    } else {
        data = UIImagePNGRepresentation(_postImage);
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyyMMddHHmmss"];
    
    NSString* fileName  = [[NSString stringWithFormat:@"%@%@.png",[ToolUtils getUserid],[dateFormatter stringFromDate:[NSDate date]]]stringByReplacingOccurrencesOfString:@" " withString:@""];
    [ToolUtils save:data name:fileName];
    
    
    NSString* thumbNailFileName = [[NSString stringWithFormat:@"%@%@_thumb.png",[ToolUtils getUserid],[dateFormatter stringFromDate:[NSDate date]]]stringByReplacingOccurrencesOfString:@" " withString:@""];
    UIImage *image = [self OriginImage:_postImage scaleToSize:CGSizeMake(130, _postImage.size.height/_postImage.size.width*130)];
    [ToolUtils save:UIImageJPEGRepresentation(image, 1) name:thumbNailFileName];
    NSError* error;
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    Question* question=(Question *)[NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:helper.managedObjectContext];
    Subject* subject =[_subjects objectAtIndex:[_subjectView selectedIndex]];
    question.thumb_img = thumbNailFileName;
    question.questionid = fileName;
    question.subject = subject.name;
    question.type = [NSNumber numberWithInteger :subject.type];
    question.is_highlight = [NSNumber numberWithInt:0];
    question.is_recommand = [NSNumber numberWithInt:1];
    question.img = fileName;
    question.userid = [ToolUtils getUserid];
    question.review_time = 0;
    question.is_master = @NO;
    question.isUpload = @NO;
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
        [self backBtnPressed:nil];
    }
}

- (UIImage *)useImage:(UIImage *)image {
    CGSize newSize = CGSizeMake(SC_DEVICE_SIZE.width*1.5,SC_DEVICE_SIZE.height*1.5);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
    [self addMask];
    if (!_editView) {
        CGRect frame = CGRectMake(0, SC_DEVICE_SIZE.height, SC_DEVICE_SIZE.width, 160);
        _editView = [[UIView alloc]initWithFrame:frame];
        _editView.backgroundColor = [UIColor whiteColor];
        [self.navigationController.view addSubview:_editView];
        CGRect textFrame = CGRectMake(0, 50, SC_DEVICE_SIZE.width, 110);
        
        _editTextView = [[UITextView alloc]initWithFrame:textFrame];
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
        [saveButton addTarget:self action:@selector(saveRemark) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitleColor: [UIColor colorWithRed:31/255.0 green:118/255.0 blue:220/255.0 alpha:1] forState:UIControlStateNormal];
        [_editView addSubview:saveButton];
    }
    _editTextView.text = self.markLabel.text;
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

-(void)saveRemark
{
    [self.editTextView resignFirstResponder];
    
    
    
    UIFont *font = [UIFont fontWithName:@"FZLanTingHeiS-EL-GB" size:16];
    CGSize size = CGSizeMake(SC_DEVICE_SIZE.width-50,2000);
    CGSize labelsize = [self.editTextView.text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"labelheight%lf",labelsize.height);
    labelsize.height = MIN(labelsize.height,73);

    
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
    CGRect markFrame = CGRectMake(25, 5, SC_DEVICE_SIZE.width-50,labelsize.height+10);
    if (!_markLabel) {
        _markLabel = [[UITextView alloc]initWithFrame:markFrame];
        [_markLabel setText:_editTextView.text];
        [_markLabel setFont:font];
        [_markLabel setTextColor:[UIColor whiteColor]];
        [_markLabel setBackgroundColor:[UIColor clearColor]];
        [_labelView addSubview:_markLabel];
    } else {
        [_markLabel setText:_editTextView.text];
        [_markLabel setFrame:markFrame];
        [_markLabel setNeedsDisplay];
    }
    
    
    

}

@end
