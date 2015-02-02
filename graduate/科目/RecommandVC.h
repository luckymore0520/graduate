//
//  RecommandVC.h
//  graduate
//
//  Created by luck-mac on 15/1/25.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFuncVC.h"
#import "QuestionView.h"
#import "MQuestion.h"
#import "Question.h"
#import "CoreDataHelper.h"
#import "QuestionBook.h"
#import "MReturn.h"
#import "MUploadQues.h"
#import "MQuestionList.h"
#import "MQuestionRecommand.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "ReviewVC.h"
@interface RecommandVC : ReviewVC
@property (nonatomic,strong)Question* recommandQuestion;

-(void)initQuestions;
@end
