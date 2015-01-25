//
//  GroupNameVC.m
//  graduate
//
//  Created by luck-mac on 15/1/16.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "GroupNameVC.h"
#import "CCPHelper.h"
#import "GroupMemberVC.h"
//#import "MyCCPNavigationVC.h"
@interface GroupNameVC ()<UITableViewDataSource,UITableViewDelegate,CCPHelperDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)CCPHelper* helper;

@end

@implementation GroupNameVC
@synthesize array = _array;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    _helper = [[CCPHelper alloc]init];
    _helper.delegate = self;
//    [((MyCCPNavigationVC*)self.navigationController)connectToServer];
//    _array =[ [NSArray alloc]initWithObjects:@"a",@"b",@"c",@"d",@"f", nil];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [_helper queryMyGroup];
}
//-(NSArray *)array
//{
//    if (!_array) {
//        _array =[ [NSArray alloc]initWithObjects:@"a",@"b",@"c",@"d",@"f", nil];
//    }
//    return _array;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"];
    [cell.textLabel setText:[[_array objectAtIndex:indexPath.row]objectForKey:@"name"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_array count];
}


-(void)reveiveData:(NSDictionary *)data method:(NSString *)method
{
    if ([method isEqualToString:@"queryMyGroup"]) {
        NSLog(@"%@",[data description]);
        _array = [[data objectForKey:@"groups"] objectForKey:@"groups"];
        [_tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"member" sender:[[_array objectAtIndex:indexPath.row]objectForKey:@"groupId"]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController class]==[GroupMemberVC class]) {
        ((GroupMemberVC*)segue.destinationViewController).groupId = (NSString*)sender;
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
