//
//  QuestionBook.h
//  graduate
//
//  Created by luck-mac on 15/1/31.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataHelper.h"
#import "Question.h"
#import "MQuestion.h"
#import "MUploadQues.h"
@interface QuestionBook : NSObject<ApiDelegate>
@property (nonatomic,strong) NSMutableArray* allQuestions;
@property (nonatomic,strong) NSMutableArray* subjects;
@property (nonatomic) NSInteger needUpload;
+(QuestionBook *)getInstance;
- (void)loadAllData;
- (Question*)insertQuestionFromServer:(MQuestion*)currentQuestion day:(NSInteger)day;

- (Question*)insertQuestionFromRecommand:(MQuestion*)currentQuestion;
- (NSArray*)getQuestionOfDayAndType:(NSString*)day type:(NSInteger)type;
- (NSArray*)getQuestionOfType:(NSInteger)type;
- (NSMutableArray*)getMQuestionsOfType:(NSInteger)type;
- (NSArray*)getMySubjects;
- (void)insertNewQuestion:(Question*)question;
- (MQuestion*)changeFromMQuestion:(Question*)question;
- (Question*)getQuestionByMQuestion:(MQuestion*)mquestion;
- (NSArray*)getQuestionByDay:(NSString*)day;
- (void)review:(MQuestion*)mQuestion isMaster:(BOOL)isMaster;
- (void)save;
- (void)updateQuestions;
@end
