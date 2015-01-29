//
//  ApiHelper.h
//  MobileNJU_2.5
//
//  Created by luck-mac on 14-10-17.
//  Copyright (c) 2014年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ToolUtils.h"
#define BASEURL @"http://114.215.196.179:8080/gs/mobile?"
@protocol ApiDelegate<NSObject>
@required
- (void)dispos:(NSDictionary*) data functionName:(NSString*)names;
- (void)showError:(NSError*) error functionName:(NSString*)names;
- (void) showAlert:(NSString*) alert;

@end



@interface ApiHelper : NSObject<NSURLConnectionDataDelegate>
{
    NSMutableData* myData;
}
@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger pageCount;
@property (nonatomic,strong) id<ApiDelegate> delegate;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong)NSDictionary* params;
@property (nonatomic,strong)NSString* content;
@property (nonatomic,strong)NSString* fileId;

-(ApiHelper*) load:(NSString*)method params:(NSDictionary*) params delegate:(id<ApiDelegate>) delegate;
-(ApiHelper*) post:(NSString*)method params:(NSDictionary*) params delegate:(id<ApiDelegate>) delegate;
- (ApiHelper*) load:(id<ApiDelegate>)delegate img:(UIImage*)img name:(NSString*)fileName;
- (ApiHelper*)setPage:(NSInteger)page limit:(NSInteger) limit;
- (ApiHelper*)downloadImg:(id<ApiDelegate>)delegate  imgUrl:(NSString*)imgUrl  ;
//- (ApiHelper*) load:(id<ApiDelegate>) delegate id:(NSString*)id ;
//- (ApiHelper*) load:(id<ApiDelegate>) delegate type:(NSString*)type ;
//- (ApiHelper*) load:(id<ApiDelegate>) delegate tag:(NSString*)tag begin:(NSString*) begin;
//- (ApiHelper*) load:(id<ApiDelegate>) delegate type:(NSString*)type begin:(NSString*) begin;
//- (ApiHelper*) load:(id<ApiDelegate>) delegate type:(NSString*)type id:(NSString*) id;
//- (ApiHelper*) load:(id<ApiDelegate>) delegate id:(NSString*)id begin:(NSString*) begin;
//- (ApiHelper*) load:(id<ApiDelegate>) delegate id:(NSString*)id content:(NSString*)content isLz:(NSString*)isLz replyId:(NSString*) replyId replyFloor:(NSString*)replyFloor;
//- (ApiHelper*) load:(id<ApiDelegate>)delegate phone:(NSString*)phone password:(NSString*)password;
//- (ApiHelper*) load:(id<ApiDelegate>)delegate topicid:(NSString*)topicid targetid:(NSString*)targetid;
//- (ApiHelper*) load:(id<ApiDelegate>)delegate topicid:(NSString*)topicid targetid:(NSString*)targetid content:(NSString*) content;

@end
