//
//  AuthorReusableView.h
//  graduate
//
//  Created by yixiaoluo on 15/5/14.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesReusableView.h"

@class AuthorInfo;
@interface AuthorReusableView : UICollectionReusableView

- (void)reloadViewWith:(AuthorInfo *)info;

@end

@interface PraiseHeadersView : ImagesReusableView

@end