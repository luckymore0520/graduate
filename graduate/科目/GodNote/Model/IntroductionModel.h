//
//  IntroductionModel.h
//  graduate
//
//  Created by yixiaoluo on 15/5/14.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MediaType) {
    MediaTypeImages = 0,
    MediaTypeVideo
};

@class AuthorInfo, MediaInfo, UserSayInfo, CommentInfo;
@interface IntroductionModel : NSObject

//-------笔记作者信息------
@property (nonatomic) AuthorInfo *authorInfo;

//-------播放相关信息:视频或图片列表 collection view------
@property (nonatomic) MediaInfo *mediaInfo;

//-------用户说相关信息------
@property (nonatomic) UserSayInfo *userSayInfo;

//-------用户评论------
@property (nonatomic) CommentInfo *commentInfo;//CommentModel array

+ (instancetype)fromDictionary:(NSDictionary *)noteDetail;

@end

//-------笔记作者信息------
@interface AuthorInfo : NSObject

@property (nonatomic) NSNumber *authorID;
@property (nonatomic) NSString *authorName;
@property (nonatomic) NSString *authorDesc;
@property (nonatomic) NSNumber *authorSex;
@property (nonatomic) NSNumber *praiseCount;
@property (nonatomic) NSString *cover;
@property (nonatomic) NSString *subName;
@property (nonatomic) NSString *subDetailName;

@end

//-------播放相关信息:视频或图片列表------
@interface MediaInfo : NSObject

@property (nonatomic) MediaType mediaType;
@property (nonatomic) NSString *videoUrl;
@property (nonatomic) NSArray *imageList;//MediaImageModel array

@end

@interface MediaImageModel : NSObject

@property (nonatomic) NSNumber *imageID;
@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *imgageURl;
@property (nonatomic) NSString *remark;
@property (nonatomic) NSString *subject;
@property (nonatomic) BOOL isHighlight;

@end

//-------用户说相关信息------
@interface UserSayInfo : NSObject

@property (nonatomic) NSArray *userSayArray;//UserSayKindModel array

@end

@interface UserSayKindModel : NSObject

@property (nonatomic) NSString *kindTitle;
@property (nonatomic) NSString *desc;

@end

//-------用户评论------
@interface CommentInfo : NSObject

@property (nonatomic) NSString *commentTitle;
@property (nonatomic) NSArray *commentList;//CommentModel array

@end


@interface CommentModel : NSObject

@property (nonatomic) NSNumber *commentID;
@property (nonatomic) NSString *pid;
@property (nonatomic) NSString *content;
@property (nonatomic) NSNumber *userID;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *headerImage;
@property (nonatomic) NSString *time;

@end
