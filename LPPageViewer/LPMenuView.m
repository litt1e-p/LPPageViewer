//
//  LPMenuView.m
//  LPScrollView
//
//  Created by litt1e-p on 15/8/25.
//  Copyright (c) 2015年 litt1e-p. All rights reserved.
//

#import "LPMenuView.h"
#import "LPMenuBtn.h"
//#import "NSString+Extension.h"
//#import "UIView+Extension.h"
#import "LPFloodView.h"

#define BtnMargin 8
//涌入 字体颜色
#define kSelectedColorFontFlood   [UIColor colorWithRed:0/255.0 green:0/255.0 blue:225/255.0 alpha:1]
//默认时候普通字体颜色
#define  kNomalColor [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1]
//默认时候选中字体颜色
#define kSelectedColor  [UIColor colorWithRed:225/255.0 green:20.0/255.0 blue:4/255.0 alpha:1]
//涌入效果的字体颜色
#define kNomalColorFontFlood   [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1]
//涌入 背景颜色
#define  kNormalColorFlood [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:0.5]
//涌入效果（空心）
#define kSelectedColorFloodH  [UIColor colorWithRed:225/255.0 green:40/255.0 blue:40/255.0 alpha:1]

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define NavigationBarHeight self.navigationController.navigationBar.frame.size.height;

@interface LPMenuView()<UIScrollViewDelegate>


@property (nonatomic, weak) LPMenuBtn *selectedBtn;
@property (nonatomic, assign) CGFloat sumWidth;
@property (nonatomic,weak)UIView  *line;

@end

@implementation LPMenuView

- (instancetype)initWithMenuViewStyle:(MenuViewStyle)style andTitles:(NSArray *)titles;
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.style = style;
        [self loadScrollViewAndBtnWithTitles:titles];
    }
    return self;
}

- (void)loadScrollViewAndBtnWithTitles:(NSArray *)titles
{
    UIScrollView *navMenuScrollView = [[UIScrollView alloc] init];
    navMenuScrollView.showsVerticalScrollIndicator = NO;
    navMenuScrollView.showsHorizontalScrollIndicator = NO;
    navMenuScrollView.backgroundColor = [UIColor whiteColor];
    navMenuScrollView.delegate = self;
    self.navMenuScrollView = navMenuScrollView;
    [self addSubview:self.navMenuScrollView];
    
    for (int i = 0; i < titles.count; i++) {
        LPMenuBtn *btn = [[LPMenuBtn alloc] initWithTitle:titles[i] andIndex:i];
        btn.tag = i;
        
        if (self.style == MenuViewStyleFoold || self.style == MenuViewStyleFooldHollow) {
//            btn.fontName = @"BodoniSvtyTwoOSITCTT-Bold";
            btn.fontSize = 16;
            btn.normalColor = kNomalColor;
            btn.selectedColor = kSelectedColorFontFlood;
            if (self.style == MenuViewStyleFooldHollow) {
                btn.selectedColor = kSelectedColorFloodH;
            }
        }else{
//            btn.fontName = @"经典细圆简";
        }
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.textColor = [UIColor blackColor];
        [self.navMenuScrollView addSubview:btn];
    }
}

- (void)layoutSubviews
{
    for (NSInteger i = 0; i < self.navMenuScrollView.subviews.count; i++) {
        LPMenuBtn *currentBtn = self.navMenuScrollView.subviews[i];
        LPMenuBtn *prevBtn = i >= 1 ? (LPMenuBtn *)self.navMenuScrollView.subviews[i - 1] : [[LPMenuBtn alloc] init];
        CGFloat x = prevBtn.frame.origin.x + prevBtn.frame.size.width + BtnMargin;
        CGFloat w = [self sizeWithfont:currentBtn.titleLabel.font forStr:currentBtn.titleLabel.text].width + 2 * BtnMargin;
        CGFloat h = self.frame.size.height - BtnMargin * 0.25;
        currentBtn.frame = CGRectMake(x, 0, w, h);
        self.sumWidth += currentBtn.frame.size.width;
    }
    self.navMenuScrollView.frame = CGRectMake(self.navMenuScrollView.frame.origin.x, self.navMenuScrollView.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
    LPMenuBtn *lastBtn = [self.navMenuScrollView.subviews lastObject];
    self.navMenuScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame) + BtnMargin, 0);
    self.navMenuScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}
                     
- (CGSize)sizeWithfont:(UIFont*)font forStr:(NSString *)str
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.style == MenuViewStyleDefault) {
        LPMenuBtn *btn = [self.navMenuScrollView.subviews firstObject];
        [btn changeSelectedColorAndScaleWithRate:0.1];
    }else{
        [self addProgressView];
    }
}

- (void)addProgressView
{
    LPFloodView *view = [[LPFloodView alloc] init];
    
    LPMenuBtn *btn = [self.navMenuScrollView.subviews firstObject];
    view.frame = CGRectMake(btn.frame.origin.x, view.frame.origin.y, btn.frame.size.width, view.frame.size.height);
    view.backgroundColor = [UIColor clearColor];
    view.color = kSelectedColor;
    self.line = view;
    
    if (self.style == MenuViewStyleFooldHollow || self.style == MenuViewStyleFoold){
        view.FillColor = kNormalColorFlood.CGColor;
        CGFloat vH = self.frame.size.height / 2 + 2;
        CGFloat vY = (self.frame.size.height - vH) / 2;
        view.frame = CGRectMake(view.frame.origin.x, vY, btn.frame.size.width, vH);
        if (self.style == MenuViewStyleFooldHollow) {
            view.isStroke = YES;
            view.color = [UIColor redColor];
        }
    }else{
        view.isLine = YES;
        CGFloat vH = 2;
        CGFloat vY = self.frame.size.height - vH;
        view.frame = CGRectMake(view.frame.origin.x, vY, btn.frame.size.width, vH);
        view.FillColor = [UIColor redColor].CGColor;
    }
    [self.navMenuScrollView addSubview:view];
}

- (void)btnClick:(LPMenuBtn *)btn
{
    if (self.selectedBtn == btn) {
        return;
    }
    [self resetSelectedBtn:btn.tag];
    if ([self.delegate respondsToSelector:@selector(menuViewBtnDidClickAtIndex:)]) {
        [self.delegate menuViewBtnDidClickAtIndex:btn.tag];
    }
}

- (void)selectedBtnMoveToCenterWithIndex:(NSInteger)index withRate:(CGFloat)pageRate
{
    NSString *notiName = [NSString stringWithFormat:@"scrollViewDidFinished%@", self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(move:) name:notiName object:nil];
    
    int page = (int)(pageRate + 0.5);
    CGFloat rate = pageRate - index;
    int count = (int)self.navMenuScrollView.subviews.count;
    if (pageRate < 0 || rate == 0 || index >= count - 1) {
        return;
    }
    self.selectedBtn.selected = NO;
    LPMenuBtn *currentBtn = self.navMenuScrollView.subviews[index];
    LPMenuBtn *nextBtn = self.navMenuScrollView.subviews[index + 1];
    
    if (self.style == MenuViewStyleDefault) {
        [currentBtn changeSelectedColorAndScaleWithRate:rate];
        [nextBtn changeSelectedColorAndScaleWithRate:1 - rate];
    } else {
        CGFloat margin;
        if (pageRate < count-2){
            CGFloat lX;
            if (self.navMenuScrollView.contentSize.width < self.frame.size.width){
                margin = (ScreenWidth - self.sumWidth)/(self.navMenuScrollView.subviews.count + 1);
                lX =  currentBtn.frame.origin.x + (currentBtn.frame.size.width + margin + BtnMargin)* rate;
            }else{
                margin = BtnMargin;
                lX =  currentBtn.frame.origin.x + (currentBtn.frame.size.width + margin)* rate;
            }
            CGFloat lW =  currentBtn.frame.size.width + (nextBtn.frame.size.width - currentBtn.frame.size.width)*rate;
            self.line.frame = CGRectMake(lX, self.line.frame.origin.y, lW, self.line.frame.size.height);
            [currentBtn changeSelectedColorWithRate:rate];
            [nextBtn changeSelectedColorWithRate:1-rate];
        }

    }
    
    self.selectedBtn = self.navMenuScrollView.subviews[page];
    self.selectedBtn.selected = YES;
}

- (void)move:(NSNotification *)info
{
    NSNumber *index = info.userInfo[@"index"];
    [self moveViewWithIndex:[index intValue]];
}

- (void)moveViewWithIndex:(NSInteger)index
{
    LPMenuBtn *btn = self.navMenuScrollView.subviews[index];
    CGRect newFrame = [btn convertRect:self.bounds toView:nil];
    CGFloat distance = newFrame.origin.x - self.center.x;
    CGFloat scrollOffsetX = self.navMenuScrollView.contentOffset.x;
    int count = (int)self.navMenuScrollView.subviews.count;
    if (index > count - 1) {
        return;
    }
    CGFloat contentOffsetX = self.navMenuScrollView.contentOffset.x + btn.frame.origin.x > self.center.x ? scrollOffsetX + distance + btn.frame.size.width - BtnMargin * 4 : 0;
    [self.navMenuScrollView setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x <= 0) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    } else if (scrollView.contentOffset.x + self.frame.size.width >= scrollView.contentSize.width) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width - self.frame.size.width, 0)];
    }
}

- (void)resetSelectedBtn:(NSInteger)tag
{
    for (LPMenuBtn *btn in self.navMenuScrollView.subviews) {
        if (btn.tag == tag) {
            btn.selected = YES;
            self.selectedBtn = btn;
        } else {
            btn.selected = NO;
        }
    }
    [self moveViewWithIndex:self.selectedBtn.tag];
    if (self.style == MenuViewStyleDefault) {
        [self.selectedBtn selectedItemWithoutAnimation];
        [self.selectedBtn deselectedItemWithoutAnimation];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat x = self.selectedBtn.frame.origin.x;
            CGFloat w = self.selectedBtn.frame.size.width;
            self.line.frame = CGRectMake(x, self.line.frame.origin.y, w, self.line.frame.size.height);
        }];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
