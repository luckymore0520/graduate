//
//  TraceHeaderView.m
//  graduate
//
//  Created by luck-mac on 15/2/3.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "TraceHeaderView.h"
#import "ToolUtils.h"
@implementation TraceHeaderView
- (void)initViewWithTrace:(Trace *)trace
{
    
    _dateLabel.text = [NSString stringWithFormat:@"第%@天",trace.myDay];
    _songNameLabel.text = trace.songName;
    _singerNameLabel.text = trace.singer;
    [_traceImg sd_setImageWithURL:[ToolUtils getImageUrlWtihString:trace.pictureUrlForTrace width:_traceImg.frame.size.width height:_traceImg.frame.size.height] placeholderImage:[UIImage imageNamed:@"足迹-默认背景"] ];
    [_markLabel setText:trace.note];
    NSArray* _monthArr = [NSArray arrayWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec", nil];
    NSString* today = trace.date;
    NSArray* seperateDate = [today componentsSeparatedByString:@"-"];
    NSString* month = [_monthArr objectAtIndex:[[seperateDate objectAtIndex:1]integerValue]-1];
    [_monthLabel setText:[NSString stringWithFormat:@"%@.",month]];
    [_dayLabel setText:[seperateDate firstObject]];
    [_dateLabel setText:[seperateDate objectAtIndex:2]];
    [_staticsLabel setText:[NSString stringWithFormat:@"打卡第%d天，复习了%d篇,新增%d篇",trace.signCount.integerValue,trace.reviewCount.integerValue,trace.addCount.integerValue]];
    if (trace.addCount.integerValue==0) {
        [_titleLabel setText:@"无新增的笔记"];
    } else {
        [_titleLabel setText:[NSString stringWithFormat:@"新增的笔记(%d)",trace.addCount.integerValue]];
    }
    [self.progressBar setClipsToBounds:YES];
}

- (void)didUpdateProgressView:(CGFloat)progress
{
    
    CGRect frame = self.progressContent.frame;
    frame.origin.x = -(frame.size.width-progress*frame.size.width);
    self.progressContent.frame = frame;
}
@end
