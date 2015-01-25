//
//  ArticleList.h
//  graduate
//
//  Created by luck-mac on 15/1/23.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleList : UIViewController
{
    NSArray* dataArray;
    
    
}

- (void)gotoDetail:(NSString*)url;
@end
