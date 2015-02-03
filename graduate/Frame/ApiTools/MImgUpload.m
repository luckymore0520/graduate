//
//  MImgUpload.m
//  graduate
//
//  Created by luck-mac on 15/1/29.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "MImgUpload.h"
#import "GTMBase64.h"
@implementation MImgUpload
- (ApiHelper *)load:(id<ApiDelegate>)delegate img:(UIImage *)img name:(NSString *)fileName
{
    if (![ToolUtils connectedToNetWork]&&![ToolUtils ignoreNetwork]) {
        return nil;
    }
    NSData* originData =  UIImagePNGRepresentation(img);
    NSData* encodeData = [GTMBase64 encodeData:originData];
    NSString* encodeResult = [[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding];
    NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:encodeResult,@"img",fileName,@"filename",nil];
    return [self post:@"MImgUpload" params:dictionary delegate:delegate];
}
@end
