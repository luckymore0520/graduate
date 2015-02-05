//
//  SelfEditViewController.m
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SelfEditViewController.h"
#import "SelfHeaderCell.h"
#import "SelfOtherCell.h"
#import "MUser.h"
#import "MUpdateUserInfo.h"
#import "MReturn.h"
@interface SelfEditViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)MUser* user;
@end

@implementation SelfEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)save:(id)sender {
    _user.nickname_ = ((SelfOtherCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]]).nickNameField.text;
    _user.sex_ =  [NSNumber numberWithInteger:((SelfOtherCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]]).cellBtGroup.selectedIndex];
    [ToolUtils setUserInfomation:_user.keyValues];
    [[[MUpdateUserInfo alloc]init]load:self nickname:_user.nickname_ headImg:_user.headImg_ sex:_user.sex_.integerValue email:_user.email_];
    
    
}


#pragma mark -ApiDelegate
-(void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MUpdateUserInfo"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [ToolUtils showMessage:@"修改失败，请重试"];
        }
    }
}

- (void)showError:(NSError *)error functionName:(NSString *)names
{
    [ToolUtils showMessage:@"请确认您的网络是否连接正常"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 100;
    } else {
        return 50;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    } else if (section==1){
        return 2;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        SelfHeaderCell* cell = [tableView dequeueReusableCellWithIdentifier:@"headerImg"];
        [cell.nickNameLabel setText:@"头像"];
        [cell.headImg sd_setImageWithURL:[ToolUtils getImageUrlWtihString:_user.headImg_ width:200 height:200] placeholderImage:nil];
        return cell;
    } else if (indexPath.section==1)
    {
        if (indexPath.row==0) {
            SelfOtherCell* cell = [tableView dequeueReusableCellWithIdentifier:@"nickName"];
            [cell.nickNameField setText:_user.nickname_];
            return cell;
        } else if (indexPath.row==1)
        {
             SelfOtherCell* cell = [tableView dequeueReusableCellWithIdentifier:@"sex"];
            [cell.cellBtGroup loadButton:[NSArray arrayWithObjects:cell.maleBt,cell.femaleBt, nil]];
            [cell.cellBtGroup setSelectedIndex:_user.sex_.integerValue];
            return cell;
        }
    }
    return nil;
}
@end
