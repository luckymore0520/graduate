//
//  MUploadQues.h
//  graduate
//
//  Created by luck-mac on 15/2/1.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "ApiHelper.h"
#import "Question.h"
@interface MUploadQues : ApiHelper
- (ApiHelper *)load:(id<ApiDelegate>)delegate question:(Question*)question;
@end
