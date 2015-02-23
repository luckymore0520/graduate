//
//  OtherFuncVCViewController.m
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "OtherFuncVCViewController.h"
#import "SelfCenterViewController.h"
#import "FeedBackViewController.h"
#import "CoreDataHelper.h"
#import "Trace.h"
#import "UIImageView+LBBlurredImage.h"
#import "QuestionBook.h"
#import "MGetMsgCount.h"
#import "MMsgCount.h"
@interface OtherFuncVCViewController ()
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *sentenceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *originImageView;
@property (weak, nonatomic) IBOutlet UIImageView *dotImageForEssence;
@property (weak, nonatomic) IBOutlet UIImageView *dotImageForSquare;
@property (weak, nonatomic) IBOutlet UILabel *dotLabelForEssence;
@property (nonatomic,strong)NSArray* monthArr;
@property (weak, nonatomic) IBOutlet UILabel *dotLabelForSquare;
@end

@implementation OtherFuncVCViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _monthArr = [NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec", nil];
    [_dotLabelForEssence setHidden:YES];
    [_dotLabelForSquare setHidden:YES];
    [_dotImageForEssence setHidden:YES];
    [_dotImageForSquare setHidden:YES];
    
    NSString* today = [ToolUtils getCurrentDate];
    NSArray* seperateDate = [today componentsSeparatedByString:@"-"];
    NSString* month = [self.monthArr objectAtIndex:[[seperateDate objectAtIndex:1]integerValue]-1];
    [self.monthLabel setText:month];
    [self.yearLabel setText:[seperateDate firstObject]];
    [self.dayLabel setText:[seperateDate objectAtIndex:2]];
    
    
    if (self.view.frame.size.width<350) {
        self.view.transform = CGAffineTransformMakeScale(0.85, 0.85);
    }
    
    NSArray* array = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"myDay=%@ and user=%@",[NSString stringWithFormat:@"%d",[ToolUtils getCurrentDay].integerValue],[ToolUtils getUserid]] tableName:@"Trace"];
    if (array.count==0) {
        [self.backImageView setImage:[UIImage imageNamed:@"首页1.png"]];
    } else {
        Trace* trace = [array firstObject];
        [self.sentenceLabel setText:trace.content];
        [self.originImageView sd_setImageWithURL:[ToolUtils getImageUrlWtihString:trace.pictureUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.backImageView setContentMode:UIViewContentModeScaleAspectFill];
            [self.backImageView setImageToBlur:image blurRadius:8 completionBlock:nil];
            [self.backImageView setClipsToBounds:YES];

        }];
    }

    [[[MGetMsgCount alloc]init]load:self];
    
    // Do any additional setup after loading the view.
}


-(void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqual:@"MGetMsgCount"]) {
        MMsgCount* msg = [MMsgCount objectWithKeyValues:data];
        if (msg.essence_.integerValue>0) {
            [_dotLabelForEssence setHidden:NO];
            [_dotImageForEssence setHidden:NO];
            [_dotLabelForEssence setText:[NSString stringWithFormat:@"%d",msg.essence_.integerValue]];
            if (msg.essence_.integerValue>=10) {
                [_dotImageForEssence setImage:[UIImage imageNamed:@"大红点"]];
            } else {
                [_dotImageForEssence setImage:[UIImage imageNamed:@"小红点2"]];
            }
        }
        
        
        if (msg.square_.integerValue>0) {
            [_dotLabelForSquare setHidden:NO];
            [_dotImageForSquare setHidden:NO];
            [_dotLabelForSquare setText:[NSString stringWithFormat:@"%d",msg.square_.integerValue]];
            if (msg.square_.integerValue>=10) {
                [_dotImageForSquare setImage:[UIImage imageNamed:@"大红点"]];
            } else {
                [_dotImageForSquare setImage:[UIImage imageNamed:@"小红点2"]];
            }
        }
    }
}
- (IBAction)goToPrint:(id)sender {
    if ([[QuestionBook getInstance]getMySubjects].count<4) {
        [ToolUtils showMessage:@"请先设置科目"];
        UIViewController* setSubject = [self.storyboard instantiateViewControllerWithIdentifier:@"setSubject"];
        [self.navigationController pushViewController:setSubject animated:YES];
        return;
        
    }
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"DiscoverStoryBoard" bundle:nil];
    
    UIViewController* nextVC = [storyboard instantiateViewControllerWithIdentifier:@"print"];
    [self.navigationController pushViewController:nextVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goToEssence:(id)sender {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"EssenceStoryboard" bundle:nil];
    
    UIViewController* nextVC = [storyboard instantiateViewControllerWithIdentifier:@"essenceRoot"];
    [self.navigationController pushViewController:nextVC animated:YES];

}
- (IBAction)goToBackUp:(id)sender {
    if ([[QuestionBook getInstance]getMySubjects].count<4) {
        [ToolUtils showMessage:@"请先设置科目"];
        UIViewController* setSubject = [self.storyboard instantiateViewControllerWithIdentifier:@"setSubject"];
        [self.navigationController pushViewController:setSubject animated:YES];
        return;
    }
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"DiscoverStoryBoard" bundle:nil];
    
    UIViewController* nextVC = [storyboard instantiateViewControllerWithIdentifier:@"backUp"];
    [self.navigationController pushViewController:nextVC animated:YES];
    
}
- (IBAction)goToSquare:(id)sender {
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"SquareStoryboard" bundle:nil];
    
    UIViewController* nextVC = [storyboard instantiateViewControllerWithIdentifier:@"square"];
    [self.navigationController pushViewController:nextVC animated:YES];
}
- (IBAction)goToFeedback:(id)sender {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"DiscoverStoryBoard" bundle:nil];
    
    SelfCenterViewController* nextVC = [storyboard instantiateViewControllerWithIdentifier:@"feedback"];
    [self.navigationController pushViewController:nextVC animated:YES];

}
- (IBAction)goToSelfCenter:(id)sender {
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"DiscoverStoryBoard" bundle:nil];
                                
    SelfCenterViewController* nextVC = [storyboard instantiateViewControllerWithIdentifier:@"selfCenter"];
    [self.navigationController pushViewController:nextVC animated:YES];

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
