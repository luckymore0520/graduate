//
//  IntroductionModel.m
//  graduate
//
//  Created by yixiaoluo on 15/5/14.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "IntroductionModel.h"

@implementation IntroductionModel

+ (instancetype)fromDictionary:(NSDictionary *)noteDetail;
{
    IntroductionModel *model = [[IntroductionModel alloc] init];
    
    //-------笔记作者信息------
    AuthorInfo *authorInfo = [[AuthorInfo alloc] init];
    authorInfo.authorID = noteDetail[@"authorId_"];
    authorInfo.authorName = noteDetail[@"authorName_"];
    authorInfo.authorDesc = noteDetail[@"authorDesc_"];
    authorInfo.authorSex = noteDetail[@"authorSex_"];
    authorInfo.praiseCount = noteDetail[@"praiseCount_"];
    authorInfo.cover = noteDetail[@"cover_"];
    authorInfo.subName = noteDetail[@"subName_"];
    authorInfo.subDetailName = noteDetail[@"subDetailName_"];
    
    //-------播放相关信息:视频或图片列表------
    MediaInfo *mediaInfo = [[MediaInfo alloc] init];
    mediaInfo.mediaType = [noteDetail[@"authorType_"] integerValue];
    mediaInfo.videoUrl = noteDetail[@"authorVideo_"];
    NSMutableArray *imageList = [NSMutableArray array];
    mediaInfo.imageList = imageList;
    [noteDetail[@"list_"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        MediaImageModel *imageModel = [[MediaImageModel alloc] init];
        imageModel.imageID = obj[@"id_"];
        imageModel.userID = obj[@"userid_"];
        imageModel.imageURl = obj[@"img_"];
        imageModel.remark = obj[@"remark_"];
        imageModel.subject = obj[@"subject_"];
        imageModel.isHighlight = obj[@"isHighlight_"];
        [imageList addObject:imageModel];
    }];
    
    //-------用户说相关信息------
    UserSayInfo *userSayInfo = [[UserSayInfo alloc] init];
    NSMutableArray *says = [NSMutableArray array];
    userSayInfo.userSayArray = says;
    NSArray *keys = @[@"wantToSay_", @"experience_", @"suitable_", @"desc_"];
    NSArray *title = @[@"我想说",  @"过往经历", @"适合人群", @"笔记"];
    [keys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UserSayKindModel *say = [[UserSayKindModel alloc] init];
        say.kindTitle = noteDetail[obj];
        say.desc = title[idx];
        [says addObject:say];
    }];

    //-------用户评论------
    CommentInfo *commentInfo = [[CommentInfo alloc] init];
    commentInfo.commentTitle = [NSString stringWithFormat:@"用户评论(%@)", noteDetail[@"commentCount_"]];
    NSMutableArray *commentList = [NSMutableArray array];
    commentInfo.commentList = commentList;
    [noteDetail[@"comments_"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        CommentModel *commentModel = [[CommentModel alloc] init];
        commentModel.commentID = obj[@"id_"];
        commentModel.pid = obj[@"pid_"];
        commentModel.content = obj[@"content_"];
        commentModel.userID = obj[@"userid_"];
        commentModel.nickName = obj[@"nickname_"];
        commentModel.headerImage = obj[@"headimg_"];
        commentModel.time = obj[@"time_"];
        [commentList addObject:commentModel];
    }];

    model.authorInfo = authorInfo;
    model.mediaInfo = mediaInfo;
    model.userSayInfo = userSayInfo;
    model.commentInfo = commentInfo;
    
    return model;
}

@end

@implementation AuthorInfo

@end

@implementation MediaInfo

@end

@implementation MediaImageModel

@end

@implementation UserSayInfo

@end

@implementation UserSayKindModel

@end

@implementation CommentInfo

@end

@implementation CommentModel

@end