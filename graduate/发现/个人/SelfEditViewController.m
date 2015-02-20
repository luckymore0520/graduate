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
#import "MImgUpload.h"
@interface SelfEditViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)MUser* user;
@property (nonatomic,strong)UIImage* head;
@end

@implementation SelfEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [MUser objectWithKeyValues:[ToolUtils getUserInfomation]];
    [self setTitle:@"个人资料"];
    [self addRightButton:@"保存" action:@selector(save:) img:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)save:(id)sender {
    if (_head) {
        [self waiting:@"正在上传头像..."];
        [[[MImgUpload alloc]init]load:self img:_head name:@""];
    } else {
        [self waiting:@"正在保存..."];
        _user.nickname_ = ((SelfOtherCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]]).nickNameField.text;
        _user.sex_ =  [NSNumber numberWithInteger:((SelfOtherCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]]).cellBtGroup.selectedIndex];
        [ToolUtils setUserInfomation:_user.keyValues];
        [[[MUpdateUserInfo alloc]init]load:self nickname:_user.nickname_ headImg:_user.headImg_ sex:_user.sex_.integerValue email:_user.email_];
    }
}


#pragma mark -ApiDelegate
-(void)dispos:(NSDictionary *)data functionName:(NSString *)names
{
    if ([names isEqualToString:@"MUpdateUserInfo"]) {
        [self waitingEnd];
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [ToolUtils showMessage:@"修改失败，请重试"];
        }
    } else if ( [names isEqualToString:@"MImgUpload"])
    {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        _user.nickname_ = ((SelfOtherCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]]).nickNameField.text;
        _user.sex_ =  [NSNumber numberWithInteger:((SelfOtherCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]]).cellBtGroup.selectedIndex];
        _user.headImg_ = ret.msg_;
        [ToolUtils setUserInfomation:_user.keyValues];
        [[[MUpdateUserInfo alloc]init]load:self nickname:_user.nickname_ headImg:_user.headImg_ sex:_user.sex_.integerValue email:_user.email_];
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
        if (!self.head) {
            [cell.headImg sd_setImageWithURL:[ToolUtils getImageUrlWtihString:_user.headImg_ width:200 height:200] placeholderImage:nil];

        } else {
            [cell.headImg setImage:_head];
        }
        return cell;
    } else if (indexPath.section==1)
    {
        if (indexPath.row==0) {
            SelfOtherCell* cell = [tableView dequeueReusableCellWithIdentifier:@"nickName"];
            [cell.nickNameField setText:_user.nickname_];
            self.textFields = @[cell.nickNameField];
            cell.nickNameField.delegate = self;
            return cell;
        } else if (indexPath.row==1)
        {
             SelfOtherCell* cell = [tableView dequeueReusableCellWithIdentifier:@"sex"];
            [cell.cellBtGroup setDelegate:cell];
            [cell.cellBtGroup loadButton:[NSArray arrayWithObjects:cell.maleBt,cell.femaleBt, nil]];
            [cell.cellBtGroup setSelectedIndex:_user.sex_.integerValue];
            return cell;
        }
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        [self showActionSheet];
    }
}

- (void) showActionSheet
{
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:nil  delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
    
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    _head = [self useImage:image];
    _user.nickname_ = ((SelfOtherCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]]).nickNameField.text;
    [self.tableView reloadData];
}

- (UIImage *)useImage:(UIImage *)image {
    //    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // Create a graphics image context
    CGSize newSize = CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    
    //    [pool release];
    return newImage;
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowPhotoTabbar" object:nil];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                    
                case 2:
                    // 取消
                    return;
                    break;
                default:
                    return;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            } else {
                return;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
        //        [imagePickerController release];
        
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"HidePhotoTabbar" object:nil];
    } else {
        switch (buttonIndex) {
            case 0:
                // 删除
            {
                [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            }
                
                break;
            default:
                break;
        }
    }
}



@end
