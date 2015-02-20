//
//  WKUITextField.m
//  graduate
//
//  Created by luck-mac on 15/2/18.
//  Copyright (c) 2015年 nju.excalibur. All rights reserved.
//

#import "WKUITextField.h"

@implementation WKUITextField
// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 20 , 20 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 20 , 20 );
}
@end
