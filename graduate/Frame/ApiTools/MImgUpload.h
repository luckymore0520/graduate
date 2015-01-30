//
//  MImgUpload.h
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MImgUpload : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate img:(UIImage *)img name:(NSString *)fileName;
@end
