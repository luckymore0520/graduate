//
//  EssenceListViewController.m
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "EssenceListViewController.h"
#import "EssenceListCell.h"
#import "ButtonGroup.h"
#import "MGetEssenceList.h"
#import "MEssenceList.h"
#import "MUpdateUserInfo.h"
#import "MUser.h"
#import "MKeys.h"
#import "MEssenceDownload.h"
#import "EssenceDetailViewController.h"
#import "EssenceDetailWebViewController.h"
#import "MRecommendKeys.h"
@interface EssenceListViewController ()<ButtonGroupDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *searchTable;
@property (weak, nonatomic) IBOutlet UIButton *latestBt;
@property (weak, nonatomic) IBOutlet UIButton *dataBt;
@property (weak, nonatomic) IBOutlet UIButton *questionBt;
@property (weak, nonatomic) IBOutlet ButtonGroup *typeGroup;
@property (weak, nonatomic) IBOutlet UIButton *infomationBt;
@property (nonatomic,strong)NSArray* buttonArray;
@property (nonatomic,strong)NSMutableArray* essenceList;
@property (nonatomic,strong)UIView* editView;
@property (nonatomic,strong)UITextField* editTextView;
@property (nonatomic,strong)MUser* user;
@property (nonatomic,strong)UIAlertView* emailAlert;
@property (nonatomic,strong)UIAlertView* shareAlert;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic,strong)NSMutableArray* searchArray;
@property (nonatomic,strong)MEssence* selectEssence;
@end

@implementation EssenceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonArray = [NSArray arrayWithObjects:_latestBt,_infomationBt,_dataBt,_questionBt,nil];
    [self.typeGroup loadButton:self.buttonArray];
    self.typeGroup.delegate = self;
    self.essenceList = [[NSMutableArray alloc]init];
    _user = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
    self.textFields = [NSArray arrayWithObjects:_searchTextField, nil];
    [self addRightButton:@"搜索" action:@selector(search) img:nil];
    // Do any additional setup after loading the view.
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    
    if (string.length>0) {
        [self.clearButton setHidden:NO];
        [[[MRecommendKeys alloc]init]load:self key:self.searchTextField.text];
    } else {
        [self.searchArray removeAllObjects];
        [self.searchTable reloadData];
        [self.clearButton setHidden:YES];

    }
    return YES;
}

- (IBAction)cancelSearch:(id)sender {

    [self.searchTable setHidden:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.searchView.transform  = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [self.navigationController setNavigationBarHidden:NO];
        [self.tableView setHidden:NO];
        [self.typeGroup setHidden:NO];
        

    }];
}
- (IBAction)searchResult:(id)sender {
}

- (void)search
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.tableView setHidden:YES];
    [self.typeGroup setHidden:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.searchView.transform  = CGAffineTransformMakeTranslation(0, 50);
    } completion:^(BOOL finished) {
        [self.searchTable setHidden:NO];

    }];
}
- (void)loadData
{

    MGetEssenceList* getEssenceList = [[MGetEssenceList alloc]init];
    getEssenceList = (MGetEssenceList*)[getEssenceList setPage:page limit:pageCount];
    UIButton* button = [self.buttonArray objectAtIndex:[self.typeGroup selectedIndex]];
    [getEssenceList load:self type:button.tag key:nil];
}

- (void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MEssenceList"]) {
        MEssenceList* essences = [MEssenceList objectWithKeyValues:data];
        for (MEssence* essence in essences.essence_) {
            BOOL has = NO;

            for (MEssence* currentEssence in self.essenceList) {
                if ([currentEssence.id_ isEqualToString:essence.id_]) {
                    has = YES;
                    break;
                }
            }
            if (!has) {
                [self.essenceList addObject:essence];
            }
        }
        if (page==1) {
            [self doneWithView:_header];
        } else {
            [self doneWithView:_footer];
        }
    } else if ([names isEqualToString:@"MEssenceDownload"])
    {
        [ToolUtils showToast:@"已发送至您的邮箱" toView:self.view];
    } else if ([names isEqualToString:@"MRecommendKeys"])
    {
        
        MKeys* keys = [MKeys objectWithKeyValues:data];
        if (keys.key_.count>0) {
            self.searchArray = keys.key_;
            [self.searchTable reloadData];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)download:(id)sender {
    UIButton* button = (UIButton*)sender;
    MEssence* essence = [self.essenceList objectAtIndex:button.tag];
    self.selectEssence = essence;
    if (!_user.email_||_user.email_.length==0) {
        if (!self.emailAlert) {
            _emailAlert = [[UIAlertView alloc]initWithTitle:@"设置邮箱" message:@"下载前请先设置邮箱" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        }
        [_emailAlert show];
        return;
    } else if (essence.isDownloaded_.integerValue==1||essence.needShare_.integerValue==0) {
         [[[MEssenceDownload alloc]init]load:self id:self.selectEssence.id_ resid:self.selectEssence.resid_ email:_user.email_ isShared:@"1"];
    } else {
        if (!self.shareAlert) {
            _shareAlert = [[UIAlertView alloc]initWithTitle:@"先分享，再下载" message:@"因为是星级帖，所以要先分享后再下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"分享", nil];
        }
        [_shareAlert show];
    }
    
    
    
    
    
}

#pragma mark -ButtonGroupDelegate
- (void)selectIndex:(NSInteger)index name:(NSString *)buttonName
{
    page = 1;
    [_header beginRefreshing];
    [self.essenceList  removeAllObjects];
    [self loadData];
}

#pragma mark -TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",self.searchArray.count);
    if (tableView==self.tableView) {
        return self.essenceList.count;
    } else {
        return self.searchArray.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableView) {
        EssenceListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"essence"];
        MEssence* essence = [self.essenceList objectAtIndex:indexPath.row];
        [cell.essenceTitleLabel setText:essence.title_];
        [cell.essenceSourceLabel setText:[NSString stringWithFormat:@"来自网友%@的分享",essence.source_]];
        [cell.essenceTimeLabel setText:[NSString stringWithFormat:@"|%@",essence.time_]];
        [cell.essenceDownloadBt setTag:indexPath.row];
        if (essence.hasDownload_.integerValue == 0) {
            [cell.essenceDownloadBt setHidden:YES];
        }
        return cell;

    } else {
        UITableViewCell* searchCell = [tableView dequeueReusableCellWithIdentifier:@"tips"];
        [searchCell.textLabel setText:[self.searchArray objectAtIndex:indexPath.row]];
        return searchCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableView) {
        MEssence* essence = [self.essenceList objectAtIndex:indexPath.row];
        if (essence.hasDownload_.integerValue==1) {
            [self performSegueWithIdentifier:@"showDetail" sender:essence];
        } else {
            [self performSegueWithIdentifier:@"showWebDetail" sender:essence];
        }
    } else {
        NSString* key = [self.searchArray objectAtIndex:indexPath.row];
        self.searchTextField.text = key;
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


#pragma mark -AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.emailAlert) {
        if (buttonIndex==1) {
            [self editEmail];
        }
    } else if (alertView == self.shareAlert)
    {
        if (buttonIndex==1) {
             [[[MEssenceDownload alloc]init]load:self id:self.selectEssence.id_ resid:self.selectEssence.resid_ email:_user.email_ isShared:@"1"];
        }
    }
    
}


- (void)editEmail
{
    if (!_editView) {
        CGRect frame = CGRectMake(0, SC_DEVICE_SIZE.height, SC_DEVICE_SIZE.width, 200);
        _editView = [[UIView alloc]initWithFrame:frame];
        [self.view addSubview:_editView];
        
        CGRect textFrame = CGRectMake(0, 50, SC_DEVICE_SIZE.width, 50);
        
        _editTextView = [[UITextField alloc]initWithFrame:textFrame];
        _editTextView.font = [UIFont systemFontOfSize:12];
        [_editView addSubview:_editTextView];
        
        
        
        
        CGRect leftBtFrame = CGRectMake(5, 0, 50, 50);
        UIButton* cancelButton = [[UIButton alloc]initWithFrame:leftBtFrame];
        [cancelButton addTarget:self action:@selector(cancelEdit) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton.titleLabel setTextColor:[UIColor blueColor]];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_editView addSubview:cancelButton];
        
        CGRect rightBtFrame = CGRectMake(SC_DEVICE_SIZE.width-55, 5, 50, 50);
        UIButton* saveButton = [[UIButton alloc]initWithFrame:rightBtFrame];
        [saveButton addTarget:self action:@selector(saveEmail) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_editView addSubview:saveButton];
    }
    self.editTextView.placeholder = @"请设置您的电子邮箱，以便接收下载的资料";
    [self.editView setBackgroundColor:[UIColor whiteColor]];
    [self.editTextView becomeFirstResponder];
    CGRect frame = _editView.frame;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        NSLog(@"%lf",-frame.size.height-(keyboardHeight==0?240:keyboardHeight));
        self.editView.transform = CGAffineTransformMakeTranslation(0, -frame.size.height-(keyboardHeight==0?240:keyboardHeight));
    } completion:^(BOOL finished) {
    }];
    
}


- (void) keyboardWasHidden:(NSNotification *) notif
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.editView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        
    }];
}


-(void)cancelEdit
{
    [self.editTextView resignFirstResponder];
}

-(void)saveEmail
{
    if ([ToolUtils checkEmail:self.editTextView.text]) {
        [self.editTextView resignFirstResponder];

        self.user.email_ = self.editTextView.text;
        [ToolUtils setUserInfomation:self.user.keyValues];
        
        [[[MUpdateUserInfo alloc]init]load:self nickname:_user.nickname_ headImg:_user.headImg_ sex:_user.sex_.integerValue email:_user.email_];
        if (self.selectEssence.isDownloaded_.integerValue==1||self.selectEssence.needShare_.integerValue==0) {
            [[[MEssenceDownload alloc]init]load:self id:self.selectEssence.id_ resid:self.selectEssence.resid_ email:_user.email_ isShared:@"1"];
        } else {
            if (!self.shareAlert) {
                _shareAlert = [[UIAlertView alloc]initWithTitle:@"先分享，再下载" message:@"因为是星级帖，所以要先分享后再下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"分享", nil];
            }
            [_shareAlert show];
        }
    } else {
        [ToolUtils showMessage:@"邮箱格式不合法,请输入正确的邮箱"];
    }
    
    
}

@end
