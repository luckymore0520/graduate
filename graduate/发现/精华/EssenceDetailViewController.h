//
//  EssenceDetailViewController.h
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseFuncVC.h"
#import "MEssence.h"
#import "ShareApiUtil.h"
@interface EssenceDetailViewController : BaseFuncVC<QQApiInterfaceDelegate>
{
    TencentOAuth *_tencentOAuth;
}
@property (nonatomic,strong)MEssence* essence;
@property (nonatomic,weak)BaseFuncVC* fatherVC;
@property (nonatomic,assign)BOOL isMyCollection;
- (void)addRightButton;

@end
