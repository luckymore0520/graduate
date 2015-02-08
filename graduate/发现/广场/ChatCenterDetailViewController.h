//
//  ChatCenterDetailViewController.h
//  graduate
//
//  Created by luck-mac on 15/2/5.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "RefreshTableViewController.h"
#import "MPost.h"
@interface ChatCenterDetailViewController : RefreshTableViewController
@property (nonatomic,strong)MPost* post;
@property (nonatomic,strong)NSString* postId;
@end
