//
//  EssencePostDetailVCViewController.m
//  graduate
//
//  Created by Sylar on 3/2/15.
//  Copyright (c) 2015 nju.excalibur. All rights reserved.
//

#import "EssencePostDetailVC.h"
#import "MDetailEssence.h"
#import "MEssenceDetail.h"

@interface EssencePostDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *detailText;
@property (nonatomic, strong) MDetailEssence *detail;
@end

@implementation EssencePostDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    MEssenceDetail* essenceDetail = [[MEssenceDetail alloc] init];
    [essenceDetail load:self id:_detailId];
    [self updateInfo];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateInfo{
    
}


- (IBAction)star {
}

- (IBAction)download {
}



#pragma mark - ApiDelegate
- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if([names isEqualToString:@"MEssenceDetail"]){
        _detail = [MDetailEssence objectWithKeyValues:data];
    }
}

- (void)showAlert:(NSString *)alert
{
    [ToolUtils showMessage:alert];
}

- (void)showError:(NSError *)error functionName:(NSString *)names
{
    [ToolUtils showMessage:[error description]];
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
