//
//  NewsListCell.h
//  graduate
//
//  Created by TracyLin on 15/5/4.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsSourceTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsTimeLabel;
@property (strong,nonatomic) NSString *newsUrl;
@end
