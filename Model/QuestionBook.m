//
//  QuestionBook.m
//  graduate
//
//  Created by luck-mac on 15/1/31.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "QuestionBook.h"
#import "ToolUtils.h"
#import "Subject.h"
#import "MUser.h"
@implementation QuestionBook

QuestionBook* questionBook = nil;

+(QuestionBook *)getInstance
{
    @synchronized(self){
        if(questionBook == nil){
            questionBook = [[self alloc] init];
        }
    }
    return questionBook;
}

- (void)loadAllData
{
    _englishBook =
    [[NSMutableArray alloc]initWithArray:[CoreDataHelper query:[NSPredicate predicateWithFormat:@"type=1 and userid=%@",[ToolUtils getUserid]] tableName:@"Question"]];
    
    
    _politicBook =
    [[NSMutableArray alloc]initWithArray:[CoreDataHelper query:[NSPredicate predicateWithFormat:@"type=2 and userid=%@",[ToolUtils getUserid]] tableName:@"Question"]];
    
    _mathBook =
    [[NSMutableArray alloc]initWithArray:[CoreDataHelper query:[NSPredicate predicateWithFormat:@"type=3 and userid=%@",[ToolUtils getUserid]] tableName:@"Question"]];

    
    _major1Book =
    [[NSMutableArray alloc]initWithArray:[CoreDataHelper query:[NSPredicate predicateWithFormat:@"type=4 and userid=%@",[ToolUtils getUserid]] tableName:@"Question"]];

    
    _major2Book =
    [[NSMutableArray alloc]initWithArray:[CoreDataHelper query:[NSPredicate predicateWithFormat:@"type=5 and userid=%@",[ToolUtils getUserid]] tableName:@"Question"]];
    
    _allQuestions = [NSMutableArray arrayWithObjects:_englishBook,_politicBook,_mathBook,_major1Book,_major2Book, nil];
    
}

- (Question*)insertQuestionFromRecommand:(MQuestion*)currentQuestion
{
    NSArray* result = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"questionid=%@",currentQuestion.id_] tableName:@"Question"];
    if (result.count==0) {
        CoreDataHelper* helper = [CoreDataHelper getInstance];
        Question* question = (Question*)[NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:helper.managedObjectContext];
        question.questionid = currentQuestion.id_;
        question.userid = [ToolUtils getUserid];
        question.img = currentQuestion.img_;
        question.remark = currentQuestion.remark_;
        question.type = currentQuestion.type_;
        question.subject = currentQuestion.subject_;
        question.is_highlight = currentQuestion.isHighlight_;
        question.is_recommand = currentQuestion.isRecommend_;
        question.isUpload = [NSNumber numberWithBool:NO];
        question.create_time = [[currentQuestion.createTime_ componentsSeparatedByString:@" "]firstObject];
        question.myDay = [NSString stringWithFormat:@"%d",[ToolUtils getCurrentDay].integerValue];
        NSError* error;
        BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
        if (!isSaveSuccess) {
            NSLog(@"Error:%@",error);
            return nil;
        }else{
            NSLog(@"Save successful! questionid:%@",question.questionid);
            [[_allQuestions objectAtIndex:(currentQuestion.type_.intValue-1)]addObject:question];
            return question;;
        }
    }
    return [result firstObject];
}



- (MQuestion*)changeFromMQuestion:(Question*)question
{
    MQuestion* mquestion = [[MQuestion alloc]init];
    mquestion.id_ = question.questionid;
    mquestion.userid_ = question.userid;
    mquestion.img_ = question.img;
    mquestion.remark_ = question.remark;
    mquestion.type_ = question.type;
    mquestion.subject_ = question.subject;
    mquestion.isHighlight_ = question.is_highlight;
    mquestion.isRecommend_ = question.is_recommand;
    mquestion.createTime_ = question.create_time;
    
    return mquestion;

}

- (NSArray *)getQuestionOfDayAndType:(NSString *)day type:(NSInteger)type
{
    NSMutableArray* arr = [_allQuestions objectAtIndex:type-1];
    NSMutableArray* resultQuestion = [[NSMutableArray alloc]init];
    for (Question* question in arr) {
        if ([question.myDay isEqualToString:day]) {
            [resultQuestion addObject:question];
        }
    }
    return resultQuestion;
}

- (NSArray*)getMQuestionsOfType:(NSInteger)type
{
    NSMutableArray* mutableArray = [[NSMutableArray alloc]init];
    for (Question* question in [_allQuestions objectAtIndex:type-1]) {
        [mutableArray addObject:[self changeFromMQuestion:question]];
    }
    return mutableArray;
}

- (NSArray*)getQuestionOfType:(NSInteger)type
{
    NSMutableArray* arr = [_allQuestions objectAtIndex:type-1];
    NSMutableArray* resultArr = [[NSMutableArray alloc]init];
    
    for (Question* question in arr) {
        BOOL has=NO;
        for (NSDictionary* dic in resultArr) {
            if ([[dic objectForKey:@"day"]isEqualToString:question.myDay]) {
                [[dic objectForKey:@"array"]addObject:question];
                has = YES;
                break;
            }
        }
        if (!has) {
            NSMutableArray* questionOfDay = [[NSMutableArray alloc]init];
            [questionOfDay addObject:question];
            NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:question.myDay,@"day",questionOfDay,@"array", nil];
            [resultArr addObject:dictionary];
        }
    }
    return resultArr;
}

- (NSArray *)getMySubjects
{
    NSDictionary* userInfo = [ToolUtils getUserInfomation];
    MUser* user = [MUser objectWithKeyValues:userInfo];
    if (user.subjectMajor1_.length==0) {
        Subject* politic = [[Subject alloc]init];
        politic.name = @"政治";
        politic.total = 0;
        politic.newAdd = 0;
        _subjects = [NSMutableArray arrayWithObjects:politic, nil];
    } else {
        QuestionBook* book = [QuestionBook getInstance];
        //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //        NSString *today = [dateFormatter stringFromDate:[NSDate date]];
        NSString* today = [NSString stringWithFormat:@"%d",[ToolUtils getCurrentDay].integerValue];
        
        self.subjects = [[NSMutableArray alloc]init];
        
        Subject* english = [[Subject alloc]init];
        english.name = user.subjectEng_;
        english.total = book.englishBook.count;
        english.newAdd = [book getQuestionOfDayAndType:today type:1].count;
        english.type=1;
        [self.subjects addObject:english];
        
        
        Subject* politic = [[Subject alloc]init];
        politic.name = user.subjectPolity_;
        politic.total = book.politicBook.count;
        politic.newAdd = [book getQuestionOfDayAndType:today type:2].count;
        politic.type = 2;
        [self.subjects addObject:politic];
        
        
        
        if (user.subjectMath_.length!=0) {
            Subject* maths = [[Subject alloc]init];
            maths.name = user.subjectMath_;
            maths.total = book.mathBook.count;
            maths.newAdd = [book getQuestionOfDayAndType:today type:3].count;
            maths.type =3;
            [self.subjects addObject:maths];
            
            
        } else {
            Subject* major2 = [[Subject alloc]init];
            major2.name = user.subjectMajor2_;
            major2.total = book.major2Book.count;
            major2.newAdd = [book getQuestionOfDayAndType:today type:5].count;
            major2.type = 5;
            [self.subjects addObject:major2];
            
        }
        
        Subject* major1 = [[Subject alloc]init];
        major1.name = user.subjectMajor1_;
        major1.total = book.major1Book.count;
        major1.newAdd = [book getQuestionOfDayAndType:today type:4].count;
        major1.type =4;
        [self.subjects addObject:major1];
    }
    return _subjects;
}

- (void)insertNewQuestion:(Question*)question
{
    [[_allQuestions objectAtIndex:(question.type.integerValue-1)]addObject:question];
}
@end
