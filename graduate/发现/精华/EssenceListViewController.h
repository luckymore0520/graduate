//
//  EssenceListViewController.h
//  graduate
//
//  Created by luck-mac on 15/2/6.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "RefreshTableViewController.h"
#import "ShareApiUtil.h"
@interface EssenceListViewController : RefreshTableViewController
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,weak)BaseFuncVC* parentVC;
@property (nonatomic,strong)NSString* key;
@property (nonatomic,assign)BOOL isMyCollection;
@property (nonatomic,assign)BOOL selectedMode;
- (void)reloadData;
- (void)selectAll:(BOOL)isAll;
@end
