//
//  GroupMemberVC.m
//  graduate
//
//  Created by luck-mac on 15/1/18.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "GroupMemberVC.h"
#import "CCPHelper.h"
@interface GroupMemberVC ()<CCPHelperDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) CCPHelper* helper;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray* array;
@end

@implementation GroupMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _helper = [[CCPHelper alloc]init];
    _helper.delegate = self;
    [_helper queryGroupMember:_groupId];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reveiveData:(NSDictionary *)data method:(NSString *)method
{
    if ([method isEqualToString:@"queryGroupMember"]) {
        NSLog(@"%@",[data description]);
        _array = [[data objectForKey:@"members"]objectForKey:@"member"];
        
        [self.tableView reloadData];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"groupMember"];
    [cell.textLabel setText:[[_array objectAtIndex:indexPath.row]objectForKey:@"voipAccount"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];
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
