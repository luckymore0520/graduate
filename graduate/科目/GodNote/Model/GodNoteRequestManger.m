//
//  GodNoteRequestManger.m
//  graduate
//
//  Created by yixiaoluo on 15/4/26.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "GodNoteRequestManger.h"
#import "SubjectModel.h"

#define BASEURL @"http://s4.smartjiangsu.com:8080/gs/mobile"

@implementation GodNoteRequestManger{
    NSMutableDictionary *_callbackCache;
}

+ (instancetype)sharedManager
{
    static GodNoteRequestManger *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GodNoteRequestManger alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    _callbackCache = [NSMutableDictionary dictionary];
    return self;
}

#pragma mark - requests
- (void)getAllNotesIn:(SubjectModel *)model completion:(Success)completion failure:(Failure)failure;
{
    GodNoteRequest *request = [[GodNoteRequest alloc] init];
    [request getAllSubject:self withType:model.subjectID];
    
    _callbackCache[@"MNoteBookList_model"] = model;
    _callbackCache[@"MNoteBookList_completioon"] = [completion copy];
    _callbackCache[@"MNoteBookList_failure"] = [failure copy];
}

#pragma mark - ApiDelegate
- (void)dispos:(NSDictionary*)responseObject functionName:(NSString*)names
{
    if ([names isEqualToString:@"MNoteBookList"]) {
        
        Success completion = _callbackCache[@"MNoteBookList_completioon"];
        Failure failure = _callbackCache[@"MNoteBookList_failure"];
        SubjectModel *model = _callbackCache[@"MNoteBookList_model"];
        
        if ([responseObject[@"errorCode"] integerValue] == 0) {
            //get the advertisement
            AdModel *ad = [[AdModel alloc] init];
            ad.adTitle = responseObject[@"adTitle_"];
            ad.adURL = responseObject[@"adUrl_"];
            ad.adImageURL = responseObject[@"adImage_"];
            model.adModel = ad;
            
            //get all notes
            NSArray *notes = responseObject[@"notes_"];
            [notes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [model.subjectBooks addObject:[SubjectNote fromDictionary:obj]];
            }];
            
            if (completion) {
                completion();
            }
        }else{
            if (failure) {
                failure(@"网络请求失败");
            }
        }
    }else if ([names isEqualToString:@""]){
    
    }
}

- (void)showError:(NSError*) error functionName:(NSString*)names
{
    Failure failure = _callbackCache[[NSString stringWithFormat:@"%@_failure",names]];
    if (failure) {
        failure(error.localizedDescription);
    }
}

- (void)showAlert:(NSString*) alert functionName:(NSString*)names
{
    Failure failure = _callbackCache[[NSString stringWithFormat:@"%@_failure",names]];
    if (failure) {
        failure(@"网络请求失败");
    }
}

@end

@implementation GodNoteRequest

- (ApiHelper *)getAllSubject:(id<ApiDelegate>)delegate withType:(NSNumber *)type
{
    return [self load:@"MNoteBookList" params:@{@"type":type} delegate:delegate];
}

@end
