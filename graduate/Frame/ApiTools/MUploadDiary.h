//
//  MUploadDiary.h
//  graduate
//
//  Created by luck-mac on 15/2/4.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"

@interface MUploadDiary : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate id:(NSString*)id content:(NSString*)content date:(NSString*)date;
@end
