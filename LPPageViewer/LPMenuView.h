//
//  LPMenuView.h
//  LPScrollView
//
//  Created by litt1e-p on 15/8/25.
//  Copyright (c) 2015年 litt1e-p. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    MenuViewStyleDefault,     // default
    MenuViewStyleLine,        // underline
    MenuViewStyleFoold,       // fill with foold effect
    MenuViewStyleFooldHollow, // border without fill foold effect
    
} MenuViewStyle;

@class LPMenuView;

@protocol LPMenuViewDelegate <NSObject>

@optional

- (void)menuViewBtnDidClickAtIndex:(NSUInteger)index;

@end

@interface LPMenuView : UIView

@property (nonatomic, assign)MenuViewStyle style;
@property (nonatomic, weak) UIScrollView *navMenuScrollView;
@property (nonatomic, weak) id<LPMenuViewDelegate> delegate;

- (void)selectedBtnMoveToCenterWithIndex:(NSInteger)index withRate:(CGFloat)pageRate;
- (instancetype)initWithMenuViewStyle:(MenuViewStyle)style andTitles:(NSArray *)titles;
- (void)resetSelectedBtn:(NSInteger)tag;

@end
