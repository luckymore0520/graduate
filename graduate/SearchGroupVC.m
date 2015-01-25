//
//  SearchGroupVC.m
//  graduate
//
//  Created by luck-mac on 15/1/18.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "SearchGroupVC.h"
#import "CCPHelper.h"
@interface SearchGroupVC ()<UITableViewDelegate,UITableViewDataSource,CCPHelperDelegate>
@property (weak, nonatomic) IBOutlet UITextField *groupId;
@property (weak, nonatomic) IBOutlet UITextField *groupName;
@property(nonatomic,strong)CCPHelper* helper;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray* array;
@end


@implementation SearchGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _helper = [[CCPHelper alloc]init];
    _helper.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)search:(id)sender {
    _array = nil;
    NSString* groupId = _groupId.text;
    NSString* groupName = _groupName.text;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    if (groupId.length>0) {
        [dic setObject:groupId forKey:@"groupId"];
    }
    if (groupName.length>0) {
        [dic setObject:groupName forKey:@"name"];
    }
    [_helper searchGroup:dic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* groupId = [[_array objectAtIndex:indexPath.row]objectForKey:@"groupId"];
    [_helper joinGroup:[NSDictionary dictionaryWithObjectsAndKeys:groupId,@"groupId", nil]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"groupName"];
    [cell.textLabel setText:[[_array objectAtIndex:indexPath.row]objectForKey:@"name"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_array count];
}
- (void)reveiveData:(NSDictionary *)data method:(NSString *)method
{
    if ([method isEqualToString:@"searchGroup"]) {
        if ([[data objectForKey:@"groups"]objectForKey:@"groups"]) {
            _array = [[data objectForKey:@"groups"]objectForKey:@"groups"];
            [_tableView reloadData];
        }
    } else if ([method isEqualToString:@"joinGroup"]){
        if ([[data objectForKey:@"statusCode"]isEqualToString:@"000000"]) {
            [ToolUtils showMessage:@"申请成功"];
        }
        NSLog(@"%@",[data description]);
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
