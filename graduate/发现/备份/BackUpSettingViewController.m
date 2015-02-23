//
//  BackUpSettingViewController.m
//  graduate
//
//  Created by luck-mac on 15/2/23.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BackUpSettingViewController.h"
#import "BackUpSettingTableViewCell.h"
@interface BackUpSettingViewController ()
<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)BackUpSettingTableViewCell* selectedCell;
@end

@implementation BackUpSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"备份模式"];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BackUpSettingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
    if (indexPath.row==0) {
        [cell.nameLabel setText:@"云同步"];
        [cell.descriptionLabel setText:@"自动上传图片，确保不丢失"];
        [cell.selectImg setHidden:![ToolUtils ignoreNetwork]];
        if ([ToolUtils ignoreNetwork]) {
            self.selectedCell = cell;
        }
    } else
    {
        [cell.nameLabel setText:@"仅限Wi-Fi环境下上传"];
        [cell.descriptionLabel setText:@"连接Wi-Fi环境上传，节省流量"];
        [cell.selectImg setHidden:[ToolUtils ignoreNetwork]];
        if (![ToolUtils ignoreNetwork]) {
            self.selectedCell = cell;
        }
    }
    if (indexPath.row==1) {
        [cell.lineView setHidden:YES];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedCell.selectImg setHidden:YES];
    
    BackUpSettingTableViewCell* cell = (BackUpSettingTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.selectImg setHidden:NO];
    self.selectedCell = cell;
    
    if (indexPath.row==0) {
        [ToolUtils setIgnoreNetwork:YES];
    } else {
        [ToolUtils setIgnoreNetwork:NO];
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
