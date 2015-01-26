//
//  essencePostViewController.m
//  graduate
//
//  Created by Sylar on 26/1/15.
//  Copyright (c) 2015 nju.excalibur. All rights reserved.
//

#import "essencePostVC.h"

@interface essencePostVC ()

@property NSMutableArray *titleArray;
@property NSMutableArray *detailArray;

@end

@implementation essencePostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _titleArray = [[NSMutableArray alloc] initWithObjects:@"2016年考研精品视频", @"2016年考研精品视频", @"2016年考研精品视频", @"2016年考研精品视频", @"2016年考研精品视频", nil];
    _detailArray = [[NSMutableArray alloc] initWithObjects:@"来自王小丫的分享", @"来自王小丫的分享", @"来自王小丫的分享", @"来自王小丫的分享", @"来自王小丫的分享", nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_titleArray count] + 1;
}

#pragma mark - Acquire Post Data
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Essence Post Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.row == 0) {
        UIButton* button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button1.frame = CGRectMake(100, 30, 50, 10);
        [button1 setTitle:@"资料" forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell addSubview:button1];
        
        
        UIButton* button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button2.frame = CGRectMake(150, 30, 50, 10);
        [button2 setTitle:@"资讯" forState:UIControlStateNormal];
        [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell addSubview:button2];
        
        UIButton* button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button3.frame = CGRectMake(200, 30, 50, 10);
        [button3 setTitle:@"真题" forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell addSubview:button3];
        
        
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
    }else{
        cell.textLabel.text = [_titleArray objectAtIndex:(indexPath.row - 1)];
        cell.detailTextLabel.text = [_detailArray objectAtIndex:(indexPath.row - 1)];
    }

    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
