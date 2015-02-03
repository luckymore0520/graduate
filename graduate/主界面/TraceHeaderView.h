//
//  TraceHeaderView.h
//  graduate
//
//  Created by luck-mac on 15/2/3.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TraceHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton *musicBt;
@property (weak, nonatomic) IBOutlet UIImageView *traceImg;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
