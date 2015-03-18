//
//  EssenceMediaCell.h
//  graduate
//
//  Created by luck-mac on 15/3/17.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMedia.h"
@interface EssenceMediaCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *numberButton;
@property (nonatomic,weak)UIViewController* viewController;
@property (nonatomic,weak)MMedia* media;
@end
