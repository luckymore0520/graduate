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
#import "MImgUpload.h"
#import "MReturn.h"
#import "Sign.h"
#import "MSign.h"


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

- (NSMutableArray*)removeEmptyQuestions:(NSMutableArray*)questions
{
    NSMutableArray* validQuestions = [[NSMutableArray alloc]init];
    for (Question* question in questions) {
        if (question.img.length!=0) {
            [validQuestions addObject:question];
        }
    }
    return validQuestions;
}

- (void)loadAllData
{
    NSMutableArray* _englishBook =
    [[NSMutableArray alloc]initWithArray:[CoreDataHelper query:[NSPredicate predicateWithFormat:@"type=1 and userid=%@",[ToolUtils getUserid]] tableName:@"Question"]];
    
    
    NSMutableArray* _politicBook =
    [[NSMutableArray alloc]initWithArray:[CoreDataHelper query:[NSPredicate predicateWithFormat:@"type=2 and userid=%@",[ToolUtils getUserid]] tableName:@"Question"]];
    
    
    
    NSMutableArray* _mathBook =
    [[NSMutableArray alloc]initWithArray:[CoreDataHelper query:[NSPredicate predicateWithFormat:@"type=3 and userid=%@",[ToolUtils getUserid]] tableName:@"Question"]];

    
    
    NSMutableArray* _major1Book =
    [[NSMutableArray alloc]initWithArray:[CoreDataHelper query:[NSPredicate predicateWithFormat:@"type=4 and userid=%@",[ToolUtils getUserid]] tableName:@"Question"]];

    
    
    NSMutableArray* _major2Book =
    [[NSMutableArray alloc]initWithArray:[CoreDataHelper query:[NSPredicate predicateWithFormat:@"type=5 and userid=%@",[ToolUtils getUserid]] tableName:@"Question"]];
    

    _allQuestions = [NSMutableArray arrayWithObjects:[self removeEmptyQuestions:_englishBook],[self removeEmptyQuestions:_politicBook],[self removeEmptyQuestions:_mathBook],[self removeEmptyQuestions:_major1Book],[self removeEmptyQuestions:_major2Book], nil];
    self.needUpload = 0;
    [self updateQuestions];
}

- (void)calculateNeedUpload
{
    _needUpload = 0;

    for (NSMutableArray* arr in _allQuestions) {
        for (Question* question in arr) {
            if (!question.isUpload.boolValue) {
                self.needUpload++;
            }
        }
    }
    NSArray* signList = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"userid=%@",[ToolUtils getUserid]] tableName:@"Sign"];
    for (Sign* sign in signList) {
        if (!sign.isUpload.boolValue) {
            self.needUpload++;
        }
    }
}

- (void)updateQuestions
{
    _needUpload = 0;
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(quene, ^{
    
        for (NSMutableArray* arr in _allQuestions) {
            for (Question* question in arr) {
                if (!question.isUpload.boolValue) {
                    [self upLoadQuestion:question];
                    NSLog(@"开始上传问题 %@",question.questionid);
                    self.needUpload++;
                }
            }
        }
        
        NSArray* signList = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"userid=%@",[ToolUtils getUserid]] tableName:@"Sign"];
        
        for (Sign* sign in signList) {
            if (!sign.isUpload.boolValue) {
                [self sign:sign];
                NSLog(@"开始上传打卡 %@",sign.date);
            }
        }
        
        
    });
}


- (void)dispos:(NSDictionary *)data functionName:(NSString *)names object:(id)object
{
    if ([names isEqualToString:@"MImgUpload"]) {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            Question* question = (Question*)object;
            question.img = ret.msg_;
            MUploadQues* upLoadQues = [[MUploadQues alloc]init];
            upLoadQues.object = question;
            [upLoadQues load:self question:question];
             NSLog(@"成功上传图片 %@",question.questionid);
 
        }
        
        
    } else if([names isEqualToString:@"MUploadQues"]){
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            Question* question = (Question*)object;
            question.isUpload = [NSNumber numberWithBool:YES];
            self.needUpload--;
            NSLog(@"成功上传问题 %@",question.questionid);

        }
        
        
    } else if ([names isEqualToString:@"MSign"])
    {
        MReturn* ret = [MReturn objectWithKeyValues:data];
        if (ret.code_.integerValue==1) {
            Sign* sign = (Sign*)object;
            sign.isUpload = [NSNumber numberWithBool:YES];
            NSLog(@"成功上传打卡 %@",sign.date);

        }
    }
    
    if (self.needUpload==0) {
        [self save];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"backup" object:nil];

}

- (void)showAlert:(NSString *)alert functionName:(NSString *)names
{
    NSLog(@"上传问题失败！！");
}



-(void)upLoadQuestion:(Question*)question
{
//    MQuestion* mQuestion = [self changeFromMQuestion:question];
    if ([question.img isEqualToString:question.questionid]) {
        UIImage* image = [UIImage imageWithData:[ToolUtils loadData:question.questionid]];
        MImgUpload* upLoad = [[MImgUpload alloc]init];
        upLoad.object = question;
        [upLoad load:self img:image name:question.questionid];
    } else {
        MUploadQues* upLoadQues = [[MUploadQues alloc]init];
        upLoadQues.object = question;
        [upLoadQues load:self question:question];
    }
}

- (void)sign:(Sign*)sign
{
    MSign* mSign = [[MSign alloc]init];
    mSign.object = sign;
    [mSign load:self type:sign.type.integerValue subject:sign.subject date:sign.date];
    
}
- (Question*)insertQuestionFromServer:(MQuestion*)currentQuestion day:(NSInteger)day
{
    NSArray* result = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"questionid=%@",currentQuestion.id_] tableName:@"Question"];
    Question* question;
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    if (result.count==0) {
        question = (Question*)[NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:helper.managedObjectContext];
    } else {
        question = [result firstObject];
    }
    question.orientation = [NSNumber numberWithInt:1];
    question.questionid = currentQuestion.id_;
    question.userid = [ToolUtils getUserid];
    question.img = currentQuestion.img_;
    question.remark = currentQuestion.remark_;
    question.type = currentQuestion.type_;
    question.subject = currentQuestion.subject_;
    question.is_highlight = currentQuestion.isHighlight_;
    question.is_recommand = [NSNumber numberWithInt:0];
    question.review_time = currentQuestion.reviewCount_;
    question.is_master = currentQuestion.hasLearned_;
    question.isUpload = [NSNumber numberWithBool:YES];
    question.create_time = [[currentQuestion.createTime_ componentsSeparatedByString:@" "]firstObject];
    question.myDay = [NSString stringWithFormat:@"%ld",day];
    question.review_time = currentQuestion.reviewCount_;
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
    return question;
}

- (Question*)insertQuestionFromRecommand:(MQuestion*)currentQuestion 
{
    NSArray* result = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"questionid=%@",currentQuestion.id_] tableName:@"Question"];
    Question* question;
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    if (result.count==0) {
        question = (Question*)[NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:helper.managedObjectContext];
    } else {
        question = [result firstObject];
    }

    question.orientation = currentQuestion.orientation==nil?[NSNumber numberWithInt:1]:currentQuestion.orientation;
    question.questionid = currentQuestion.id_;
    question.userid = [ToolUtils getUserid];
    question.img = currentQuestion.img_;
    question.remark = currentQuestion.remark_;
    question.type = currentQuestion.type_;
    question.is_highlight = currentQuestion.isHighlight_;
    question.is_recommand = currentQuestion.isRecommend_;
    question.review_time = currentQuestion.reviewCount_;
    question.is_master = currentQuestion.hasLearned_;
    question.subject = currentQuestion.subject_;
    question.isUpload = [NSNumber numberWithBool:NO];
    question.create_time = [[currentQuestion.createTime_ componentsSeparatedByString:@" "]firstObject];
    if (currentQuestion.myDay_) {
        question.myDay = currentQuestion.myDay_;

    } else {
        question.myDay = [NSString stringWithFormat:@"%@",[ToolUtils getCurrentDay]];
    }
    NSError* error;
    BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
        return nil;
    }else{
        NSLog(@"Save successful! questionid:%@",question.questionid);
        if (result.count==0) {
            [[_allQuestions objectAtIndex:(currentQuestion.type_.intValue-1)]addObject:question];
        }
        return question;;
    }

    return question;
}



- (MQuestion*)changeFromMQuestion:(Question*)question
{
    MQuestion* mquestion = [[MQuestion alloc]init];
    mquestion.orientation = question.orientation;
    mquestion.id_ = question.questionid;
    mquestion.userid_ = question.userid;
    mquestion.img_ = question.img;
    mquestion.remark_ = question.remark;
    mquestion.type_ = question.type;
    mquestion.subject_ = question.subject;
    mquestion.isHighlight_ = question.is_highlight;
    mquestion.isRecommend_ = question.is_recommand;
    mquestion.createTime_ = question.create_time;
    mquestion.hasLearned_ = question.is_master;
    mquestion.reviewCount_ = question.review_time;
    mquestion.myDay_ = question.myDay;
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

- (NSMutableArray*)getMQuestionsOfType:(NSInteger)type
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


- (NSArray*)getQuestionListByDay:(NSString*)day
{
    NSArray* questionOfDay = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"myDay=%@ and userid=%@",day,[ToolUtils getUserid]] tableName:@"Question"];
    return questionOfDay;
}

- (NSArray*)getQuestionByDay:(NSString*)day
{
    NSArray* questionOfDay = [CoreDataHelper query:[NSPredicate predicateWithFormat:@"myDay=%@ and userid=%@",day,[ToolUtils getUserid]] tableName:@"Question"];
    
    NSMutableArray* resultArr = [[NSMutableArray alloc]init];
    
    for (Question* question in questionOfDay) {
        if (question.img.length==0) {
            continue;
        }
        BOOL has=NO;
        for (NSDictionary* dic in resultArr) {
            if ([[dic objectForKey:@"subject"]isEqualToString:question.subject]) {
                [[dic objectForKey:@"array"]addObject:question];
                has = YES;
                break;
            }
        }
        if (!has) {
            NSMutableArray* questionOfDay = [[NSMutableArray alloc]init];
            [questionOfDay addObject:question];
            NSDictionary* dictionary = [NSDictionary dictionaryWithObjectsAndKeys:question.subject,@"subject",questionOfDay,@"array", nil];
            [resultArr addObject:dictionary];
        }
        
        
    }
    
    
    
    return resultArr;
}

- (NSArray *)getMySubjects
{
    
    
    NSMutableArray* _englishBook = [self removeEmptyQuestions:[[NSMutableArray alloc]initWithArray:[CoreDataHelper query:[NSPredicate predicateWithFormat:@"type=1 and userid=%@",[ToolUtils getUserid]] tableName:@"Question"]]];
    
    NSMutableArray* _politicBook = [self removeEmptyQuestions:[[NSMutableArray alloc]initWithArray:[CoreDataHelper query:[NSPredicate predicateWithFormat:@"type=2 and userid=%@",[ToolUtils getUserid]] tableName:@"Question"]]];
    
    NSMutableArray* _mathBook =
    [self removeEmptyQuestions:[[NSMutableArray alloc]initWithArray:[CoreDataHelper query:[NSPredicate predicateWithFormat:@"type=3 and userid=%@",[ToolUtils getUserid]] tableName:@"Question"]]];

    
    
    NSMutableArray* _major1Book =
    [self removeEmptyQuestions: [[NSMutableArray alloc]initWithArray:[CoreDataHelper query:[NSPredicate predicateWithFormat:@"type=4 and userid=%@",[ToolUtils getUserid]] tableName:@"Question"]]];

    
    
    NSMutableArray* _major2Book =  [self removeEmptyQuestions:  [[NSMutableArray alloc]initWithArray:[CoreDataHelper query:[NSPredicate predicateWithFormat:@"type=5 and userid=%@",[ToolUtils getUserid]] tableName:@"Question"]]];
  
    
    
    NSDictionary* userInfo = [ToolUtils getUserInfomation];
    MUser* user = [MUser objectWithKeyValues:userInfo];
    if (user.subjectMajor1_.length==0) {
        Subject* politic = [[Subject alloc]init];
        politic.name = @"政治";
        politic.total = 0;
        politic.newAdd = 0;
        politic.type = 2;
        _subjects = [NSMutableArray arrayWithObjects:politic, nil];
    } else {
        QuestionBook* book = [QuestionBook getInstance];
        NSString* today = [NSString stringWithFormat:@"%ld",[ToolUtils getCurrentDay].integerValue];
        self.subjects = [[NSMutableArray alloc]init];
        Subject* english = [[Subject alloc]init];
        english.name = user.subjectEng_;
        english.total = _englishBook.count;
        english.newAdd = [book getQuestionOfDayAndType:today type:1].count;
        english.type=1;
        english.firstStr = @"英";
        [self.subjects addObject:english];
        
        
        Subject* politic = [[Subject alloc]init];
        politic.name = user.subjectPolity_;
        politic.total = _politicBook.count;
        politic.newAdd = [book getQuestionOfDayAndType:today type:2].count;
        politic.type = 2;
        politic.firstStr = @"政";
        [self.subjects addObject:politic];
        
        
        if (user.subjectMath_.length!=0) {
            Subject* maths = [[Subject alloc]init];
            maths.name = user.subjectMath_;
            maths.total = _mathBook.count;
            maths.newAdd = [book getQuestionOfDayAndType:today type:3].count;
            maths.type =3;
            maths.firstStr = @"数";
            [self.subjects addObject:maths];
            
            
        } else {
            Subject* major2 = [[Subject alloc]init];
            major2.name = user.subjectMajor2_;
            major2.total = _major2Book.count;
            major2.newAdd = [book getQuestionOfDayAndType:today type:5].count;
            major2.type = 5;
            NSString* first = [major2.name substringToIndex:1];
            if ([first isEqualToString:@"英"]||[first isEqualToString:@"政"]) {
                first = @"专";
            }
            major2.firstStr = first;
            [self.subjects addObject:major2];
            
        }
        
        Subject* major1 = [[Subject alloc]init];
        major1.name = user.subjectMajor1_;
        major1.total = _major1Book.count;
        major1.newAdd = [book getQuestionOfDayAndType:today type:4].count;
        major1.type =4;
        NSString* first = [major1.name substringToIndex:1];
        Subject* last = [_subjects lastObject];
        if ([first isEqualToString:@"英"]||[first isEqualToString:@"政"]||[first isEqualToString:last.firstStr]) {
            if ([last.firstStr isEqualToString:@"专"]) {
                first = [[major1.name substringFromIndex:1]substringToIndex:1];
            } else {
                first = @"专";
            }
        }
        major1.firstStr = first;
        [self.subjects addObject:major1];
    }
    return _subjects;
}

- (void)insertNewQuestion:(Question*)question
{
    [[_allQuestions objectAtIndex:(question.type.integerValue-1)]addObject:question];
}


- (Question*)getQuestionByMQuestion:(MQuestion*)mquestion
{
    NSArray* questionlist = [_allQuestions objectAtIndex:mquestion.type_.integerValue-1];
    for (Question* question in questionlist) {
        if ([question.questionid isEqualToString:mquestion.id_]) {
            return question;
        }
    }
    return nil;
}

- (void)save
{
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    NSError* error;
    BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful!");
    }
}

- (void)review:(MQuestion*)mQuestion isMaster:(BOOL)isMaster
{
    Question* question = [self getQuestionByMQuestion:mQuestion];
    question.review_time = [NSNumber numberWithInt:question.review_time.integerValue+1];
    question.isUpload = [NSNumber numberWithBool:NO];
    question.is_master = [NSNumber numberWithBool:isMaster];
    [self save];
}


- (void)deleteQuestion:(Question*)question
{
    CoreDataHelper* helper = [CoreDataHelper getInstance];
    [[self.allQuestions objectAtIndex:question.type.integerValue-1] removeObject:question];
    [helper.managedObjectContext deleteObject:question];
    NSError* error;
    BOOL isSaveSuccess=[helper.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful!");
    }
}


@end
