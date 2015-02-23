//
//  EssenceDetailViewController.h
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "BaseFuncVC.h"
#import "MEssence.h"
@interface EssenceDetailViewController : BaseFuncVC
@property (nonatomic,strong)MEssence* essence;
- (void)addRightButton;

@end
