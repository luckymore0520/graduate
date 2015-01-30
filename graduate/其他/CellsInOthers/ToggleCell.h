//
//  toggleCell.h
//  graduate
//
//  Created by Sylar on 26/1/15.
//  Copyright (c) 2015 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToggleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *materialButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *quizButton;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end
