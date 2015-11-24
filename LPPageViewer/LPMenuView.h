//
//  LPMenuView.h
//  LPScrollView
//
//  Created by litt1e-p on 15/8/25.
//  Copyright (c) 2015年 litt1e-p. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    MenuViewStyleDefault,     // 默认
    MenuViewStyleLine,        // 带下划线 (颜色会变化)
    MenuViewStyleFoold,       // 涌入效果 (填充)
    MenuViewStyleFooldHollow, // 涌入效果 (空心的)
    
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
