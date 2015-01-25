//
//  CreateGroupVC.m
//  graduate
//
//  Created by luck-mac on 15/1/18.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "CreateGroupVC.h"
#import "CCPHelper.h"
@interface CreateGroupVC ()<CCPHelperDelegate>
@property (nonatomic,strong)CCPHelper* helper;
@property (weak, nonatomic) IBOutlet UITextField *groupNameField;
@property (weak, nonatomic) IBOutlet UITextField *typeField;
@property (weak, nonatomic) IBOutlet UITextField *modelField;
@property (weak, nonatomic) IBOutlet UITextField *noticeField;
@end

@implementation CreateGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _helper =[[CCPHelper alloc]init];
    _helper.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)create:(id)sender {
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:_groupNameField.text,@"name",_typeField.text,@"type",_modelField.text,@"permission",_noticeField.text,@"declared", nil];
    [_helper createGroup:dic];
}

- (void)reveiveData:(NSDictionary *)data method:(NSString *)method
{
    if ([method isEqualToString:@"createGroup"]) {
        if ([data objectForKey:@"groupId"]) {
            [ToolUtils showMessage:@"创建成功"];
            [self.navigationController popViewControllerAnimated:YES];

        }
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
