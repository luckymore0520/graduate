//
//  MyCollectionViewController.m
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MMyEssences.h"
#import "MEssenceList.h"
#import "EssenceListCell.h"
#import "EssenceDetailWebViewController.h"
#import "EssenceDetailViewController.h"
@interface MyCollectionViewController ()
@property (nonatomic,strong)NSMutableArray* myEssences;
@property (nonatomic,strong)NSArray* typeArray;
@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myEssences = [[NSMutableArray alloc]init];
    self.typeArray = @[@"资料",@"资讯",@"真题"];
    // Do any additional setup after loading the view.
}


- (void)loadData
{
    MMyEssences* myEssences = [[MMyEssences alloc]init];
    myEssences = (MMyEssences*)[myEssences setPage:page limit:pageCount];
    [myEssences load:self];
}

- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MMyEssences"]) {
        MEssenceList* essenceList = [MEssenceList objectWithKeyValues:data];
        for (MEssence* essence in essenceList.essence_) {
            BOOL has = NO;
            
            for (MEssence* currentEssence in self.myEssences) {
                if ([currentEssence.id_ isEqualToString:essence.id_]) {
                    has = YES;
                    break;
                }
            }
            if (!has) {
                [self.myEssences addObject:essence];
            }
        }
        if (page==1) {
            [self doneWithView:_header];
        } else {
            [self doneWithView:_footer];
        }
    }
}


#pragma mark -TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myEssences.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EssenceListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"essence"];
    MEssence* essence = [self.myEssences objectAtIndex:indexPath.row];
    [cell.essenceTitleLabel setText:essence.title_];
    [cell.essenceSourceLabel setText:[NSString stringWithFormat:@"来自网友%@的分享",essence.source_]];
    [cell.essenceTimeLabel setText:[NSString stringWithFormat:@"%@",essence.time_]];
    [cell.essenceTypeImage setImage:[UIImage imageNamed:_typeArray[essence.type_.integerValue]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MEssence* essence = [self.myEssences objectAtIndex:indexPath.row];
    if (essence.hasDownload_.integerValue==1) {
        [self performSegueWithIdentifier:@"showDetail" sender:essence];
    } else {
        [self performSegueWithIdentifier:@"showWebDetail" sender:essence];
    }
}


#pragma mark -Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        EssenceDetailViewController* nextVC = (EssenceDetailViewController*)segue.destinationViewController;
        nextVC.essence = sender;
    } else if ([segue.identifier isEqualToString:@"showWebDetail"])
    {
        EssenceDetailWebViewController* nextVC = (EssenceDetailWebViewController*)segue.destinationViewController;
        MEssence* essence = (MEssence*)sender;
        nextVC.url = [NSURL URLWithString:essence.url_];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
