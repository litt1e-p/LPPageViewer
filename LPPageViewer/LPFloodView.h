//
//  LPFloodView.h
//  LPScrollView
//
//  Created by xzc on 15/11/24.
//  Copyright © 2015年 litt1e-p. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPFloodView : UIView

@property (nonatomic,weak)UIColor  *color;

@property (nonatomic,assign)BOOL isStroke;

@property (nonatomic,assign)BOOL isLine;

@property (nonatomic,assign)CGColorRef FillColor;

@end
